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
" No bell or flash for visual bell
set noswapfile         " It's 2013, Vim.
set vb t_vb=
set hidden


" Choosing current buffer encoding
set fileencodings=cp866,utf-8,cp1251,koi8-r
" menu Encoding.koi8-r :e ++enc=koi8-r ++ff=unix<CR>
menu Encoding.utf-8 :e ++enc=utf8<CR>
menu Encoding.windows-1251 :e ++enc=cp1251 ++ff=dos<CR>
menu Encoding.cp866 :e ++enc=cp866 ++ff=dos<CR>
menu Encoding.koi8-u :e ++enc=koi8-u ++ff=unix<CR>

map <F8> :emenu Encoding.

"" Whitespace
set nowrap                      " don't wrap lines
set tabstop=8                   " tab size 8
set softtabstop=2               " pressing Tab places 2 spaces
set shiftwidth=2
set noexpandtab
set list
set listchars=tab:▸\-,trail:·
set backspace=indent,eol,start  " backspace through everything in insert mode

"" Searching
set hlsearch                    " highlight matches
set incsearch                   " incremental searching
set ignorecase                  " searches are case insensitive...
set smartcase                   " ... unless they contain at least one capital letter

" Fixes common typos
" command W w
" command Wq wq
" command Q q
map <F1> <Esc>
imap <F1> <Esc>

set t_Co=256
colorscheme molokai

map <F2> :w<CR>
nmap <F3> :e .<CR>

" Switching between buffers
map gn :bn<CR>
map gp :bp<CR>
map gl :ls<CR>
map gd :bd<CR>

" remap escape; this rox
imap jj <Esc>


autocmd! bufwritepost .vimrc source %

