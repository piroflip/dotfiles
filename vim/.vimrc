" Preamble ---------------------------------------------------------------- {{{

let $BASH_ENV = "~/.bash_profile"
set shell=/bin/bash
set nocompatible               " be iMproved

" }}}
" Neobundle Plugins ---------------------------------------------------------- {{{
" NeoBundle auto-installation and setup {{{

" Auto installing NeoBundle
let iCanHazNeoBundle=1
let neobundle_readme=expand($HOME.'/.vim/bundle/neobundle.vim/README.md')
if !filereadable(neobundle_readme)
    echo "Installing NeoBundle.."
    echo ""
    silent !mkdir -p $HOME/.vim/bundle
    silent !git clone https://github.com/Shougo/neobundle.vim $HOME/.vim/bundle/neobundle.vim
    let iCanHazNeoBundle=0
endif


" Call NeoBundle
if has('vim_starting')
    set rtp+=$HOME/.vim/bundle/neobundle.vim/
endif
call neobundle#rc(expand($HOME.'/.vim/bundle/'))

" is better if NeoBundle rules NeoBundle (needed!)
NeoBundle 'Shougo/neobundle.vim'
" }}}

NeoBundle 'vcscommand.vim'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'bling/vim-airline'
NeoBundle 'Shougo/unite.vim'
"
" Vimproc to asynchronously run commands (NeoBundle, Unite)
NeoBundle 'Shougo/vimproc', {
      \ 'build' : {
      \     'windows' : 'make -f make_mingw32.mak',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak',
      \    },
      \ }
" Colorschemes
NeoBundle 'tomasr/molokai'
"

" Auto install the plugins {{{

" First-time plugins installation
if iCanHazNeoBundle == 0
    echo "Installing Bundles, please ignore key map error messages"
    echo ""
    :NeoBundleInstall
endif

" Check if all of the plugins are already installed, in other case ask if we
" want to install them (useful to add plugins in the .vimrc)
NeoBundleCheck

" }}}

filetype plugin indent on      " Indent and plugins by filetype
" }}}
" Basic options ----------------------------------------------------------- {{{

syntax enable
set encoding=utf-8
set modelines=0
set autoindent
set showmode
set showcmd
set hidden
set novisualbell
set ttyfast
set ruler
set backspace=indent,eol,start
set nonumber
set norelativenumber
set laststatus=2
set history=1000
set undofile
set undoreload=10000
set list
set listchars=tab:▸\-,trail:·
set lazyredraw
set matchtime=3
set showbreak=↪
set splitbelow
set splitright
set autowrite
set autoread
set title
set linebreak
set colorcolumn=+1

" Don't try to highlight lines longer than 800 characters.
set synmaxcol=800

" Time out on key codes but not mappings.
" Basically this makes terminal Vim work sanely.
set notimeout
set ttimeout
set ttimeoutlen=10

" Save when losing focus
au FocusLost * :silent! wall

" Leader
let mapleader = ","
let maplocalleader = "\\"

" Cursorline {{{
" Only show cursorline in the current window and in normal mode.

augroup cline
    au!
    au WinLeave,InsertEnter * set nocursorline
    au WinEnter,InsertLeave * set cursorline
augroup END

" }}}
" Tabs, spaces, wrapping {{{

set tabstop=8
set shiftwidth=2
set softtabstop=2
set noexpandtab
set nowrap
set textwidth=80
set formatoptions=qrn1j
set colorcolumn=+1

" }}}
" Backups {{{

set backup                        " enable backups
set noswapfile                    " it's 2013, Vim.

set undodir=~/.vim/tmp/undo//     " undo files
set backupdir=~/.vim/tmp/backup// " backups
set directory=~/.vim/tmp/swap//   " swap files

" Make those folders automatically if they don't already exist.
if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p")
endif
if !isdirectory(expand(&backupdir))
    call mkdir(expand(&backupdir), "p")
endif
if !isdirectory(expand(&directory))
    call mkdir(expand(&directory), "p")
endif

" }}}
" Line Return {{{

" Make sure Vim returns to the same line when you reopen a file.
" Thanks, Amit
augroup line_return
    au!
    au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \     execute 'normal! g`"zvzz' |
        \ endif
augroup END

" }}}
" Encoding {{{
" Choosing current buffer encoding
set fileencodings=cp866,utf-8,cp1251,koi8-r
" menu Encoding.koi8-r :e ++enc=koi8-r ++ff=unix<CR>
menu Encoding.utf-8 :e ++enc=utf8<CR>
menu Encoding.windows-1251 :e ++enc=cp1251 ++ff=dos<CR>
menu Encoding.cp866 :e ++enc=cp866 ++ff=dos<CR>
menu Encoding.koi8-u :e ++enc=koi8-u ++ff=unix<CR>

map <F8> :emenu Encoding.
" }}}
" Color scheme {{{
set term=screen-256color
syntax on
set background=dark
set t_Co=256
colorscheme molokai

" Highlight VCS conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" }}}
" }}}
" Convenience mappings ---------------------------------------------------- {{{

" Fuck you, help key.
noremap  <F1> :checktime<cr>
inoremap <F1> <esc>:checktime<cr>

map <F2> :w<CR>

" Switching between buffers
map gn :bn<CR>
map gp :bp<CR>
map gl :ls<CR>
map gd :bd<CR>

" remap escape; this rox
imap jj <Esc>

" Clean trailing whitespace
nnoremap <leader>ww mz:%s/\s\+$//<cr>:let @/=''<cr>`z

