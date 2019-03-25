set nocompatible

" >>>>> Plugins
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
" Color scheme
Plug 'feisuzhu/ingretu'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'mileszs/ack.vim' " better than grep
Plug 'scrooloose/nerdtree'
Plug 'w0rp/ale' " asynchronous linting engine
Plug 'tmhedberg/SimpylFold' " enhanced python folding
Plug 'tpope/vim-fugitive' " Git integration
Plug 'tpope/vim-markdown'
Plug 'mattn/emmet-vim' " HTML Shortcuts
Plug 'majutsushi/tagbar'
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
Plug 'Yggdroot/indentLine' " Vertical indent lines (visual marker)
Plug 'triglav/vim-visual-increment' " Batch Ctrl+A increment
Plug 'stephpy/vim-yaml'
Plug 'chase/nginx.vim'
Plug 'ntpeters/vim-better-whitespace'
Plug 'digitaltoad/vim-jade'
Plug 'godlygeek/tabular' " Align your code vertically
Plug 'milkypostman/vim-togglelist'
Plug 'ekalinin/Dockerfile.vim'

" Text object for python
Plug 'kana/vim-textobj-user'
Plug 'bps/vim-textobj-python'

Plug 'jeroenbourgois/vim-actionscript'
Plug 'rust-lang/rust.vim'
Plug 'davidhalter/jedi-vim'  " Python things
Plug 'derekwyatt/vim-scala'
Plug 'EvanDotPro/nerdtree-chmod'
Plug 'robbles/logstash.vim'
Plug 'tpope/vim-surround'  " Fancy parentheses manipulation
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'nickhutchinson/vim-systemtap'
Plug 'maksimr/vim-jsbeautify'
Plug 'fatih/vim-go'
Plug 'posva/vim-vue'
Plug 'alderz/smali-vim'
Plug 'dhruvasagar/vim-table-mode' " Fantastic table editor
Plug 'leafgarland/typescript-vim'
Plug 'Shougo/vimproc.vim'
Plug 'Quramy/tsuquyomi'  " TypeScript things
Plug 'Rykka/riv.vim'  " reStructuredText
Plug 'feisuzhu/vim-pysql'  " Syntax highlights embedded SQL strings
Plug 'pangloss/vim-javascript'

" Autocomplete framework
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

Plug 'zchee/deoplete-jedi'   " Python code completion
Plug 'racer-rust/vim-racer'  " Rust code completion

call plug#end()
" <<<<<
" >>>>> General Settings
filetype plugin on
filetype indent off

set exrc
set secure

set laststatus=2
set encoding=utf-8
set t_Co=256

set foldlevel=99

set diffopt+=vertical
set wildignore=*.py[co]

set mouse=a
set tags=tags;

autocmd BufEnter * :syntax sync fromstart

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

if !has('nvim')
    set ttyfast
    set ttyscroll=3
endif

set lazyredraw
syntax on
" <<<<<
" >>>>> Language indentation rules
autocmd FileType clojure    set sw=2 | set ts=2 | set sts=2
autocmd FileType javascript set sw=2 | set ts=2 | set sts=2
autocmd FileType python     set sw=4 | set ts=4 | set sts=4
autocmd FileType puppet     set sw=2 | set ts=2 | set sts=2
autocmd FileType rust       set sw=4 | set ts=4 | set sts=4
" <<<<<
" >>>>> Clipboard
let os=substitute(system('uname'), '\n', '', '')
if os == 'Darwin' || os == 'Mac'
    set clipboard=unnamed
else
    set clipboard=unnamedplus
endif
" <<<<<
" >>>>> General Key Bindings
nmap <Space>k :wincmd k<CR>
nmap <Space>j :wincmd j<CR>
nmap <Space>h :wincmd h<CR>
nmap <Space>l :wincmd l<CR>

nmap - :lprev<CR>
nmap = :lnext<CR>

nnoremap _ :cprev<CR>
nnoremap + :cnext<CR>

nmap \\ :nohl<CR>:set nopaste<CR>
" vmap <Space><Space> :!LC_ALL=C sort -u<CR>
vmap <Space><Space> :!python ~/.vim/vimscripts/py_filter_imports.py %<CR>

nmap <Space>t :!ctags<CR><CR>

if has('nvim')
    " Escape from terminal
    tnoremap <C-\><C-\> <C-\><C-n>
