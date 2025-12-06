local function is_inside_word()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  if col == 0 then return false end

  local line = vim.api.nvim_get_current_line()
  local char = vim.fn.strcharpart(line, col - 1, 1)
  return char:match('%s') == nil
end

return {
  'saghen/blink.cmp',
  -- optional: provides snippets for the snippet source
  dependencies = { 'rafamadriz/friendly-snippets' },

  -- use a release tag to download pre-built binaries
  version = '1.*',
  -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
  -- build = 'cargo build --release',
  -- If you use nix, you can build from source using latest nightly rust with:
  -- build = 'nix run .#build-plugin',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      preset = 'none',
      ['<C-e>'] = { 'hide' },
      ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
      ['<CR>'] = { 'accept', 'fallback' },
      ['<Tab>'] = {
        function(cmp)
          -- if is_inside_word() then return cmp.show_and_insert() end
          if is_inside_word() then return cmp.show() end
          vim.api.nvim_feedkeys('\t', 'n', false)
          return true
        end,
        'select_next',
        'snippet_forward',
        'fallback'
      }, ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
    },

    appearance = {
      -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono'
    },

    completion = {
      list = {
        selection = {
          preselect = false,
          auto_insert = true,
        },
      },
      menu = { auto_show = false },
      documentation = {
        auto_show = true,
        window = { border = 'rounded' },
      },
    },

    signature = {
      enabled = true,
      window = { border = 'rounded' },
    },

    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      -- default = { 'lsp', 'path', 'snippets', 'buffer' },
      default = { 'lsp', 'buffer' },
      providers = {
        buffer = {
          opts = {
            get_bufnrs = function()
              return vim
                .iter(vim.api.nvim_list_wins())
                :map(function(win) return vim.api.nvim_win_get_buf(win) end)
                :filter(function(buf)
                  return vim.bo[buf].buftype ~= 'nofile' and vim.bo[buf].buftype ~= 'terminal'
                end)
                :totable()
            end,
          },
        },
        path = {
          async = true,
          fallbacks = {},
        },
        lsp = {
          -- async = true,
          timeout_ms = 250,
          fallbacks = {},
        },
        snippets = { fallbacks = {} },
      },
    },

    -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
    -- You may use a lua implementation instead by using `implementation = 'lua'` or fallback to
    -- the lua implementation, when the Rust fuzzy matcher is not available, by using
    -- `implementation = 'prefer_rust'`
    --
    -- See the fuzzy documentation for more information
    fuzzy = { implementation = 'prefer_rust_with_warning' },
    cmdline = { enabled = false },
  },
  opts_extend = { 'sources.default' },
}
