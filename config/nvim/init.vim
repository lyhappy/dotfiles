set nocompatible
filetype off

" {{{ use vim-plug manage plugins
if empty(glob('~/.vim/autoload/plug.vim'))
	silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
				\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" }}}


let mapleader = ','
let g:mapleader = ','

""""""""""""""""""""""""""""""""
" => vim plugin list
""""""""""""""""""""""""""""""""
call plug#begin('~/.config/vim/plugged')

" -------- Themes --------
  Plug 'dracula/vim', {'as': 'dracula' }
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
    " let g:airline_theme='atomic'
    " let g:airline_theme='molokai'
    let g:airline_theme='dracula'
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
    set laststatus=2

" -------- File Management --------
  Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
  nnoremap <leader>nf :NERDTreeFind<CR>
  nnoremap <leader>k :NERDTree<CR>
  Plug 'Xuyuanp/nerdtree-git-plugin', { 'on':  'NERDTree' }
  let g:NERDTreeIndicatorMapCustom = {
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

" -------- Productivity --------
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
    inoremap <M-f> :CocFix<cr>
    nnoremap <M-f> :CocFix<cr>
    nnoremap <M-a> :CocAction<cr>
  Plug 'mileszs/ack.vim'
  Plug 'majutsushi/tagbar'
    nnoremap <leader>t :Tagbar<cr>
    nnoremap <leader>tj :TagbarOpen j<cr>
  Plug 'easymotion/vim-easymotion'
    let g:EasyMotion_leader_key = '\'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'itchyny/calendar.vim'
  Plug 'nicwest/vim-http'
  Plug 'preservim/nerdcommenter'
    let g:NERDSpaceDelims=1

" -------- FE --------
  Plug 'posva/vim-vue'
    au BufNewFile,BufRead *.vue setf vue
    autocmd FileType vue syntax sync fromstart
  Plug 'ap/vim-css-color'

" -------- Markdown docs --------
  Plug 'iamcco/markdown-preview.vim', { 'for': 'markdown' }
  Plug 'mzlogin/vim-markdown-toc'
  Plug 'junegunn/goyo.vim', { 'for': 'markdown' }
  Plug 'junegunn/limelight.vim'
    let g:limelight_conceal_ctermfg = 'gray'
    let g:limelight_conceal_ctermfg = 240
  " {{{ vimwiki
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
      let wiki_studynotes.path = '~/vimwiki/'

      let g:vimwiki_list = [wiki_worknotes, wiki_studynotes]
      nnoremap <leader>wtl :Ack -Q "[ ]" . -r<cr>
      let g:vimwiki_valid_html_tags = 'b,i,s,u,sub,sup,kbd,br,hr, pre, script'
  " }}}
  " {{{ vim-table-mode
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
    nnoremap <leader>gc :Gcommit<cr>
    nnoremap <leader>gs :Gstatus<cr>
    nnoremap <leader>gl :Glog<cr>
    nnoremap <leader>gb :Gblame<cr>
    nnoremap <leader>gd :Gvdiff<cr>
  Plug 'junegunn/gv.vim'

call plug#end()

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


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => expandtab adn tabstop
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup expandtab
  autocmd FileType php set ts=4 sts=4 sw=4 | set expandtab
  autocmd FileType python set ts=4 sts=4 sw=4 | set expandtab
  autocmd Filetype html setlocal ts=4 sts=4 sw=4 | set expandtab
  autocmd Filetype javascript setlocal ts=2 sts=2 sw=2 | set expandtab
  autocmd Filetype vue setlocal ts=2 sts=2 sw=2 | set expandtab
  autocmd Filetype vim setlocal ts=2 sts=2 sw=2 | set expandtab
  autocmd Filetype markdown setlocal ts=2 sts=2 sw=2 | set expandtab
  autocmd Filetype go setlocal nolist
augroup END


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Leader key maps
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <silent> <leader>ev :vsp $MYVIMRC<CR>
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

colors dracula
let &colorcolumn="120"
hi Normal guibg=NONE ctermbg=NONE

augroup ft_vim
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
augroup END

"""""""""""""""""""""""""""""""""""""""""""
" => coc.nvim
"""""""""""""""""""""""""""""""""""""""""""

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gc <Plug>(coc-action-documentSymbols)

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
