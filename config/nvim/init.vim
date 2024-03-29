set nocompatible
filetype off

" {{{ use vim-plug manage plugins
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" }}}


let mapleader = ','
let g:mapleader = ','

""""""""""""""""""""""""""""""""
" => vim plugin list
""""""""""""""""""""""""""""""""
call plug#begin('~/.config/nvim/plugged')

" -------- Themes --------
  " Plug 'dracula/vim', {'as': 'dracula' }
  " Plug 'tomasr/molokai'
  " Plug 'fmoralesc/molokayo'
  Plug 'arcticicestudio/nord-vim'
  " Plug 'altercation/vim-colors-solarized'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
    " let g:airline_theme='atomic'
    " let g:airline_theme='nord'
    " let g:airline_theme='dracula'
    " let g:airline_theme='solarized'
    " let g:airline_solarized_bg='dark'
    let g:airline_powerline_fonts = 0
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#tab_nr_type = 1 " tab number
    let g:airline#extensions#tabline#show_tab_nr = 1
    let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
    let g:airline#extensions#tabline#buffer_nr_show = 0
    let g:airline#extensions#tabline#fnametruncate = 16
    let g:airline#extensions#tabline#fnamecollapse = 2
    let g:airline#extensions#tabline#buffer_idx_mode = 1
      nmap <leader>1 <Plug>AirlineSelectTab1
      nmap <leader>2 <Plug>AirlineSelectTab2
      nmap <leader>3 <Plug>AirlineSelectTab3
      nmap <leader>4 <Plug>AirlineSelectTab4
      nmap <leader>5 <Plug>AirlineSelectTab5
      nmap <leader>6 <Plug>AirlineSelectTab6
      nmap <leader>7 <Plug>AirlineSelectTab7
      nmap <leader>8 <Plug>AirlineSelectTab8
      nmap <leader>9 <Plug>AirlineSelectTab9
    set laststatus=2
  Plug 'mtdl9/vim-log-highlighting'

" -------- File Management --------
  Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
    nnoremap <leader>nf :NERDTreeFind<CR>
    nnoremap <F2> :NERDTreeToggle<CR>
    let g:NERDTreeShowBookmarks=1
    let g:NERDTreeDirArrowExpandable=''
    let g:NERDTreeDirArrowCollapsible=''
  Plug 'Xuyuanp/nerdtree-git-plugin', { 'on':  'NERDTree' }
    let g:NERDTreeGitStatusUseNerdFonts = 1
    let g:NERDTreeGitStatusShowIgnored = 0
    let g:NERDTreeGitStatusIndicatorMapCustom = {
        \ "Modified"  : "✹",
        \ "Staged"    : "✚",
        \ "Untracked" : "✭",
        \ "Renamed"   : "➜",
        \ "Unmerged"  : "═",
        \ "Deleted"   : "✖",
        \ "Dirty"     : "✗",
        \ "Clean"     : "✔︎",
        \ 'Ignored'   : '☒',
        \ "Unknown"   : "?"
        \ }
  Plug 'vifm/vifm.vim'
  Plug 'ryanoasis/vim-devicons'
  Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
  " Plug 'MattesGroeger/vim-bookmarks'

" -------- Productivity --------
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
    inoremap <M-f> :CocFix<cr>
    nnoremap <M-f> :CocFix<cr>
    nnoremap <M-a> :CocAction<cr>
  Plug 'mileszs/ack.vim'
    nnoremap <leader>a :Ack<space>
  Plug 'majutsushi/tagbar'
    nnoremap <F3> :Tagbar<cr>
    nnoremap <leader>tj :TagbarOpen j<cr>
  Plug 'liuchengxu/vista.vim'
  Plug 'easymotion/vim-easymotion'
    let g:EasyMotion_leader_key = '\'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'itchyny/calendar.vim'
  Plug 'nicwest/vim-http'
  Plug 'preservim/nerdcommenter'
    let g:NERDSpaceDelims=1
  Plug 'gyim/vim-boxdraw'
  " Plug 'neovim/nvim-lspconfig'
  " use snippets with coc-snippets
  Plug 'honza/vim-snippets'
  " Plug 'brglng/vim-im-select'

" -------- FE --------
  Plug 'posva/vim-vue'
    au BufNewFile,BufRead *.vue setf vue
    autocmd FileType vue syntax sync fromstart
  Plug 'ap/vim-css-color'

