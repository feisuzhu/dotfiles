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
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" tab completion
Plug 'ervandew/supertab'
" better than grep
Plug 'mileszs/ack.vim'
" :NERDTree
Plug 'scrooloose/nerdtree'
" syntax checking
Plug 'w0rp/ale'
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
Plug 'majutsushi/tagbar'
Plug 'vim-scripts/OmniCppComplete'
Plug 'groenewege/vim-less'
Plug 'Lokaltog/vim-easymotion'
Plug 'guns/vim-clojure-static'

" Plug 'tpope/vim-fireplace'
" Plug 'tpope/vim-classpath'
" Plug 'venantius/vim-eastwood'

Plug 'luochen1990/rainbow'
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
Plug 'davidhalter/jedi-vim'
Plug 'derekwyatt/vim-scala'
Plug 'EvanDotPro/nerdtree-chmod'
Plug 'robbles/logstash.vim'
Plug 'tpope/vim-surround'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'nickhutchinson/vim-systemtap'
Plug 'maksimr/vim-jsbeautify'
Plug 'fatih/vim-go'
Plug 'posva/vim-vue'
Plug 'alderz/smali-vim'
Plug 'dhruvasagar/vim-table-mode'
Plug 'leafgarland/typescript-vim'
Plug 'Shougo/vimproc.vim'
Plug 'Quramy/tsuquyomi'
Plug 'Rykka/riv.vim'  " reStructuredText
Plug 'feisuzhu/vim-pysql'
Plug 'wesQ3/vim-windowswap'
call plug#end()

filetype plugin on
filetype indent off

set exrc
set secure

set laststatus=2
set encoding=utf-8
set t_Co=256

let mdtypes = ['md', 'markdown']

if index(mdtypes, &filetype) == -1
  let g:table_mode_corner_corner = '+'
  let g:table_mode_header_fillchar = '='
else
  let g:airline_powerline_fonts = 1
  let g:airline#extensions#ale#enabled = 1
endif
" let g:table_mode_delete_row_map = 'tdd'
" let g:table_mode_delete_column_map = 'tdc'
" let g:table_mode_realign_map = 'tr'

nmap tr <Plug>(table-mode-realign)
nmap tdd <Plug>(table-mode-delete-row)
nmap tdc <Plug>(table-mode-delete-column)

" autocmd FileType python setlocal foldmethod=indent
set foldlevel=99

nmap <Tab> :NERDTreeToggle<CR>
nmap <S-Tab> :TagbarToggle<CR>

let g:riv_ignored_imaps = "<Tab>,<S-Tab>"
let g:riv_ignored_nmaps = "<Tab>,<S-Tab>"

set diffopt+=vertical

set wildignore=*.py[co]

let os=substitute(system('uname'), '\n', '', '')

if os == 'Darwin' || os == 'Mac'
    set clipboard=unnamed
else
    set clipboard=unnamedplus
endif

let NERDTreeIgnore = ['\.py[co]$', '\.o$', 'a\.out$', '^__pycache__$']

let g:EasyMotion_leader_key = '\O'

nmap <Space>k :wincmd k<CR>
nmap <Space>j :wincmd j<CR>
nmap <Space>h :wincmd h<CR>
nmap <Space>l :wincmd l<CR>

nmap <Space>f \Of
nmap <Space>F \OF
nmap <Space>w \Ow
nmap <Space>b \Ob

let g:toggle_list_no_mappings = 1
nmap <Space><Space> :call ToggleLocationList()<CR>

autocmd FileType c,cpp,java,php,python,perl autocmd BufWritePre <buffer> :%s/\s\+$//e

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
nmap <Space>T :TableModeToggle<CR><CR>
nmap <Space>R :TableModeRealign<CR><CR>

imap <C-\><C-\> <C-y>,

syntax on

let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle
let g:rainbow_conf = {
\	'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
\	'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
\	'operators': '_,_',
\	'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
\	'separately': {
\		'*': {},
\		'tex': {
\			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
\		},
\		'lisp': {
\			'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
\		},
\		'vim': {
\			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
\		},
\		'html': {
\			'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
\		},
\		'css': 0,
\	}
\}

let g:ackprg = 'ag --nogroup --nocolor --column'

let g:ale_linters = {'go': ['gometalinter']}
" let g:ale_go_gometalinter_options = '--disable-all --enable=deadcode --enable=unused --enable=staticcheck --enable=structcheck --enable=golint --enable=errcheck --enable=goconst --enable=gocyclo --enable=gotype'
let g:ale_go_gometalinter_options = '--disable-all --enable=deadcode --enable=golint --enable=errcheck --enable=gocyclo --enable=gotype'

" let g:SuperTabDefaultCompletionType = "context"
autocmd FileType go let g:SuperTabDefaultCompletionType = "<c-x><c-o>"
autocmd FileType python let g:SuperTabDefaultCompletionType = "<c-x><c-o>"

autocmd BufEnter * :syntax sync fromstart
autocmd BufEnter * nnoremap <buffer> <C-]> :call jedi#goto()<CR>

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

" Syntax coloring lines that are too long just slows down the world
" set synmaxcol=128

if !has('nvim')
    set ttyfast
    set ttyscroll=3
endif

if has('nvim')
    tnoremap <C-\><C-\> <C-\><C-n>
endif

set lazyredraw
