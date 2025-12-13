local function enable_servers(config)
  for name, opts in pairs(config) do
    vim.lsp.config(name, opts)
    vim.lsp.enable(name)
  end
end

return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'j-hui/fidget.nvim', opts = {} },
    'saghen/blink.cmp',
  },
  config = function()
    vim.lsp.set_log_level('off')
    enable_servers({
      eslint = {},
      jsonls = {},
      rust_analyzer = {
        settings = {
          ["rust-analyzer"] = {
            cargo = {
              features = 'all',
            },
            checkOnSave = {
              enable = true,
            },
            check = {
              command = 'clippy',
            },
            imports = {
              group = {
                enable = false,
              },
            },
            completion = {
              postfix = {
                enable = false,
              },
            },
          },
        },
      },
      solargraph = {
        root_markers = { '.solargraph.yml' },
      },
      stylelint_lsp = {
        settings = {
          stylelintplus = {
            autoFixOnFormat = true,
          },
        },
      },
      ts_ls = {
        root_markers = { 'tsconfig.json', 'jsconfig.json', 'package.json' },
      },
    })

    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(args)
        vim.keymap.set('n', 'ga', vim.lsp.buf.code_action, { buffer = 0 })
        vim.keymap.set('n', 'gd', Snacks.picker.lsp_definitions, { buffer = 0 })
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = 0 })
        vim.keymap.set('n', 'gs', Snacks.picker.lsp_symbols, { buffer = 0 })
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = 0 })
        vim.keymap.set('n', 'gT', vim.lsp.buf.type_definition, { buffer = 0 })
        vim.keymap.set('n', 'K', function() vim.lsp.buf.hover({ border = 'rounded' }) end, { buffer = 0 })
        vim.keymap.set('n', 'gk', function() vim.lsp.buf.signature_help({ border = 'rounded', title = '' }) end, { buffer = 0 })
        vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format, { buffer = 0 })
        vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, { buffer = 0 })
        vim.keymap.set('n', '<leader>lR', function()
          vim.ui.select(vim.lsp.get_clients(), {
            format_item = function(client)
              return client.name
            end,
          }, function(client)
            client:stop({ force = true })
          end)
        end, { buffer = 0 })
      end,
    })
  end,
}
