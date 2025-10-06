-----------------------------------------------------------
-- Indent line configuration file
-----------------------------------------------------------

-- Plugin: indent-blankline
-- url: https://github.com/lukas-reineke/indent-blankline.nvim


local status_ok, ibl = pcall(require, 'ibl')
if not status_ok then
  return
end

local highlight = {
  "RainbowRed",
  "RainbowYellow",
  "RainbowBlue",
  "RainbowOrange",
  "RainbowGreen",
  "RainbowViolet",
  "RainbowCyan",
}

local hooks = require "ibl.hooks"
-- -- create the highlight groups in the highlight setup hook, so they are reset
-- -- every time the colorscheme changes
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
  vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#ED8796" })
  vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#EED49F" })
  vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#8AADF4" })
  vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#F5A97F" })
  vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#A6DA95" })
  vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C6A0F6" })
  vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#91D7E3" })
end)

vim.g.rainbow_delimiters = { highlight = highlight }
ibl.setup {
  scope = {
    enabled = true,
    show_exact_scope = true,
    highlight = highlight,
  },
  exclude = {
    filetypes = {
      'lspinfo',
      'packer',
      'checkhealth',
      'help',
      'man',
      'dashboard',
      'git',
      'markdown',
      'text',
      'terminal',
      'NvimTree',
    },

    buftypes = {
      'terminal',
      'nofile',
      'quickfix',
      'prompt',
    },
  },
}

hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
