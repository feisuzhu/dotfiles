syntax on
set ts=4
set sw=4
set ai
set hlsearch
set nu
set expandtab
set cursorline
set softtabstop=4
set copyindent
set shiftround
set showmatch
set ignorecase
set incsearch

set nocompatible
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" plugin manager
Bundle 'gmarik/vundle' 
" status line
Bundle 'Lokaltog/vim-powerline'
" tab completion
Bundle 'ervandew/supertab' 
" better than grep
Bundle 'mileszs/ack.vim' 
" :NERDTree
Bundle 'scrooloose/nerdtree' 
" code snippets
Bundle 'msanders/snipmate.vim' 
" syntax checking using flake8
Bundle 'scrooloose/syntastic' 
" enhanced python syntax
Bundle 'ervandew/python.vim--Vasiliev'
" python code navigating
Bundle 'klen/python-mode'
" Git integration
Bundle 'tpope/vim-fugitive'
" Markdown
Bundle 'tpope/vim-markdown'
" HTML Shortcuts
Bundle 'mattn/zencoding-vim'
" MiniBufferExplorer
" Bundle 'youngking/minibufexpl.vim'

filetype plugin indent on

set laststatus=2
set encoding=utf-8
set t_Co=256

let g:Powerline_symbols = 'fancy'

autocmd FileType python setlocal foldmethod=indent
set foldlevel=99

nmap <S-Tab> :NERDTreeToggle<CR>

let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplMapWindowNavVim=1 
let g:miniBufExplMapWindowNavArrows=1 
let g:miniBufExplModSelTarget=1

set wildignore=*.py[co]
set clipboard=unnamed
