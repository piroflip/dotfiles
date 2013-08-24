set nocompatible               " be iMproved
filetype off                   " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'
"
" Colorschemes
Bundle 'mutewinter/ir_black_mod'
Bundle 'tomasr/molokai'
Bundle 'cschlueter/vim-wombat'
Bundle 'github.vim'
Bundle 'proton.vim'
Bundle '29decibel/codeschool-vim-theme'
Bundle 'altercation/vim-colors-solarized'
Bundle 'jpo/vim-railscasts-theme'
Bundle 'chriskempson/base16-vim'
"
" Some basic stuff everyone need
syntax enable
set encoding=utf-8
set showcmd                     " display incomplete commands

"" Whitespace
set nowrap                      " don't wrap lines
set tabstop=2 shiftwidth=2      " a tab is two spaces (or set this to 4)
set expandtab                   " use spaces, not tabs (optional)
set backspace=indent,eol,start  " backspace through everything in insert mode

"" Searching
set hlsearch                    " highlight matches
set incsearch                   " incremental searching
set ignorecase                  " searches are case insensitive...
set smartcase                   " ... unless they contain at least one capital letter

set t_Co=256
colorscheme darkblue