" -------- Markdown docs --------
  Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
  Plug 'mzlogin/vim-markdown-toc'
  Plug 'junegunn/goyo.vim', { 'for': 'markdown' }
  Plug 'junegunn/limelight.vim'
    let g:limelight_conceal_ctermfg = 'gray'
    let g:limelight_conceal_ctermfg = 240
  " {{{ Plug 'vimwiki/vimwiki'
  Plug 'vimwiki/vimwiki'
      let wiki_worknotes = {}
      let wiki_worknotes.path = '~/workspace/worknotes/'
      let wiki_worknotes.syntax = 'markdown'
      let wiki_worknotes.ext = '.md'
      let wiki_worknotes.index = 'README'
      let wiki_worknotes.path_html = '~/workspace/worknotes/html/'
      let wiki_worknotes.template_path = '~/workspace/worknotes/templates/'
      let wiki_worknotes.template_default = 'default'
      let wiki_worknotes.template_ext = '.tpl'
      let wiki_worknotes.custom_wiki2html = 'vimwiki_markdown'

      let wiki_studynotes = {}
      " let wiki_studynotes.path = '~/vimwiki/'

      let g:vimwiki_list = [wiki_worknotes, wiki_studynotes]
      nnoremap <leader>wtl :Ack -Q "[ ]" . -r<cr>
      let g:vimwiki_valid_html_tags = 'b,i,s,u,sub,sup,kbd,br,hr, pre, script'
  " }}}
  " {{{ Plug 'dhruvasagar/vim-table-mode'
  Plug 'dhruvasagar/vim-table-mode'
    function! s:isAtStartOfLine(mapping)
      let text_before_cursor = getline('.')[0 : col('.')-1]
      let mapping_pattern = '\V' . escape(a:mapping, '\')
      let comment_pattern = '\V' . escape(substitute(&l:commentstring, '%s.*$', '', ''), '\')
      return (text_before_cursor =~? '^' . ('\v(' . comment_pattern . '\v)?') . '\s*\v' . mapping_pattern . '\v$')
    endfunction

    inoreabbrev <expr> <bar><bar>
          \ <SID>isAtStartOfLine('\|\|') ?
          \ '<c-o>:TableModeEnable<cr><bar><space><bar><left><left>' : '<bar><bar>'
    inoreabbrev <expr> __
          \ <SID>isAtStartOfLine('__') ?
          \ '<c-o>:silent! TableModeDisable<cr>' : '__'
  " }}}
" -------- git --------
  Plug 'airblade/vim-gitgutter'
    nnoremap <leader>gg :GitGutter<CR>
  Plug 'tpope/vim-fugitive'
    nnoremap <leader>gw :Gwrite<cr>
    nnoremap <leader>gr :Gread<cr>
    nnoremap <leader>gc :Git commit<cr>
    nnoremap <leader>gs :Git<cr>
    nnoremap <leader>gl :Gclog<cr>
    nnoremap <leader>gb :Git blame<cr>
    nnoremap <leader>gd :Gvdiffsplit<cr>
  Plug 'junegunn/gv.vim'
  Plug 'junegunn/vim-cfr'

" -------- language support ---------
  Plug 'fatih/vim-go'
  " Plug 'mfussenegger/nvim-jdtls'
  " Plug 'scalameta/nvim-metals'

call plug#end()

" """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" " => nvim-lspconfig
" """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" lua <<EOF
" local nvim_lsp = require('lspconfig')
"
" -- Use an on_attach function to only map the following keys
" -- after the language server attaches to the current buffer
" local on_attach = function(client, bufnr)
"   local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
"   local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
"
"   -- Enable completion triggered by <c-x><c-o>
"   buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
"
"   -- Mappings.
"   local opts = { noremap=true, silent=true }
"
"   buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
"   buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
"   buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
"   buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
"   buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
"   buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
"   buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
"   buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
"   buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
"   buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
"   buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
"   buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
"   buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
"   buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
"   buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
"   buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
"   buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
" end
"
" --
" --
" local servers = { "pyright", "clangd", "gopls", "cmake" }
" for _, lsp in ipairs(servers) do
"   nvim_lsp[lsp].setup {
"     on_attach = on_attach,
"     flags = {
"       debounce_text_changes = 150,
"       }
"     }
" end
" EOF

filetype plugin indent on

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General Settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set autoread " detect when a file is changed
set history=1000
set cursorline
set autowrite
set hlsearch            " 高亮搜索匹配结果
set incsearch
set showmatch
set autoindent
set number relativenumber
set scrolloff=7
set fencs=utf-8,gb2312,gb18030,gbk,ucs-bom,cp936,latin1
set encoding=utf-8
set clipboard=unnamedplus
set mouse=a
syntax enable
set cmdheight=2
set updatetime=300
set shortmess+=c

if has("nvim-0.5.0")
  set signcolumn=number
else
  set signcolumn=yes
endif



autocmd BufNewFile,BufRead *.hql set filetype=hive

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => expandtab adn tabstop
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup expandtab
  autocmd FileType * setlocal ts=4 sts=4 sw=4 | set noexpandtab nolist
  autocmd FileType make setlocal ts=4 sts=4 sw=4 | set noexpandtab nolist
  autocmd FileType php setlocal ts=4 sts=4 sw=4 | set expandtab list
  autocmd FileType python setlocal ts=4 sts=4 sw=4 | set expandtab list
  autocmd Filetype go setlocal ts=2 sts=2 sw=2 | set noexpandtab nolist
  autocmd FileType java setlocal ts=4 sts=4 sw=4 | set noexpandtab nolist
  autocmd Filetype html setlocal ts=4 sts=4 sw=4 | set expandtab list
  autocmd FileType cpp setlocal ts=2 sts=2 sw=2 | set expandtab list
  autocmd Filetype javascript setlocal ts=2 sts=2 sw=2 | set expandtab list
  autocmd Filetype json setlocal ts=2 sts=2 sw=2 | set expandtab list
  autocmd Filetype vue setlocal ts=2 sts=2 sw=2 | set expandtab list
  autocmd Filetype vim setlocal ts=2 sts=2 sw=2 | set expandtab list
  autocmd Filetype markdown setlocal ts=2 sts=2 sw=2 | set expandtab
  autocmd FileType scala setlocal ts=2 sts=2 sw=2 | set expandtab list
  autocmd FileType hive setlocal ts=8 sts=8 sw=8 | set expandtab nolist
  autocmd FileType sql setlocal ts=8 sts=8 sw=8 | set expandtab nolist
augroup END


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Leader key maps
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <silent> <leader>ev :tabedit $MYVIMRC<CR>
nnoremap <silent> <leader>sv :so $MYVIMRC<CR>

nnoremap <silent> <leader>w <esc>:w<CR>
inoremap <silent> <leader>w <esc>:w<CR>

nnoremap <leader>q :q<CR>
inoremap <leader>q <esc>:q<CR>
nnoremap <leader>x :bd %<CR>

nnoremap H ^
nnoremap L $
nnoremap U <C-r>
nnoremap - ddp
nnoremap _ ddkP

nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l

nnoremap <C-e> 2<C-e>
nnoremap <C-y> 2<C-y>

nnoremap <C-n> :bn<cr>
nnoremap <C-p> :bp<cr>

nnoremap ; :
nnoremap : ;

inoremap jk <esc>

nnoremap <leader>hr :%!xxd<cr> :set filetype=xxd<cr>
nnoremap <leader>hw :%!xxd -r<cr> :set binary<cr> :set filetype=<cr>

nnoremap <leader>fj :JsonFormat<cr>
nnoremap <leader>fd :let a=expand("<cword>")<Bar>:echo strftime("%Y %b %d %T", a)<CR>
nnoremap <silent> <leader>s :!say <cword><CR>
vnoremap <silent> <leader>s <esc>gv"ay :!say <c-r>a<CR>

vnoremap <leader>yc "+y

" let &colorcolumn="120"
" colors solarized
" colors molokai
colors nord
" let g:molokai_original=1
" highlight ColorColumn guibg=NONE ctermbg=NONE ctermfg=120
highlight Normal guibg=NONE ctermbg=NONE
" highlight VertSplit ctermbg=NONE
" highlight clear SignColumn " for solarized dark color scheme
" exec "set listchars=tab:\u2F1\u2CD\u2F2,nbsp:\u2F7,trail:\uB7"
exec "set listchars=tab:-->,nbsp:\u2F7,trail:\uB7"
" set list

if has("termguicolors")
  set termguicolors
endif

if exists('g:loaded_webdevicons')
  call webdevicons#refresh()
endif

augroup ft_vim
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
augroup END

"""""""""""""""""""""""""""""""""""""""""""
" => coc.nvim
"""""""""""""""""""""""""""""""""""""""""""

" Use tab for trigger completion with characters ahead and navigate

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" inoremap <silent><expr> <TAB>
"       \ pumvisible() ? coc#_select_confirm() :
"       \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
"       \ <SID>check_back_space() ? "\<TAB>" :
"       \ coc#refresh()
" 
" function! s:check_back_space() abort
"   let col = col('.') - 1
"   return !col || getline('.')[col - 1]  =~# '\s'
" endfunction
" 
" let g:coc_snippet_next = '<tab>'

" nmap <silent> [g <Plug>(coc-diagnostic-prev)
" nmap <silent> ]g <Plug>(coc-diagnostic-next)

" nmap <silent> gd <Plug>(coc-definition)
" nmap <silent> gy <Plug>(coc-type-definition)
" nmap <silent> gi <Plug>(coc-implementation)
" nmap <silent> gr <Plug>(coc-references)
" nmap <silent> gc <Plug>(coc-action-documentSymbols)

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction


if has('nvim')
  inoremap <silent><expr> <C-space> coc#refresh()
else
  inoremap <silent><expr> <C-@> coc#refresh()
endif

" Make <cr> auto-select the first completion item
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
      \: "\<C-g>u\<cr>\<c-r>=coc#on_enter()\<cr>"

let g:coc_snippet_next = '<tab>'

" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

nnoremap <silent><nowait> <space>a :<C-u>CocList diagnostics<cr>
nnoremap <silent><nowait> <space>e :<C-u>CocList extensions<cr>
nnoremap <silent><nowait> <space>c :<C-u>CocList commands<cr>
nnoremap <silent><nowait> <space>o :<C-u>CocList outline<cr>
nnoremap <silent><nowait> <space>s :<C-u>CocList -I symbols<cr>
nnoremap <silent><nowait> <space>j :<C-u>CocNext<cr>
nnoremap <silent><nowait> <space>k :<C-u>CocPrev<cr>
nnoremap <silent><nowait> <space>p :<C-u>CocListResume<cr>

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gc <Plug>(coc-action-documentSymbols)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<cr>

function! s:show_documentation()
  if (index(['vim', 'help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code
xmap <leader>f <Plug>(coc-format-selected)
nmap <leader>f <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>app` for current paragraph
xmap <leader>a <Plug>(coc-codeaction-selected)
nmap <leader>a <Plug>(coc-codeaction-selected)

" Remap keys for applying  codeaction to the current buffer.
nmap <leader>ac <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current Line.
nmap <leader>qf <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)


" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif


" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')


" custom statusline with vim-airline
let g:airline#extensions#coc#enabled = 0
let airline#extensions#coc#error_symbol = 'Error:'
let airline#extensions#coc#warning_symbol = 'Warning:'
let airline#extensions#coc#stl_format_err = '%E{[%e(#%fe)]}'
let airline#extensions#coc#stl_format_warn = '%W{[%w(#%fw)]}'

" ------------ coc-translator ------------
" popup
nmap <Leader>t <Plug>(coc-translator-p)
vmap <Leader>t <Plug>(coc-translator-pv)
" echo
nmap <Leader>e <Plug>(coc-translator-e)
vmap <Leader>e <Plug>(coc-translator-ev)
" replace
nmap <Leader>r <Plug>(coc-translator-r)
vmap <Leader>r <Plug>(coc-translator-rv)

" ------------ coc-metals ------------

au BufRead,BufNewFile *.sbt,*.sc set filetype=scala

nmap <Leader>ws <Plug>(coc-metals-expand-decoration)

nnoremap <silent> <space>t :<C-u>CocCommand metals.tvp<CR>
nnoremap <silent> <space>tp :<C-u>CocCommand metals.tvp metalsPackages<CR>
nnoremap <silent> <space>tc :<C-u>CocCommand metals.tvp metalsCompile<CR>
nnoremap <silent> <space>tb :<C-u>CocCommand metals.tvp metalsBuild<CR>
nnoremap <silent> <space>tf :<C-u>CocCommand metals.revealInTreeView metalsPackages<CR>

" ----------------------------------------------------------------

" {{{ 定义函数AutoSetFileHead，自动插入文件头
autocmd BufNewFile *.sh,*.py exec ":call AutoSetFileHead()"
function! AutoSetFileHead()
  "如果文件类型为.sh文件
  if &filetype == 'sh'
    call setline(1, "\#!/bin/bash")
  endif

  "如果文件类型为python
  if &filetype == 'python'
    call setline(1, "\#!/usr/bin/env python")
    call append(1, "\# encoding: utf-8")
  endif

  normal G
  normal o
  normal o
endfunc
" }}}

" Function to source only if file exists {
function! SourceIfExists(file)
  if filereadable(expand(a:file))
    exe 'source' a:file
  endif
endfunction
" }


command! JsonFormat :execute '%!python -m json.tool'
            \ | :execute '%!python -c "import re,sys;sys.stdout.write(re.sub(r\"\\\u[0-9a-f]{4}\", lambda m:m.group().decode(\"unicode_escape\").encode(\"utf-8\"), sys.stdin.read()))"'
            \ | :set ft=json
            \ | :1

call SourceIfExists('.vimrc.local')
source ~/.config/nvim/plugin/youdao.vim
