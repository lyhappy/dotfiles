--------------------------------------------
-- Plugin manager configuration file
--------------------------------------------
-- Plugin manager: lazy.nvim

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local status_ok, lazy = pcall(require, 'lazy')
if not status_ok then
  return
end

-- Start setup
lazy.setup({
  spec = {
    -- Colorscheme:
    {
      "folke/tokyonight.nvim",
      lazy = false,
      priority = 100,
      opts = {},
    },
    { 'arcticicestudio/nord-vim'},
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    { 'rose-pine/neovim', name = 'rose-pine'},

    -- Icons
    { 'nvim-tree/nvim-web-devicons', lazy = true},

    -- Dashboard ( start screen )
    { 'goolord/alpha-nvim', dependencies = { 'nvim-tree/nvim-web-devicons' }, },

    -- Git labels
    {
      'lewis6991/gitsigns.nvim',
      lazy = true,
      dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-tree/nvim-web-devicons',
      },
      config = function()
        require('gitsigns').setup{}
      end
    },

    { 'tpope/vim-fugitive' }, -- Git commands

    -- File explorer
    {
      'nvim-tree/nvim-tree.lua',
      dependencies = { 'nvim-tree/nvim-web-devicons' },
    },

    {
      'nvim-telescope/telescope.nvim',
      dependencies = { 'nvim-lua/plenary.nvim'},
    },

    -- Statusline
    {
      'nvim-lualine/lualine.nvim',
      dependencies = {
        'nvim-tree/nvim-web-devicons',
        'lewis6991/gitsigns.nvim',
      },
    },

    -- Treesitter
    { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },

    -- Indent line
    { 'lukas-reineke/indent-blankline.nvim', main = 'ibl', opts = {} },
    { 'norcalli/nvim-colorizer.lua'},

    -- Tag viewer
    { 'preservim/tagbar' },

    -- Autopair
    {
      'windwp/nvim-autopairs',
      event = 'InsertEnter',
      config = function()
        require('nvim-autopairs').setup{}
      end
    },

    { 'numToStr/Comment.nvim' },

    -- LSP
    { 'neovim/nvim-lspconfig' },

    -- Autocomplete
    {
      'saghen/blink.cmp',
      dependencies = {
        'rafamadriz/friendly-snippets',
        'Kaiser-Yang/blink-cmp-dictionary',
        dependencies = { 'nvim-lua/plenary.nvim' }
      },
      version = '1.*',

      ---@module 'blink.cmp'
      ---@type blink.cmp.Config
      opts = {
        -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
        -- 'super-tab' for mappings similar to vscode (tab to accept)
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- All presets have the following mappings:
        -- C-space: Open menu or open docs if already open
        -- C-n/C-p or Up/Down: Select next/previous item
        -- C-e: Hide menu
        -- C-k: Toggle signature help (if signature.enabled = true)
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        keymap = { preset = 'super-tab' },
        appearance = {
          nerd_font_variant = 'mono'
        },
        completion = { documentation = { auto_show = false } },
        sources = {
          default = {'lsp', 'dictionary', 'path', 'snippets', 'buffer'},
          providers = {
            dictionary = {
              module = 'blink-cmp-dictionary',
              name = 'Dict',
              min_keyword_length = 3,
              opts = {
                dictionary_directories = { vim.fn.expand('~/.config/nvim/dictionary') },
              }
            }
          }
        },
        fuzzy = { implementation = "prefer_rust_with_warning" }
      },
      opts_extend = { "sources.default" }
    },
    {
      'smoka7/hop.nvim',
      version = "*",
      opts = {
        keys = 'etovxqpdygfblzhckisuran'
      }
    },

    { "itchyny/calendar.vim" },
    -- { 'rcarriga/nvim-notify' }
    {
      'MeanderingProgrammer/render-markdown.nvim',
      dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' }, -- if you use the mini.nvim suite
      -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' }, -- if you use standalone mini plugins
      -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
      ---@module 'render-markdown'
      ---@type render.md.UserConfig
      opts = {},
    },
    {
      "folke/which-key.nvim",
      event = "VeryLazy",
      opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      },
      keys = {
        {
          "<leader>?",
          function()
            require("which-key").show({ global = false })
          end,
          desc = "Buffer Local Keymaps (which-key)",
        },
      },
    }
  }
})
