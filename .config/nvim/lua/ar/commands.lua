local util = require('ar.util')

local M = {}

function M.run()
  if util.term_passthrough('\n') then return end

  local buf = vim.api.nvim_get_current_buf()
  local win = vim.api.nvim_get_current_win()
  vim.cmd.write()

  local cmd = util.open_term('cmd', function ()
    vim.keymap.set('t', '<Enter>', function()
      vim.api.nvim_feedkeys('\n', 'n', false)

      vim.defer_fn(function ()
        vim.cmd.stopinsert()
        if vim.api.nvim_get_current_win() == win then
          vim.api.nvim_set_current_buf(buf)
        else
          vim.api.nvim_set_current_win(win)
        end
      end, 1)
    end, { buffer = 0 })
  end)

  vim.defer_fn(function()
    local chan = vim.api.nvim_buf_get_option(cmd, 'channel')
    vim.api.nvim_chan_send(chan, '\x10')
  end, 100)

end

return M
