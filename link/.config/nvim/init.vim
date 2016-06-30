" Preamble ---------------------------------------------------------------- {{{

let $BASH_ENV = "~/.bash_profile"
set shell=/bin/bash
set nocompatible               " be iMproved

" }}}
" Neobundle Plugins ------------------------------------------------------- {{{
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
call neobundle#begin(expand($HOME.'/.vim/bundle/'))

" is better if NeoBundle rules NeoBundle (needed!)
NeoBundle 'Shougo/neobundle.vim'
" }}}
NeoBundle 'Shougo/unite.vim'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'vcscommand.vim'
NeoBundle 'vimtaku/hl_matchit.vim'
NeoBundle 'rhysd/conflict-marker.vim'
" File explorer (needed where ranger is not available)
NeoBundleLazy 'Shougo/vimfiler', {'autoload' : { 'commands' : ['VimFiler']}}
NeoBundleLazy 'Shougo/neomru.vim' ", {'autoload':{'unite_sources': ['file_mru', 'directory_mru']}}
" Autocompletion

NeoBundle 'Shougo/deoplete.nvim'
if neobundle#tap("deoplete.nvim")
        let s:hooks = neobundle#get_hooks("deoplete.nvim")
        function! s:hooks.on_source(bundle)
          let g:deoplete#enable_at_startup = 1
          let g:deoplete#enable_ignore_case = 1
          let g:deoplete#enable_smart_case = 1
          let g:deoplete#enable_fuzzy_completion = 1
          " <TAB>: completion.
          imap <silent><expr> <TAB>
                \ pumvisible() ? "\<C-n>" :
                \ <SID>check_back_space() ? "\<TAB>" :
                \ deoplete#mappings#manual_complete()
          function! s:check_back_space() abort "{{{
            let col = col('.') - 1
            return !col || getline('.')[col - 1]  =~ '\s'
          endfunction"}}}

          " <S-TAB>: completion back.
          inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<C-h>"

          " <C-h>, <BS>: close popup and delete backword char.
          inoremap <expr><C-h> deoplete#mappings#smart_close_popup()."\<C-h>"
          inoremap <expr><BS> deoplete#mappings#smart_close_popup()."\<C-h>"
        endf
endif

NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'Shougo/vimshell'


call neobundle#config('vimshell', {
      \ 'lazy' : 1,
      \ 'autoload' : {
      \   'commands' : [{ 'name' : 'VimShell',
      \                   'complete' : 'customlist,vimshell#complete'},
      \                 'VimShellExecute', 'VimShellInteractive',
      \                 'VimShellTerminal', 'VimShellPop'],
      \   'mappings' : ['<Plug>(vimshell_switch)']
      \ }})

" Vimproc to asynchronously run commands (NeoBundle, Unite)
NeoBundle 'Shougo/vimproc', {
      \ 'build' : {
      \     'windows' : 'make -f make_mingw32.mak',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak',
      \    },
      \ }
NeoBundle 'tpope/vim-commentary'
" Colorschemes
NeoBundle 'sjl/badwolf'
NeoBundle 'elmindreda/vimcolors'
NeoBundle 'tomasr/molokai'
NeoBundle 'xero/sourcerer.vim'
NeoBundle 'joedicastro/vim-molokai256'
NeoBundle 'altercation/vim-colors-solarized'
"
"NeoBundleLazy 'Rip-Rip/clang_complete', {
"      \ 'autoload': {
"      \   'filetypes':['c', 'cpp'],
"      \   'external_commands' : ['clang'],
"      \   }
"      \ }

NeoBundle 'justinmk/vim-syntax-extra', {
      \ 'autoload': {
      \  'filetypes':['c', 'cpp'],
      \   }
      \ }

NeoBundleLazy 'basyura/TweetVim', { 'depends' :
      \ ['basyura/twibill.vim', 'tyru/open-browser.vim'],
      \ 'autoload' : { 'commands' : 'TweetVimHomeTimeline' }}

" Auto install the plugins {{{

" First-time plugins installation
if iCanHazNeoBundle == 0
    echo "Installing Bundles, please ignore key map error messages"
    echo ""
    :NeoBundleInstall
endif

call neobundle#end()

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
set listchars=tab:>-,trail:·
set lazyredraw
set matchtime=3
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
set expandtab
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
map <leader>en :emenu Encoding.
" }}}
" Color scheme {{{
set background=dark
set t_Co=256
let g:solarized_termcolors=256
" colorscheme molokai256
colorscheme solarized

" Highlight VCS conflict markers
" match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" }}}
" }}}
" Convenience mappings ---------------------------------------------------- {{{

" Fuck you, help key.
noremap  <F1> :checktime<cr>
inoremap <F1> <esc>:checktime<cr>

map <F2> :w<CR>
nnoremap <F9> :make<CR>

" Switching between buffers
map gn :bn<CR>
map gp :bp<CR>
map gl :ls<CR>
map gd :bd<CR>

" remap escape; this rox
imap jj <Esc>

nnoremap ; :

" Clean trailing whitespace
nnoremap <leader>ww mz:%s/\s\+$//<cr>:let @/=''<cr>`z

" Use <C-Space>.
nmap <C-Space>  <C-@>
cmap <C-Space>  <C-@>

" <TAB>: indent.
xnoremap <TAB>  >
" <S-TAB>: unindent.
xnoremap <S-TAB>  <

" Indent
nnoremap > >>
nnoremap < <<
xnoremap > >gv
xnoremap < <gv



" Toggle the search results highlighting {{{
map <silent><leader>hl :set invhlsearch<CR>
" }}}

" Panic Button
" nnoremap <f9> mzggg?G`z

" Toggle [i]nvisible characters
nnoremap <leader>i :set list!<cr>

" Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr>

