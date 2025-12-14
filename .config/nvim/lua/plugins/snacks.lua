local util = require('ar.util')

return {
  'folke/snacks.nvim',
  -- 'antonrogov/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bufdelete = {},
    image = {
      enabled = true,
      cterm256 = true,
      debug = {
        request = false,
      },
    },
    picker = {
      main = { current = true },
      preview_no_winopts = true,
      jump = { reuse_win = true },
      icons = {
        term = ' ',
        files = {
          file = '',
        },
      },
      win = {
        input = {
          keys = {
            ['<c-e>'] = { 'qflistgo', mode = { 'i', 'n' } },
          }
        }
      },
      actions = {
        qflistgo = function(picker)
          picker:close()

          local qf = {} ---@type vim.quickfix.entry[]
          for _, item in ipairs(picker:items()) do
            qf[#qf + 1] = {
              filename = Snacks.picker.util.path(item),
              bufnr = item.buf,
              lnum = item.pos and item.pos[1] or 1,
              col = item.pos and item.pos[2] + 1 or 1,
              end_lnum = item.end_pos and item.end_pos[1] or nil,
              end_col = item.end_pos and item.end_pos[2] + 1 or nil,
              text = item.line or item.comment or item.label or item.name or item.detail or item.text,
              pattern = item.search,
              valid = true,
            }
          end

          vim.fn.setqflist(qf)
          vim.cmd('cn')
        end,
      },
      layout = {
        layout = {
          box = 'horizontal',
          width = 0.85,
          min_width = 100,
          max_width = 200,
          height = 0.85,
          {
            box = 'vertical',
            border = 'rounded',
            title = nil,
            { win = 'input', height = 1, border = 'bottom' },
            { win = 'list', border = 'none' },
          },
          { win = 'preview', title = nil, border = 'rounded', width = 0.5 },
        },
      }
    },
  },
  keys = {
    { 'gt', function () Snacks.picker.treesitter() end },
    { '<leader>q', function() Snacks.bufdelete({ wipe = true }) end },
    { '<leader>.', function() Snacks.picker.files({ hidden = true }) end },
    { '<leader>/', function() Snacks.picker.grep({ hidden = true }) end },
    { '<leader>;', function() Snacks.picker.buffers() end },
    { '<leader>ff', function() Snacks.picker.files({ cwd = util.get_buf_dir() }) end },
    { '<leader>fg', function() Snacks.picker.grep({ cwd = util.get_buf_dir() }) end },
    { '<leader>fr', function() Snacks.picker.recent() end },
    { '<leader>gl', function() Snacks.picker.git_log_file() end },
    { '<leader>hk', function() Snacks.picker.keymaps() end },
    { '<leader>ho', function() Snacks.picker.help() end },
    { '<leader>t', function()
      Snacks.picker({
        layout = {
          layout = {
            box = "horizontal",
            width = 0.8,
            min_width = 120,
            max_width = 200,
            height = 0.8,
            {
              box = "vertical",
              border = "rounded",
              title = "",
              width = 0.25,
              { win = "input", height = 1, border = "bottom" },
              { win = "list", border = "none" },
            },
            { win = "preview", title = "", border = "rounded" },
          },
        },
        win = {
          input = {
            keys = {
              ['<a-a>'] = { 'new', mode = { 'i', 'n' } },
              ['<a-e>'] = { 'rename', mode = { 'i', 'n' } }
            }
          }
        },
        actions = {
          new = function(picker)
            picker:norm(function()
              picker:close()
              vim.cmd.term()
            end)
          end,
          rename = function(picker)
            local item = picker:current()
            local new_name = vim.fn.input('Rename to: ')
            util.set_term_name(item.buf, new_name)
            item.text = new_name
            picker:update({ force = true })
          end,
        },
        finder = function(opts, ctx)
          local items = {} ---@type snacks.picker.finder.Item[]
          util.list_terms(items)
          table.sort(items, function(a, b)
            return a.info.lastused > b.info.lastused
          end)
          if #items == 0 then
            vim.cmd.term()
          end
          return ctx.filter:filter(items)
        end,
        format = function(item, picker)
          local ret = {} ---@type snacks.picker.Highlight[]
          ret[#ret + 1] = { ' ', "SnacksPickerDirectory" }
          ret[#ret + 1] = { " " }
          local name = vim.trim(item.text:gsub("\r?\n", " "))
          Snacks.picker.highlight.format(item, name, ret)
          return ret
        end,
        confirm = function(picker, _, action)
          picker:norm(function()
            Snacks.picker.actions.jump(picker, _, action)
            vim.cmd.startinsert()
          end)
        end,
      })
    end },
  }
}
