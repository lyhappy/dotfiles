-----------------------------------------------------------
-- Define keymaps of Neovim and installed plugins.
-----------------------------------------------------------

local function map(mode, lhs, rhs, opts)
  local options = { noremap=true, silent=true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Change leader to a comma
vim.g.mapleader = ','

vim.keymap.set("n", ";", ":")

-----------------------------------------------------------
-- Neovim shortcuts
-----------------------------------------------------------

-- Disable arrow keys
map('', '<up>', '<nop>')
map('', '<down>', '<nop>')
map('', '<left>', '<nop>')
map('', '<right>', '<nop>')

-- Map Esc to kk
map('i', 'jk', '<Esc>')

-- map('n', ';', ':')

-- Clear search highlighting with <leader> and c
map('n', '<leader>c', ':nohl<CR>')

-- Toggle auto-indenting for code paste
-- map('n', '<F2>', ':set invpaste paste?<CR>')
-- vim.opt.pastetoggle = '<F2>'

-- Change split orientation
map('n', '<leader>tk', '<C-w>t<C-w>K') -- change vertical to horizontal
map('n', '<leader>th', '<C-w>t<C-w>H') -- change horizontal to vertical

-- Move around splits using Ctrl + {h,j,k,l}
map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')

-- Reload configuration without restart nvim
map('n', '<leader>ev', "<cmd>e $MYVIMRC<CR>")
map('n', '<leader>sv', "<cmd>so $MYVIMRC<CR>")

-- Fast saving with <leader> and s
map('n', '<leader>w', ':w<CR>')

-- Close all windows and exit from Neovim with <leader> and q
map('n', '<leader>q', ':q<CR>')

-- Keeping it centered
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-----------------------------------------------------------
-- Applications and Plugins shortcuts
-----------------------------------------------------------

-- Terminal mappings
map('n', '<C-t>', ':Term<CR>', { noremap = true })  -- open
map('t', '<Esc>', '<C-d><C-n>')                    -- exit

-- NvimTree
map('n', '<C-n>', ':NvimTreeToggle<CR>')            -- open/close
map('n', '<leader>fr', ':NvimTreeRefresh<CR>')       -- refresh
map('n', '<leader>ff', ':NvimTreeFindFile<CR>')      -- search file

-- Tagbar
map('n', '<leader>z', ':TagbarToggle<CR>')          -- open/close

-- Git
-- for plugin tpope/vim-fugitive
map('n', '<leader>gd', ':Gvdiffsplit<cr>')
map('n', '<leader>gw', ':Gwriter<cr>')
map('n', '<leader>gr', ':Gread<cr>')
map('n', '<leader>gc', ':Git commit<cr>')
map('n', '<leader>gl', ':Gclog<cr>')
map('n', '<leader>gb', ':Git blame<cr>')

-- for comment.nvim
require('Comment').setup()
-- vim.keymap.set("n", "<C-_>", function() require('Comment.api').toggle.linewise.current() end, { noremap = true, silent = true })
-- Toggle current line (linewise) using C-/
local api = require('Comment.api')
vim.keymap.set('n', '<C-_>', api.toggle.linewise.current)

-- Toggle current line (blockwise) using C-\
vim.keymap.set('n', '<C-\\>', api.toggle.blockwise.current)

local esc = vim.api.nvim_replace_termcodes(
    '<ESC>', true, false, true
)

-- Toggle selection (linewise)
vim.keymap.set('x', '<C-_>', function()
    vim.api.nvim_feedkeys(esc, 'nx', false)
    api.toggle.linewise(vim.fn.visualmode())
end)

-- Toggle selection (blockwise)
vim.keymap.set('x', '<C-\\>', function()
    vim.api.nvim_feedkeys(esc, 'nx', false)
    api.toggle.blockwise(vim.fn.visualmode())
end)

vim.keymap.set("n", "<leader><CR>", "<cmd>lua ReloadConfig()<CR>", { noremap = true, silent = false })

