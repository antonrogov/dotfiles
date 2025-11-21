-- https://github.com/propet/toggle-fullscreen.nvim/blob/main/lua/toggle-fullscreen/init.lua
-- https://github.com/szw/vim-maximizer/blob/master/plugin/maximizer.vim

local M = {
  fullscreen = false
}

function M:toggle()
  if M.fullscreen then
    -- M.resize_cmd = vim.fn.winrestcmd()
    vim.api.nvim_command('exe g:ar_winrestcmd')
  else
    vim.api.nvim_command('let g:ar_winrestcmd = winrestcmd()')
    vim.api.nvim_command('vert resize | resize')
    -- M.resize_cmd = nil
  end

  M.fullscreen = not M.fullscreen
end

return M
