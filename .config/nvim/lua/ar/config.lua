local util = require('ar.util')

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local opt = vim.opt

opt.guicursor = ''
opt.termguicolors = false
vim.cmd.colorscheme('ar')

opt.number = true
opt.relativenumber = true
opt.signcolumn = 'yes'

opt.cursorline = true
opt.textwidth = 100
opt.colorcolumn = '+1'

opt.foldenable = false
opt.foldmethod = 'manual'
opt.foldlevelstart = 99

opt.list = true
opt.listchars = { tab = '· ', trail = '·', nbsp = '␣' }

opt.showmode = false

opt.hlsearch = false
opt.incsearch = true
opt.inccommand = 'split'
opt.smartcase = true
opt.ignorecase = true
opt.scrolloff = 8
opt.wrap = false

opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true

opt.smartindent = true

opt.swapfile = false
opt.backup = false
opt.backupcopy = 'yes'

opt.undodir = vim.fn.stdpath('data') .. '/undodir'
opt.undofile = true

opt.updatetime = 50

opt.wildmode = 'list:longest'

opt.clipboard = 'unnamedplus'

vim.diagnostic.config({
  severity_sort = true,
  float = {
    border = 'rounded',
    header = '',
    source = 'if_many',
  },
  underline = { severity = vim.diagnostic.severity.ERROR },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '￭',
      [vim.diagnostic.severity.WARN] = '￭',
      [vim.diagnostic.severity.INFO] = '￭',
      [vim.diagnostic.severity.HINT] = '￭',
    },
  },
  virtual_text = {
    source = 'if_many',
    prefix = '◼︎',
    spacing = 2,
    format = function(diagnostic)
      return diagnostic.message
    end,
  },
})

local ru = [[абвгдеёжзийклмнопрстуфхцчшщъыьэюяАБВДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ]]
local en = [[f,dult\;pbqrkvyjghcnea[wxio]sm'.zF<DLT|:PBQRKVYJGHCNEA<WXIO}SM">Z]]
vim.opt.langmap = ru .. ";" .. vim.fn.escape(en, ';,"|\\')

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
keymap.set('v', '<', '<gv', opts)
keymap.set('v', '>', '>gv', opts)

keymap.set({ 'n', 'i', 't' }, '<C-h>', function() vim.cmd.wincmd('h') end, opts)
keymap.set({ 'n', 'i', 't' }, '<C-j>', function() vim.cmd.wincmd('j') end, opts)
keymap.set({ 'n', 'i', 't' }, '<C-k>', function() vim.cmd.wincmd('k') end, opts)
keymap.set({ 'n', 'i', 't' }, '<C-l>', function() vim.cmd.wincmd('l') end, opts)

keymap.set('n', '-', '<CMD>Oil<CR>')

keymap.set('n', '<leader>,', '<C-^>', opts)

keymap.set('n', '<leader>q', '<cmd>q<cr>', opts)

keymap.set('n', '<leader>fD', function()
  local path = vim.fn.expand('%:p')
  Snacks.bufdelete({ wipe = true })
  util.trash_file(path)
end, opts)

keymap.set('n', '<leader>fR', function()
  local old_name = vim.fn.expand('%')
  local new_name = vim.fn.input('Rename to: ', old_name, 'file')
  if new_name == '' or new_name == old_name then return end

  vim.cmd.saveas(new_name)
  util.trash_file(old_name)
end, opts)

keymap.set('n', '<leader>fe', function()
  vim.api.nvim_feedkeys(':e ' .. vim.fn.expand('%:h') .. '/', 'n', false)
end, opts)

keymap.set('n', '<leader>ft', function()
  -- vim.fn.jobstart(vim.o.shell, { cwd = require('ar.util').get_buf_dir(), term = true })
  vim.cmd('lcd ' .. vim.fn.expand('%:h'))
  vim.cmd.terminal()
  vim.cmd('lcd -')
end, opts)

keymap.set('n', '<leader>fy', function() vim.fn.setreg('+', vim.fn.expand('%')) end, opts)
keymap.set('n', '<leader>fY', function() vim.fn.setreg('+', vim.fn.expand('%:p')) end, opts)

keymap.set('n', 'ge', vim.diagnostic.open_float)

keymap.set('n', '[e', ':cp<CR>', opts)
keymap.set('n', ']e', ':cn<CR>', opts)

keymap.set('n', '<leader>pt', function() vim.cmd.terminal() end, opts)
keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', opts)

keymap.set('n', '<Enter>', function() require('ar.commands').run() end)

keymap.set('n', '<C-c>', function()
  if not util.term_passthrough('\x03') then
    vim.api.nvim_feedkeys('<Esc>', 'n', false)
  end
end)

keymap.set('n', '<leader>wo', function() require('ar.fullscreen').toggle() end)

keymap.set('n', '<leader>mp', function()
  local text = vim.api.nvim_exec('messages', true)
  local lines = vim.split(text, '\n')
  vim.api.nvim_buf_set_lines(0, 0, -1, true, lines)
end, opts)

vim.api.nvim_create_autocmd('VimResized', {
  pattern = '*',
  callback = function(data)
    vim.cmd.wincmd('=')
  end,
})