" }}}
" Quick editing ----------------------------------------------------------- {{{

nnoremap <leader>ev :e ~/.vimrc<cr>
nnoremap <leader>ei :e ~/.config/nvim/init.vim<cr>
nnoremap <leader>ea :e ~/.config/awesome/rc.lua<cr>
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

" <Leader>4: Toggle between paste mode
nnoremap <silent> <leader>4 :set paste!<cr>
" thanks terryma: https://github.com/terryma/dotfiles/blob/master/.vimrc
" d: Delete into the blackhole register to not clobber the last yank
nnoremap d "_d
" dd: I use this often to yank a single line, retain its original behavior
nnoremap dd dd

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

" do not fold diff
set diffopt+=context:99999

" }}}
" Filetype-specific ------------------------------------------------------- {{{

" C {{{

augroup ft_c
    au!
    " au FileType c setlocal foldmethod=syntax
    " au FileType c setlocal foldlevelstart=99
    " au FileType c setlocal foldlevel=99
    "marker foldmarker={,}
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

" Makefile {{{

augroup ft_makefile
    au!

    " in makefiles, don't expand tabs to spaces, since actual tab characters are
    " needed, and have indentation at 8 chars to be sure that all indents are
    " tabs
    " (despite the mappings later):
    autocmd FileType make set noexpandtab shiftwidth=8 softtabstop=0
augroup END

" }}}

" vimperatorrc {{{

au BufNewFile,BufRead *vimperatorrc*,*.vimp setfiletype vim

" }}}

" }}}
" Plugin settings --------------------------------------------------------- {{{
" Ack {{{

nnoremap <leader>a :Ack!<space>
let g:ackprg = '/usr/bin/vendor_perl/ack --smart-case --nogroup --nocolor --column'

" }}}
" NERDCommenter {{{

let g:NERDCreateDefaultMappings = 0

let NERDSpaceDelims=1
let g:NERDCustomDelimiters = {
    \ 'c': { 'leftAlt': '//','rightAlt': '', 'left': '//', 'right': '' },
\ }

" }}}
" Unite {{{

nmap [unite] <Nop>
nmap <leader> [unite]

if executable('ack')
  " Use ack in unite grep source.
  let g:unite_source_grep_command = 'ack'
  let g:unite_source_grep_default_opts =
        \ '-i --no-heading --no-color -k -H'
  let g:unite_source_grep_recursive_opt = ''
elseif executable('jvgrep')
  " For jvgrep.
  let g:unite_source_grep_command = 'jvgrep'
  let g:unite_source_grep_default_opts =
        \ '-i --exclude ''\.(git|svn|hg|bzr)'''
  let g:unite_source_grep_recursive_opt = '-R'
elseif executable('ag')
  " Use ag in unite grep source.
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts =
        \ '-i --search-binary --vimgrep --hidden --ignore ' .
        \ '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
  let g:unite_source_grep_recursive_opt = ''
elseif executable('pt')
  " Use pt in unite grep source.
  " https://github.com/monochromegane/the_platinum_searcher
  let g:unite_source_grep_command = 'pt'
  let g:unite_source_grep_default_opts = '--nogroup --nocolor'
  let g:unite_source_grep_recursive_opt = ''
endif
let g:unite_source_grep_encoding = 'cp866'

let g:unite_source_history_yank_enable = 1
nnoremap [unite]y :Unite -buffer-name=yank   -no-split register      history/yank<cr>
nnoremap [unite]b :Unite -buffer-name=buffers -no-split               buffer<cr>
nnoremap [unite]f :Unite -buffer-name=files   -no-split -start-insert file_rec/async:!<cr>
nnoremap [unite]* :UniteWithCursorWord -auto-preview grep:.<cr>
nnoremap [unite]/ :Unite grep:.<cr>
nnoremap [unite]r :UniteResume<cr>
nnoremap [unite]m :Unite -buffer-name=mru              -start-insert neomru/file<cr>
nnoremap [unite]n :Unite -buffer-name=mru -default-action=lcd neomru/directory<CR>

" }}}
" Lightline {{{
  set laststatus=2
  let g:lightline = {
    \ 'active': {
    \   'left': [ [ 'filename' ],
    \             [ 'readonly', 'fugitive' ] ],
    \   'right': [ [ 'percent', 'lineinfo' ],
    \              [ 'fileencoding', 'filetype' ],
    \              [ 'fileformat', 'syntastic' ] ]
    \ }
    \ }
" }}}
" VimFiler {{{
nnoremap [unite]d :VimFilerBufferDir -buffer-name=explorer -simple -toggle -force-quit<cr>
nnoremap ` :<C-u>VimFiler -buffer-name=explorer -toggle -force-quit<cr>

" }}}
" VimShell {{{
nmap <silent> vs :<C-u>VimShell<CR>
nmap <silent> vp :<C-u>VimShellPop<CR>
nmap <C-@>  <Plug>(vimshell_switch)
" }}}
" Deoplete {{{
" }}}
" Neosnippet {{{
" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
"imap <expr><TAB>
" \ pumvisible() ? "\<C-n>" :
" \ neosnippet#expandable_or_jumpable() ?
" \    "\<TAB>" : "\<Plug>(neosnippet_expand_or_jump)"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif
" }}}
" }}}

" The prefix key.
nnoremap [Quickfix]   <Nop>
nmap    q  [Quickfix]
" Disable Ex-mode.
nnoremap Q  q

" Toggle quickfix window.
nnoremap <silent> [Quickfix]<Space>
      \ :<C-u>call <SID>toggle_quickfix_window()<CR>
function! s:toggle_quickfix_window()
  let _ = winnr('$')
  cclose
  if _ == winnr('$')
    copen
    setlocal nowrap
    setlocal whichwrap=b,s
  endif
endfunction