endif
" <<<<<
" >>>>> EasyMotion
nmap <Space>f <Plug>(easymotion-prefix)f
nmap <Space>F <Plug>(easymotion-prefix)F
nmap <Space>w <Plug>(easymotion-prefix)w
nmap <Space>b <Plug>(easymotion-prefix)b
" <<<<<
" >>>>> togglelist
let g:toggle_list_no_mappings = 1
nmap <Space><Space> :call ToggleLocationList()<CR>
" <<<<<
" >>>>> Tagbar
nmap <S-Tab> :TagbarToggle<CR>
" <<<<<
" >>>>> fzf
nmap sf :Files<CR>
" nmap st :Tags<CR>
" <<<<<
" >>>>> tabular
vmap \= :Tabularize /^[^=]*\zs/l0r1<CR>
vmap \: :Tabularize /:\zs/l0r1<CR>
vmap \, :Tabularize /,\zs/l0r1<CR>
vmap \# :Tabularize /#/l2r1<CR>
" <<<<<
" >>>>> emmet
imap <C-\><C-\> <Plug>(emmet-expand-abbr)
" <<<<<
" >>>>> vim-table-mode
nmap tr <Plug>(table-mode-realign)
nmap tdd <Plug>(table-mode-delete-row)
nmap tdc <Plug>(table-mode-delete-column)
nmap <Space>T :TableModeToggle<CR><CR>
nmap <Space>R :TableModeRealign<CR><CR>
" <<<<<
" >>>>> vim-go
let g:go_version_warning = 0
" <<<<<
" >>>>> riv (reStructuredText)
let g:riv_ignored_imaps = "<Tab>,<S-Tab>"
let g:riv_ignored_nmaps = "<Tab>,<S-Tab>"
" <<<<<
" >>>>> NERDTree
let NERDTreeIgnore = ['\.py[co]$', '\.o$', 'a\.out$', '^__pycache__$']
nmap <Tab> :NERDTreeToggle<CR>
nmap \l :NERDTreeFind<CR>
" <<<<<
" >>>>> Rainbow parentheses
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
" <<<<<
" >>>>> ack.vim
let g:ackprg = 'ag --nogroup --nocolor --column'
" <<<<<
" >>>>> ale
let g:ale_linters = {'go': ['gometalinter'], 'python': ['flake8']}
" let g:ale_go_gometalinter_options = '--disable-all --enable=deadcode --enable=unused --enable=staticcheck --enable=structcheck --enable=golint --enable=errcheck --enable=goconst --enable=gocyclo --enable=gotype'
let g:ale_go_gometalinter_options = '--disable-all --enable=deadcode --enable=golint --enable=errcheck --enable=gocyclo --enable=gotype'
" <<<<<
" >>>>> deoplete
let g:deoplete#enable_at_startup = 1
" Disable popup text truncation
call deoplete#custom#source('racer', 'max_abbr_width', 0)
call deoplete#custom#source('racer', 'max_menu_width', 0)
" <TAB> for completion
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

" Disable completion when using multiple cursors
function! Multiple_cursors_before()
    call deoplete#custom#option('auto_complete', v:false)
endfunction

function! Multiple_cursors_after()
    call deoplete#custom#option('auto_complete', v:true)
endfunction
" <<<<<
" >>>>> jedi
let g:jedi#completions_enabled=0
" <<<<<
" >>>>> Golang rules
autocmd FileType go let g:SuperTabDefaultCompletionType = "<c-x><c-o>"
" <<<<<
" >>>>> Python rules
autocmd FileType python let g:SuperTabDefaultCompletionType = "<c-x><c-o>"
autocmd BufEnter *.py nnoremap <buffer> <C-]> :call jedi#goto()<CR>
vmap \p :!autopep8 -<CR>
" <<<<<
" >>>>> Rust rules
let g:rustfmt_autosave = 1
autocmd FileType rust nmap <buffer> <C-]> <Plug>(rust-def)
autocmd FileType rust nmap <buffer> K <Plug>(rust-doc)
autocmd FileType rust set makeprg=cargo
" <<<<<
" >>>>> Markdown quirks
let mdtypes = ['md', 'markdown']

if index(mdtypes, &filetype) == -1
  let g:table_mode_corner_corner = '+'
  let g:table_mode_header_fillchar = '='
else
  let g:airline_powerline_fonts = 1
  let g:airline#extensions#ale#enabled = 1
endif
" <<<<<
" >>>>> Misc stuff
" Trim trailing spaces
autocmd FileType c,cpp,java,php,python,perl,rust,clojure,go autocmd BufWritePre <buffer> :%s/\s\+$//e
" <<<<<

" vim: set foldmethod=marker foldmarker=>>>>>,<<<<< foldlevel=0:
