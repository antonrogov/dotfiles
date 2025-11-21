return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    columns = {
      { 'permissions', highlight = 'NonText' },
      { 'size', highlight = 'Constant' },
      { 'mtime', highlight = 'Comment' },
    },
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,
    buf_options = {
      bufhidden = 'wipe',
    },
    keymaps = {
      ['<CR>'] = 'actions.select',
      ['<C-h>'] = false,
      ['<C-l>'] = false,
      ['q'] = { 'actions.close', mode = 'n' },
      ['-'] = { 'actions.parent', mode = 'n' },
      ['g?'] = { 'actions.show_help', mode = 'n' },
      ['gr'] = 'actions.refresh',
      ['gs'] = { 'actions.change_sort', mode = 'n' },
      ['go'] = 'actions.open_external',
      ['gh'] = { 'actions.toggle_hidden', mode = 'n' },
    },
  },
  -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
  lazy = false,
}
