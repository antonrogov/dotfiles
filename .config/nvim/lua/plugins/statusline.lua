local function create_theme()
  local colors
    colors = {
      bg = '#3a3a3a', -- 237
      inactive_bg = '#303030', -- 234
      alt_bg = '#444444', -- 238
      dark_fg = '#9e9e9e', -- 247
      fg = '#b2b2b2', -- 249
      light_fg = '#c0c0c0', -- 7 white
      normal = '#000080', -- 4 blue
      insert = '#008000', -- 2 green
      visual = '#800080', -- 5 magenta
      replace = '#de935f',
    }
  -- end

  local theme = {
    normal = {
      a = { fg = colors.bg, bg = colors.normal },
      b = { fg = colors.light_fg, bg = colors.alt_bg },
      c = { fg = colors.fg, bg = colors.bg },
    },
    replace = {
      a = { fg = colors.bg, bg = colors.replace },
      b = { fg = colors.light_fg, bg = colors.alt_bg },
    },
    insert = {
      a = { fg = colors.bg, bg = colors.insert },
      b = { fg = colors.light_fg, bg = colors.alt_bg },
    },
    visual = {
      a = { fg = colors.bg, bg = colors.visual },
      b = { fg = colors.light_fg, bg = colors.alt_bg },
    },
    inactive = {
      a = { fg = colors.dark_fg, bg = colors.inactive_bg },
      b = { fg = colors.dark_fg, bg = colors.inactive_bg },
      c = { fg = colors.dark_fg, bg = colors.inactive_bg },
    },
  }

  theme.command = theme.normal
  theme.terminal = theme.insert

  return theme
end

return {
  'nvim-lualine/lualine.nvim',
  opts = {
    options = {
      icons_enabled = false,
      theme = create_theme(),
      component_separators = { left = '', right = ''},
      section_separators = { left = '', right = ''},
      disabled_filetypes = {
        statusline = {},
        winbar = {},
      },
      ignore_focus = {},
      always_divide_middle = true,
      always_show_tabline = true,
      globalstatus = false,
      refresh = {
        statusline = 100,
        tabline = 100,
        winbar = 100,
      }
    },
    sections = {
      lualine_a = {'mode'},
      -- lualine_b = {'branch', 'diff', 'diagnostics'},
      lualine_b = {
        {
          'diagnostics',
          diagnostics_color = {
            error = 'DiagnosticError',
            warn  = 'DiagnosticWarn',
            info  = 'DiagnosticInfo',
            hint  = 'DiagnosticHint',
          },
          symbols = { error = '', warn = '', info = '', hint = '' },
        },
      },
      lualine_c = {'filename'},
      lualine_x = {}, -- {'encoding', 'fileformat', 'filetype'},
      lualine_y = {'progress'},
      lualine_z = {'location'}
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {'filename'},
      lualine_x = {'location'},
      lualine_y = {},
      lualine_z = {}
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {}
  },
}
