local util = require('ar.util')

local M = {}

function M.run()
  if util.term_passthrough('\n') then return end

  local buf = util.open_term('cmd')

  vim.defer_fn(function()
    local chan = vim.api.nvim_buf_get_option(buf, 'channel')
    vim.api.nvim_chan_send(chan, '\x10')
  end, 100)
end

return M
