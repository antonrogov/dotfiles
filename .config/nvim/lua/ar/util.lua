local M = {
  term_names = {},
  term_id = 0,
}

function M.get_buf_dir()
  local dir = vim.fn.expand('%:h')
  if dir == '' or string.sub(dir, 1, 7) == 'term://' then dir = vim.uv.cwd() end
  return dir:gsub('oil://', '')
end

function M.trash_file(path)
  if string.sub(path, 1, 1) ~= '/' then return end
  require('oil.adapters.trash').delete_to_trash(path, function(err) print(err) end)
end

function M.switch_to_buf(buf)
  for _, w in ipairs(vim.fn.win_findbuf(buf)) do
    if vim.api.nvim_win_get_config(w).relative == "" then
      vim.api.nvim_set_current_win(w)
      return w
    end
  end

  vim.api.nvim_set_current_buf(buf)
  return nil
end

function M.open_term(name)
  for buf, buf_name in ipairs(M.term_names) do
    if not vim.api.nvim_buf_is_valid(buf) then
      M.term_names[buf] = nil
    else
      local chan = vim.api.nvim_buf_get_option(buf, 'channel')
      if not chan or chan == 0 then
        M.term_names[buf] = nil
      elseif buf_name == name then
        M.switch_to_buf(buf)
        vim.cmd.startinsert()
        return buf
      end
    end
  end

  vim.cmd.terminal()
  local buf = vim.api.nvim_get_current_buf()
  M.set_term_name(buf, name)
  return buf
end

function M.set_term_name(buf, name)
  M.term_names[buf] = name
end

function M.list_terms(items)
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buftype == "terminal" and
      vim.bo[buf].buflisted and
      vim.api.nvim_buf_is_loaded(buf) then
      if not M.term_names[buf] then
        M.term_id = M.term_id + 1
        M.set_term_name(buf, "Terminal " .. M.term_id)
      end
      local name = M.term_names[buf]
      local info = vim.fn.getbufinfo(buf)[1]
      table.insert(items, {
        buf = buf,
        text = name,
        file = name,
        info = info,
      })
    end
  end
end

return M
