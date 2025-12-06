return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  config = function () 
    local configs = require('nvim-treesitter.configs')

    configs.setup({
      ensure_installed = {
        'c',
        'cpp',
        'html',
        'javascript',
        'json',
        'lua',
        'markdown_inline',
        'markdown',
        'query',
        'ruby',
        'rust',
        'slim',
        'swift',
        'tsx',
        'typescript',
        'vim',
        'vimdoc',
        'yaml',
      },
      sync_install = false,
      auto_install = false,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = false,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = 'g<Enter>', -- set to `false` to disable one of the mappings
          node_incremental = 'g<Enter>',
          scope_incremental = false,
          node_decremental = 'g<Backspace>',
        },
      },
    })
  end
}
