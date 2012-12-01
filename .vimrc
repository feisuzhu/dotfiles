syntax on
set ts=4
set sw=4
set ai
set hlsearch
set nu
set expandtab
set cursorline
set softtabstop=4
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
" Bundle 'klen/python-mode'
" Git integration
Bundle 'tpope/vim-fugitive'
" Markdown
Bundle 'tpope/vim-markdown'
" HTML Shortcuts
Bundle 'mattn/zencoding-vim'
" MiniBufferExplorer
" Bundle 'youngking/minibufexpl.vim'
" Close buffer without closing window
Bundle 'rbgrouleff/bclose.vim'
" TagBar
Bundle 'majutsushi/tagbar'
" Command-T
Bundle 'wincent/Command-T'

filetype plugin indent on

set laststatus=2
set encoding=utf-8
set t_Co=256

let g:Powerline_symbols = 'fancy'

autocmd FileType python setlocal foldmethod=indent
set foldlevel=99

nmap <Tab> :NERDTreeToggle<CR>
nmap <S-Tab> :TagbarToggle<CR>

let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplMapWindowNavVim=1 
let g:miniBufExplMapWindowNavArrows=1 
let g:miniBufExplModSelTarget=1

set wildignore=*.py[co]
set clipboard=unnamed

au FileType python set omnifunc=pythoncomplete#Complete
set completeopt=menuone,longest,preview

let NERDTreeIgnore = ['\.py[co]$']

" map <Leader>g :RopeGotoDefinition<CR>
" map <Leader>r :RopeRename<CR>

cnoreabbrev bd Bclose

nmap <Space><Up> :wincmd k<CR>
nmap <Space><Down> :wincmd j<CR>
nmap <Space><Left> :wincmd h<CR>
nmap <Space><Right> :wincmd l<CR>

autocmd FileType c,cpp,java,php,python,perl autocmd BufWritePre <buffer> :%s/\s\+$//e

nmap - :lprev<CR>
nmap = :lnext<CR>

nmap \w :cprev<CR>
nmap \s :cnext<CR>

set mouse=a
set tags=tags;
set autochdir

cnoreabbrev tags !ctags -R

imap <C-\><C-\> <C-y>,