" Panic Button
nnoremap <f9> mzggg?G`z

" Toggle [i]nvisible characters
nnoremap <leader>i :set list!<cr>

command! -complete=file -nargs=+ Svn :!svn <args>

command! -complete=file -nargs=+ SvnDiff call SubversionDiff(<q-args>)

function! SubversionDiff(args)
  let targetFilename = expand("%")
  let tempFilename = expand("%:t")
  exe 'split "/tmp/diff_' . tempFilename . '"'
  " Empty the file of any previous diff contents
  exe "normal ggVGx"
  exe "silent read! svn diff" . a:args
  exe "set syntax=diff"
  exe "normal gg"
endfun

" }}}
" Quick editing ----------------------------------------------------------- {{{

nnoremap <leader>ev :edit ~/.vimrc<cr>
nnoremap <leader>et :vsplit ~/.tmux.conf<cr>

" }}}
" Searching and movement -------------------------------------------------- {{{

" Use sane regexes.
nnoremap / /\v
vnoremap / /\v

set ignorecase
set smartcase
set incsearch
set showmatch
set hlsearch
set gdefault

set scrolloff=3
set sidescroll=1
set sidescrolloff=10

set virtualedit+=block

noremap <silent> <leader><space> :noh<cr>

" Keep search matches in the middle of the window.
nnoremap n nzzzv
nnoremap N Nzzzv

" Same when jumping around
nnoremap g; g;zz
nnoremap g, g,zz
nnoremap <c-o> <c-o>zz

" Directional Keys {{{

" It's 2013.
noremap j gj
noremap k gk
noremap gj j
noremap gk k

" Easy buffer navigation
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

noremap <leader>v <C-w>v

" }}}
" List navigation {{{

nnoremap <left>  :cprev<cr>zvzz
nnoremap <right> :cnext<cr>zvzz
nnoremap <up>    :lprev<cr>zvzz
nnoremap <down>  :lnext<cr>zvzz

" }}}

" }}}
" Folding ----------------------------------------------------------------- {{{

set foldlevelstart=0

" Space to toggle folds.
nnoremap <Space> za
vnoremap <Space> za

" Make zO recursively open whatever fold we're in, even if it's partially open.
nnoremap zO zczO

" "Focus" the current line.  Basically:
"
" 1. Close all folds.
" 2. Open just the folds containing the current line.
" 3. Move the line to a little bit (15 lines) above the center of the screen.
" 4. Pulse the cursor line.  My eyes are bad.
"
" This mapping wipes out the z mark, which I never use.
"
" I use :sus for the rare times I want to actually background Vim.
nnoremap <c-z> mzzMzvzz15<c-e>`z:Pulse<cr>

function! MyFoldText() " {{{
    let line = getline(v:foldstart)

    let nucolwidth = &fdc + &number * &numberwidth
    let windowwidth = winwidth(0) - nucolwidth - 3
    let foldedlinecount = v:foldend - v:foldstart

    " expand tabs into spaces
    let onetab = strpart('          ', 0, &tabstop)
    let line = substitute(line, '\t', onetab, 'g')

    let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
    let fillcharcount = windowwidth - len(line) - len(foldedlinecount)
    return line . '…' . repeat(" ",fillcharcount) . foldedlinecount . '…' . ' '
endfunction " }}}
set foldtext=MyFoldText()

" }}}
" Filetype-specific ------------------------------------------------------- {{{

" C {{{

augroup ft_c
    au!
"    au FileType c setlocal foldmethod=marker foldmarker={,}
augroup END

" }}}
" Vim {{{

augroup ft_vim
    au!

    au FileType vim setlocal foldmethod=marker
    au FileType help setlocal textwidth=78
    au BufWinEnter *.txt if &ft == 'help' | wincmd L | endif
augroup END

" }}}

" }}}
" Plugin settings --------------------------------------------------------- {{{
" Ack {{{

nnoremap <leader>a :Ack!<space>
let g:ackprg = '/usr/bin/vendor_perl/ack --smart-case --nogroup --nocolor --column'

" }}}
" NERD Tree {{{

noremap  <F3> :NERDTreeToggle<cr>
inoremap <F3> <esc>:NERDTreeToggle<cr>

augroup ps_nerdtree
    au!

    au Filetype nerdtree setlocal nolist
    au Filetype nerdtree nnoremap <buffer> H :vertical resize -10<cr>
    au Filetype nerdtree nnoremap <buffer> L :vertical resize +10<cr>
    " au Filetype nerdtree nnoremap <buffer> K :q<cr>
augroup END

let NERDTreeHighlightCursorline = 1
let NERDTreeIgnore = ['.vim$', '\~$', '.*\.pyc$', 'pip-log\.txt$', 'whoosh_index',
                    \ 'xapian_index', '.*.pid', 'monitor.py', '.*-fixtures-.*.json',
                    \ '.*\.o$', 'db.db', 'tags.bak', '.*\.pdf$', '.*\.mid$',
                    \ '.*\.midi$']

let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let NERDChristmasTree = 1
let NERDTreeChDirMode = 2
let NERDTreeMapJumpFirstChild = 'gK'

" }}}
" Airline {{{

set noshowmode

let g:airline_theme='powerlineish'
let g:airline_enable_branch=1
let g:airline_powerline_fonts=1
let g:airline_detect_whitespace = 1
let g:airline#extensions#hunks#non_zero_only = 1

" let g:airline#extensions#tabline#enabled = 2
" let g:airline#extensions#tabline#fnamemod = ':t'
" let g:airline#extensions#tabline#buffer_min_count = 1

" }}}
" Unite {{{
let g:unite_source_history_yank_enable = 1
nnoremap <leader>y :<C-u>Unite -no-split -buffer-name=yank    history/yank<cr>
nnoremap <leader>b :Unite -quick-match buffer<cr>
nnoremap <leader>* :UniteWithCursorWord grep:.<cr>
nnoremap <leader>/ :Unite grep:.<cr>
" }}}


" }}}

autocmd! bufwritepost .vimrc source %
