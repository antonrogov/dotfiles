local nvim_terminal_augroup = vim.api.nvim_create_augroup('nvim.terminal', { clear = true })
local nvim_terminal_prompt_ns = vim.api.nvim_create_namespace('nvim.terminal.prompt')

---@param ns integer
---@param buf integer
---@param count integer
local function jump_to_prompt(ns, win, buf, count)
  local row, col = unpack(vim.api.nvim_win_get_cursor(win))
  local start = -1
  local end_ ---@type 0|-1
  if count > 0 then
    start = row
    end_ = -1
  elseif count < 0 then
    -- Subtract 2 because row is 1-based, but extmarks are 0-based
    start = row - 2
    end_ = 0
  end

  if start < 0 then
    return
  end

  local extmarks = vim.api.nvim_buf_get_extmarks(
    buf,
    ns,
    { start, col },
    end_,
    { limit = math.abs(count) }
  )
  if #extmarks > 0 then
    local extmark = extmarks[math.min(#extmarks, math.abs(count))]
    vim.api.nvim_win_set_cursor(win, { extmark[2] + 1, extmark[3] })
  end
end

vim.api.nvim_create_autocmd('TermOpen', {
  group = nvim_terminal_augroup,
  desc = 'Default settings for :terminal buffers',
  callback = function(args)
    vim.bo[args.buf].modifiable = false
    vim.bo[args.buf].undolevels = -1
    vim.bo[args.buf].scrollback = vim.o.scrollback < 0 and 10000 or math.max(1, vim.o.scrollback)
    vim.bo[args.buf].textwidth = 0
    vim.wo[0][0].wrap = false
    vim.wo[0][0].list = false
    vim.wo[0][0].number = false
    vim.wo[0][0].relativenumber = false
    vim.wo[0][0].signcolumn = 'no'
    vim.wo[0][0].foldcolumn = '0'

    -- This is gross. Proper list options support when?
    local winhl = vim.o.winhighlight
    if winhl ~= '' then
      winhl = winhl .. ','
    end
    vim.wo[0][0].winhighlight = winhl .. 'StatusLine:StatusLineTerm,StatusLineNC:StatusLineTermNC'

    vim.keymap.set({ 'n', 'x', 'o' }, '[[', function()
      jump_to_prompt(nvim_terminal_prompt_ns, 0, args.buf, -vim.v.count1)
    end, { buffer = args.buf, desc = 'Jump [count] shell prompts backward' })
    vim.keymap.set({ 'n', 'x', 'o' }, ']]', function()
      jump_to_prompt(nvim_terminal_prompt_ns, 0, args.buf, vim.v.count1)
    end, { buffer = args.buf, desc = 'Jump [count] shell prompts forward' })

    vim.cmd.startinsert()
  end,
})

vim.api.nvim_create_autocmd('TermClose', {
  group = nvim_terminal_augroup,
  callback = function(data)
    if vim.bo.filetype == '' then
      Snacks.bufdelete({ wipe = true })
    end
  end,
})

vim.api.nvim_create_autocmd('TermRequest', {
  group = nvim_terminal_augroup,
  desc = 'Handles OSC foreground/background color requests',
  callback = function(args)
    --- @type integer
    local channel = vim.bo[args.buf].channel
    if channel == 0 then
      return
    end
    local fg_request = args.data.sequence == '\027]10;?'
    local bg_request = args.data.sequence == '\027]11;?'
    if fg_request or bg_request then
      -- WARN: This does not return the actual foreground/background color,
      -- but rather returns:
      --   - fg=white/bg=black when Nvim option 'background' is 'dark'
      --   - fg=black/bg=white when Nvim option 'background' is 'light'
      local red, green, blue = 0, 0, 0
      local bg_option_dark = vim.o.background == 'dark'
      if (fg_request and bg_option_dark) or (bg_request and not bg_option_dark) then
        red, green, blue = 65535, 65535, 65535
      end
      local command = fg_request and 10 or 11
      local data = string.format('\027]%d;rgb:%04x/%04x/%04x\007', command, red, green, blue)
      vim.api.nvim_chan_send(channel, data)
    end
  end,
})

vim.api.nvim_create_autocmd('TermRequest', {
  group = nvim_terminal_augroup,
  desc = 'Mark shell prompts indicated by OSC 133 sequences for navigation',
  callback = function(args)
    if string.match(args.data.sequence, '^\027]133;A') then
      local lnum = args.data.cursor[1] ---@type integer
      vim.api.nvim_buf_set_extmark(args.buf, nvim_terminal_prompt_ns, lnum - 1, 0, {})
    end
  end,
})
