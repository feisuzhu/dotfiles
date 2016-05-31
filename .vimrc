set nocompatible

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
" Color scheme
Plug 'feisuzhu/ingretu'
" status line
if has('nvim')
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    let g:airline_powerline_fonts=1
else
    Plug 'powerline/powerline'
    set rtp+=$HOME/.vim/plugged/powerline/powerline/bindings/vim/
endif
" tab completion
Plug 'ervandew/supertab'
" better than grep
Plug 'mileszs/ack.vim'
" :NERDTree
Plug 'scrooloose/nerdtree'
" syntax checking using flake8
Plug 'scrooloose/syntastic'
" enhanced python syntax
" Plug 'ervandew/python.vim--Vasiliev'
" Python folding
" Plug 'feisuzhu/python-folding.vim'
Plug 'tmhedberg/SimpylFold'
" python code navigating
" Plug 'klen/python-mode'
" Git integration
Plug 'tpope/vim-fugitive'
" Markdown
Plug 'tpope/vim-markdown'
" HTML Shortcuts
Plug 'mattn/emmet-vim'
" Close buffer without closing window
Plug 'rbgrouleff/bclose.vim'
" TagBar
Plug 'majutsushi/tagbar'
Plug 'vim-scripts/OmniCppComplete'
Plug 'groenewege/vim-less'
Plug 'Lokaltog/vim-easymotion'
Plug 'guns/vim-clojure-static'
" Plug 'tpope/vim-fireplace'
" Plug 'tpope/vim-classpath'
Plug 'feisuzhu/rainbow_parentheses.vim'
Plug 'uarun/vim-protobuf'
Plug 'terryma/vim-multiple-cursors'
Plug 'kchmck/vim-coffee-script'
Plug 'puppetlabs/puppet-syntax-vim'
Plug 'Yggdroot/indentLine'
Plug 'triglav/vim-visual-increment'
Plug 'stephpy/vim-yaml'
Plug 'chase/nginx.vim'
Plug 'ntpeters/vim-better-whitespace'
Plug 'digitaltoad/vim-jade'
Plug 'godlygeek/tabular'
Plug 'milkypostman/vim-togglelist'
Plug 'ekalinin/Dockerfile.vim'
Plug 'kana/vim-textobj-user'
Plug 'bps/vim-textobj-python'
Plug 'jeroenbourgois/vim-actionscript'
Plug 'rust-lang/rust.vim'
Plug 'phildawes/racer'
Plug 'davidhalter/jedi'
Plug 'derekwyatt/vim-scala'
Plug 'EvanDotPro/nerdtree-chmod'
Plug 'robbles/logstash.vim'
Plug 'tpope/vim-surround'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
call plug#end()

filetype plugin on
filetype indent off

set exrc
set secure

set laststatus=2
set encoding=utf-8
set t_Co=256

let g:Powerline_symbols = 'fancy'

" autocmd FileType python setlocal foldmethod=indent
set foldlevel=99

nmap <Tab> :NERDTreeToggle<CR>
nmap <S-Tab> :TagbarToggle<CR>

set diffopt+=vertical

set wildignore=*.py[co]

let os=substitute(system('uname'), '\n', '', '')

if os == 'Darwin' || os == 'Mac'
    set clipboard=unnamed
else
    set clipboard=unnamedplus
endif

au FileType python set omnifunc=pythoncomplete#Complete
au FileType c,cpp set omnifunc=OmniCppComplete
set completeopt=menuone,longest,preview

let NERDTreeIgnore = ['\.py[co]$', '\.o', 'a\.out']

cnoreabbrev bd Bclose

let g:EasyMotion_leader_key = '\O'

nmap <Space><Up> :wincmd k<CR>
nmap <Space><Down> :wincmd j<CR>
nmap <Space><Left> :wincmd h<CR>
nmap <Space><Right> :wincmd l<CR>

nmap <C-Up> :wincmd +<CR>
nmap <C-Down> :wincmd -<CR>

nmap <Space>k :wincmd k<CR>
nmap <Space>j :wincmd j<CR>
nmap <Space>h :wincmd h<CR>
nmap <Space>l :wincmd l<CR>

nmap <Space>f \Of
nmap <Space>F \OF
nmap <Space>w \Ow
nmap <Space>b \Ob

let g:toggle_list_no_mappings = 1
let g:syntastic_always_populate_loc_list = 1
nmap <Space><Space> :call ToggleLocationList()<CR>

autocmd FileType c,cpp,java,php,python,perl autocmd BufWritePre <buffer> :%s/\s\+$//e
" cnoreabbrev clean %s/\s\+$//e

nmap - :lprev<CR>
nmap = :lnext<CR>

nnoremap _ :cprev<CR>
nnoremap + :cnext<CR>

nmap \t :Files<CR>
nmap \T :Tags<CR>
nmap \l :NERDTreeFind<CR>
nmap \\ :nohl<CR>:set nopaste<CR>
vmap \= :Tabularize /^[^=]*\zs/l0r1<CR>
vmap \: :Tabularize /:\zs/l0r1<CR>
vmap \, :Tabularize /,\zs/l0r1<CR>
vmap \# :Tabularize /#/l2r1<CR>
vmap \p :!autopep8 -<CR>

" vmap <Space><Space> :!LC_ALL=C sort -u<CR>
vmap <Space><Space> :!python ~/.vim/vimscripts/py_filter_imports.py<CR>

set mouse=a
set tags=tags;

nmap <Space>t :!ctags<CR><CR>

imap <C-\><C-\> <C-y>,

syntax on

" rainbow paren
let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['brown',       'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['red',         'firebrick3'],
    \ ]

let g:rbpt_max = 16
let g:rbpt_loadcmd_toggle = 0

let g:ackprg = 'ag --nogroup --nocolor --column'

" let g:SuperTabDefaultCompletionType = "context"

autocmd VimEnter * RainbowParenthesesActivate
autocmd Syntax * RainbowParenthesesLoadRound
autocmd Syntax html,htmldjango RainbowParenthesesLoadTornado

" ----------------------

set ts=4
set sw=4
set ai
set hlsearch
set nu
set expandtab
set cursorline
set cursorcolumn
set softtabstop=4
set shiftround
set showmatch
set incsearch
set backspace=2

set fdm=manual

colorscheme ingretu

autocmd FileType clojure    set sw=2 | set ts=2 | set sts=2
autocmd FileType javascript set sw=2 | set ts=2 | set sts=2
autocmd FileType python     set sw=4 | set ts=4 | set sts=4
autocmd FileType puppet     set sw=2 | set ts=2 | set sts=2

" Don't screw up folds when inserting text that might affect them, until
" leaving insert mode. Foldmethod is local to the window. Protect against
" screwing up folding when switching between windows.
" autocmd InsertEnter * if !exists('w:last_fdm') | let w:last_fdm=&foldmethod | setlocal foldmethod=manual | endif
" autocmd InsertLeave,WinLeave * if exists('w:last_fdm') | let &l:foldmethod=w:last_fdm | unlet w:last_fdm | endif

set kp=man23

" Syntax coloring lines that are too long just slows down the world
" set synmaxcol=128

if !has('nvim')
    set ttyfast
    set ttyscroll=3
endif

set lazyredraw
