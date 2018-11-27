" {{{ use vim-plug manage plugins
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" }}}

call plug#begin('~/.config/vim/plugged')

" General {{{
abbr teh the
abbr funciton function
abbr tempalte template

set autoread " detect when a file is changed
set history=1000
set textwidth=120
set nocompatible
set autowrite
set tabstop=2           " 设置制表符(tab键)的宽度
set softtabstop=2       " 设置软制表符的宽度
set shiftwidth=2        " (自动) 缩进使用的4个空格
set expandtab           " 将tab键展开为空格
set hlsearch            " 高亮搜索匹配结果
set incsearch           " 输入字符串就显示匹配点
set showmatch           " 设置匹配模式，显示匹配的括号
set autoindent
" set smartindent         " 智能缩进
set number              " 显示行号
set relativenumber
set scrolloff=7         " 光标不触底
set fencs=utf-8,gbk     " 打开文件时，同时尝试utf-8和gbk编码
set encoding=utf-8
set laststatus=2
set ruler
set linebreak           " 整词换行
set history=50          " set command history to 50    "历史记录50条
set mouse=a             " Enable mouse usage (all modes)    "使用鼠标
set whichwrap=b,s,<,>,[,]   " 光标从行首和行末时可以跳到另一行去
set showcmd             " 命令行显示输入的命令
set showmode            " 命令行显示vim当前模式
syntax enable

" 修改leader键
let mapleader = ','
let g:mapleader = ','


" }}}



call plug#end()


