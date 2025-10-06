-----------------------------------------------------------
-- Treesitter configuration file
----------------------------------------------------------

-- Plugin: nvim-treesitter
-- url: https://github.com/nvim-treesitter/nvim-treesitter

local status_ok, nvim_treesitter = pcall(require, 'nvim-treesitter.configs')
if not status_ok then
  return
end

-- See: https://github.com/nvim-treesitter/nvim-treesitter#quickstart
nvim_treesitter.setup {
  -- A list of parser names, or "all"
  -- See: `TSInstallInfo` commmand
  ensure_installed = {
    'awk', 'bash', 'c', 'cmake', 'cpp', 'css', 'html', 'javascript', 'json',
    'lua', 'python', 'rust', 'typescript', 'vim', 'yaml',
  },
  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,
  highlight = {
    -- `false` will disable the whole extension
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  -- 如果你也希望使用 treesitter 进行折叠，可以启用它
  fold = {
    enable = true,
    disable = { "markdown" } -- 可选: 为某些语言禁用 treesitter 折叠
  }
}
