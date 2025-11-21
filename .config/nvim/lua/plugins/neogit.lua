local util = require('ar.util')

return {
  'NeogitOrg/neogit',
  -- 'antonrogov/neogit',
  -- branch = 'stack',
  dependencies = {
    'nvim-lua/plenary.nvim',         -- required
    'sindrets/diffview.nvim',        -- optional - Diff integration
    'folke/snacks.nvim',             -- optional
  },
  opts = {
    simple_headers = true,
    buffer_stack = true,
    disable_hint = true,
    force_if_includes = false,
    log_view_esc_close = false,
    hard_reset_backup = false,
    signs = {
      hunk = { '▶︎', '▼' },
      item = { '▶︎', '▼' },
      section = { '▶︎', '▼' },
    },
    -- floating = {
    --   border = 'none',
    -- },
    -- graph_style = 'unicode',
    kind = 'stack',
    commit_editor = {
      kind = 'stack'
    },
    commit_view = {
      kind = 'stack'
    },
    commit_select_view = {
      kind = 'stack'
    },
    log_view = {
      kind = 'stack'
    },
    refs_view = {
      kind = 'stack'
    },
    rebase_editor = {
      kind = 'stack'
    },
    stash = {
      kind = 'stack'
    },
    integrations = {
      diffview = false,
    },
    -- filewatcher = {
    --   enabled = false,
    -- },
    mappings = {
      finder = {
        ['<esc>'] = false,
      },
      popup = {
        ['p'] = 'PushPopup',
        ['F'] = 'PullPopup',
        ['O'] = 'ResetPopup',
        ['Z'] = 'StashPopup',
        ['R'] = 'RevertPopup',
        ['v'] = false,
      },
      status = {
        ['gr'] = 'RefreshBuffer',
        ['<c-k>'] = false,
        ['<c-j>'] = false,
      }
    }
  },
  keys = {
    { '<leader>gs', function()
      require('neogit').open({ cwd = util.get_buf_dir() })
    end },
    { '<leader>gL', function()
        require('neogit').action('log', 'log_all_references', { '--graph', '--decorate' })()
      end },
  },
}
