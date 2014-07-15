set nocompatible
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" plugin manager
Plugin 'gmarik/vundle'
" Color scheme
Plugin 'feisuzhu/ingretu'
" status line
Plugin 'Lokaltog/vim-powerline'
" tab completion
Plugin 'ervandew/supertab'
" better than grep
Plugin 'mileszs/ack.vim'
" :NERDTree
Plugin 'scrooloose/nerdtree'
" syntax checking using flake8
Plugin 'scrooloose/syntastic'
" enhanced python syntax
" Plugin 'ervandew/python.vim--Vasiliev'
" Python folding
Plugin 'feisuzhu/python-folding.vim'
" python code navigating
" Plugin 'klen/python-mode'
" Git integration
Plugin 'tpope/vim-fugitive'
" Markdown
Plugin 'tpope/vim-markdown'
" HTML Shortcuts
Plugin 'mattn/emmet-vim'
" Close buffer without closing window
Plugin 'rbgrouleff/bclose.vim'
" TagBar
" Plugin 'majutsushi/tagbar'
" Command-T
Plugin 'wincent/Command-T'

Plugin 'vim-scripts/OmniCppComplete'
Plugin 'groenewege/vim-less'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'guns/vim-clojure-static'
Plugin 'tpope/vim-fireplace'
Plugin 'tpope/vim-classpath'
Plugin 'feisuzhu/rainbow_parentheses.vim'
Plugin 'uarun/vim-protobuf'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'kchmck/vim-coffee-script'
Plugin 'puppetlabs/puppet-syntax-vim'
Plugin 'Yggdroot/indentLine'
Plugin 'triglav/vim-visual-increment'
Plugin 'stephpy/vim-yaml'
Plugin 'chase/nginx.vim'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'digitaltoad/vim-jade.git'
Plugin 'godlygeek/tabular'
Plugin 'milkypostman/vim-togglelist'



" filetype plugin indent on

set exrc
set secure

set laststatus=2
set encoding=utf-8
set t_Co=256

let g:CommandTMaxFiles = 50000
let g:Powerline_symbols = 'fancy'

" autocmd FileType python setlocal foldmethod=indent
set foldlevel=99

nmap <Tab> :NERDTreeToggle<CR>
nmap <S-Tab> :TagbarToggle<CR>

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

" map <Leader>g :RopeGotoDefinition<CR>
" map <Leader>r :RopeRename<CR>

cnoreabbrev bd Bclose

let g:EasyMotion_leader_key = '\O'

nmap <Space><Up> :wincmd k<CR>
nmap <Space><Down> :wincmd j<CR>
nmap <Space><Left> :wincmd h<CR>
nmap <Space><Right> :wincmd l<CR>

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

nmap \T :CommandTTag<CR>
nmap \l :NERDTreeFind<CR>
nmap \\ :nohl<CR>:set nopaste<CR>:setlocal fdm=syntax<CR>:setlocal fdm=manual<CR>
vmap \= :Tabularize /^[^=]*\zs/l0r1<CR>
vmap \: :Tabularize /:\zs/l0r1<CR>
vmap \, :Tabularize /,\zs/l0r1<CR>
vmap \# :Tabularize /#/l2r1<CR>
vmap \p :!autopep8 -<CR>

vmap <Space><Space> :!LC_ALL=C sort -u<CR>

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

autocmd FileType clojure set sw=2 | set ts=2 | set sts=2
autocmd FileType javascript set sw=2 | set ts=2 | set sts=2

" Don't screw up folds when inserting text that might affect them, until
" leaving insert mode. Foldmethod is local to the window. Protect against
" screwing up folding when switching between windows.
" autocmd InsertEnter * if !exists('w:last_fdm') | let w:last_fdm=&foldmethod | setlocal foldmethod=manual | endif
" autocmd InsertLeave,WinLeave * if exists('w:last_fdm') | let &l:foldmethod=w:last_fdm | unlet w:last_fdm | endif

set kp=man23

" Syntax coloring lines that are too long just slows down the world
" set synmaxcol=128

set ttyfast
set ttyscroll=3
set lazyredraw
