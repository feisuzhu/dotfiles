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

Bundle 'vim-scripts/OmniCppComplete'
Bundle 'groenewege/vim-less'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'kien/rainbow_parentheses.vim'

" filetype plugin indent on

set exrc
set secure

set laststatus=2
set encoding=utf-8
set t_Co=256

let g:CommandTMaxFiles = 50000
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
au FileType c,cpp set omnifunc=OmniCppComplete
set completeopt=menuone,longest,preview

let NERDTreeIgnore = ['\.py[co]$']

" map <Leader>g :RopeGotoDefinition<CR>
" map <Leader>r :RopeRename<CR>

cnoreabbrev bd Bclose

nmap <Space><Up> :wincmd k<CR>
nmap <Space><Down> :wincmd j<CR>
nmap <Space><Left> :wincmd h<CR>
nmap <Space><Right> :wincmd l<CR>

nmap <Space>k :wincmd k<CR>
nmap <Space>j :wincmd j<CR>
nmap <Space>h :wincmd h<CR>
nmap <Space>l :wincmd l<CR>

autocmd FileType c,cpp,java,php,python,perl autocmd BufWritePre <buffer> :%s/\s\+$//e
" cnoreabbrev clean %s/\s\+$//e

nmap - :lprev<CR>
nmap = :lnext<CR>

nmap \T :CommandTTag<CR>
nmap \l :NERDTreeFind<CR>
nmap \\\ :nohl<CR>:set nopaste<CR>

set mouse=a
set tags=tags;

cnoreabbrev tags !ctags

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
    \ ['brown',       'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['red',         'firebrick3'],
    \ ]

let g:rbpt_max = 16
let g:rbpt_loadcmd_toggle = 0

autocmd VimEnter * RainbowParenthesesActivate
autocmd Syntax * RainbowParenthesesLoadRound

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

