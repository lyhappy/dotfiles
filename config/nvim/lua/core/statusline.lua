----------------------------------------------------------
-- Statusline configuration file
-----------------------------------------------------------

-- Plugin: feline.nvim (freddiehaddad fork)
-- URL: https://github.com/freddiehaddad/feline.nvim

-- For the configuration see the Usage section:
-- https://github.com/freddiehaddad/feline.nvim/blob/master/USAGE.md

-- Thanks to ibhagwan for the example to follow:
-- https://github.com/ibhagwan/nvim-lua

local status_ok, feline = pcall(require, 'lualine')
if not status_ok then
  return
end

require('lualine').setup {
  -- Global options
  -- https://github.com/nvim-lualine/lualine.nvim#global-options
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
      'NvimTree',
    },
    ignore_focus = {},
    always_divide_middle = true,
    always_show_tabline = false,
    globalstatus = false,
    refresh = {
      statusline = 100,
      tabline = 100,
      winbar = 100,
    }
  },

  -- General component options
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff',
      {
        'diagnostics',
        sources = {'nvim_lsp'},
      }
    },
    lualine_c = {
      { 'filename', path=3 }
    },
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      { 'filename', path=3 }
    },
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {
  },
  inactive_winbar = {},
  extensions = {"nvim-tree"}
}
