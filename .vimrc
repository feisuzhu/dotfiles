" >>>>> Plugins
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
" Color scheme
Plug 'sainnhe/sonokai'                                            " High-contrast color scheme with multiple styles

Plug 'vim-airline/vim-airline'                                    " Lean status/tabline for Vim
Plug 'vim-airline/vim-airline-themes'                             " Theme collection for vim-airline

Plug 'scrooloose/nerdtree'                                        " File system explorer sidebar
Plug 'tmhedberg/SimpylFold'                                       " enhanced python folding
Plug 'tpope/vim-fugitive'                                         " Git integration
Plug 'tpope/vim-markdown'                                         " Markdown syntax highlighting and filetype support
Plug 'mattn/emmet-vim'                                            " HTML Shortcuts
Plug 'liuchengxu/vista.vim'                                       " LSP symbol/tag viewer sidebar
Plug 'groenewege/vim-less'                                        " LESS CSS syntax highlighting
Plug 'Lokaltog/vim-easymotion'                                    " Quick cursor jumping with motion hints
Plug 'guns/vim-clojure-static'                                    " Clojure syntax highlighting and indentation

Plug 'uarun/vim-protobuf'                                         " Protocol Buffers syntax highlighting
Plug 'mg979/vim-visual-multi'                                     " Replacement for archived vim-multiple-cursors
Plug 'puppetlabs/puppet-syntax-vim'                               " Puppet manifest syntax highlighting
Plug 'Yggdroot/indentLine'                                        " Vertical indent lines (visual marker)
Plug 'triglav/vim-visual-increment'                               " Batch Ctrl+A increment
Plug 'stephpy/vim-yaml'                                           " Improved YAML syntax highlighting
Plug 'chase/nginx.vim'                                            " Nginx config file syntax highlighting
Plug 'ntpeters/vim-better-whitespace'                             " Highlight and strip trailing whitespace
Plug 'digitaltoad/vim-jade'                                       " Jade/Pug template syntax highlighting
Plug 'godlygeek/tabular'                                          " Align your code vertically
Plug 'ekalinin/Dockerfile.vim'                                    " Dockerfile syntax highlighting and snippets

Plug 'jeroenbourgois/vim-actionscript'                            " ActionScript syntax highlighting
Plug 'rust-lang/rust.vim'                                         " Rust language support with rustfmt integration
Plug 'derekwyatt/vim-scala'                                       " Scala syntax highlighting and indentation
Plug 'EvanDotPro/nerdtree-chmod'                                  " Change file permissions from NERDTree
Plug 'robbles/logstash.vim'                                       " Logstash config syntax highlighting
Plug 'tpope/vim-surround'                                         " Fancy parentheses manipulation
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " Fuzzy finder binary (core)
Plug 'junegunn/fzf.vim'                                           " Fuzzy finder Vim commands (Files, Buffers, Rg, etc.)
Plug 'nickhutchinson/vim-systemtap'                               " SystemTap script syntax highlighting
Plug 'maksimr/vim-jsbeautify'                                     " JavaScript/HTML/CSS code formatter
Plug 'leafOfTree/vim-vue-plugin'                                  " Vue.js single-file component support
Plug 'alderz/smali-vim'                                           " Smali (Android bytecode) syntax highlighting
Plug 'dhruvasagar/vim-table-mode'                                 " Fantastic table editor
Plug 'leafgarland/typescript-vim'                                 " TypeScript syntax highlighting
Plug 'Shougo/vimproc.vim'                                         " Asynchronous execution library for Vim
Plug 'Quramy/tsuquyomi'                                           " TypeScript things
Plug 'Rykka/riv.vim'                                              " reStructuredText
" Plug 'feisuzhu/vim-pysql'                                       " Syntax highlights embedded SQL strings
Plug 'tpope/vim-commentary'                                       " Toggle comments with gcc/gc motions

Plug 'pedrohdz/vim-yaml-folds'                                    " YAML file folding support
Plug 'farmergreg/vim-lastplace'                                   " Jump to last edit location
Plug 'zchee/vim-flatbuffers'                                      " FlatBuffers schema syntax highlighting
Plug 'sgeb/vim-diff-fold'                                         " Fold diff/patch files by file section
Plug 'powerman/vim-plugin-AnsiEsc'                                " Interpret ANSI escape sequences as colors
Plug 'ojroques/vim-oscyank'                                       " Copy to system clipboard over SSH via OSC52
Plug 'mmarchini/bpftrace.vim'                                     " bpftrace script syntax highlighting
Plug 'pprovost/vim-ps1'                                           " PowerShell syntax highlighting

Plug 'tikhomirov/vim-glsl'                                        " GLSL shader language syntax highlighting
Plug 'rhysd/vim-llvm'                                             " LLVM IR and TableGen syntax highlighting

" Svelte
Plug 'othree/html5.vim'                                           " HTML5 omnicomplete and syntax highlighting
Plug 'pangloss/vim-javascript'                                    " Enhanced JavaScript syntax and indentation
Plug 'evanleck/vim-svelte', {'branch': 'main'}                    " Svelte component syntax highlighting
" /Svelte

" Autocomplete framework
Plug 'neoclide/coc.nvim', {'branch': 'release'}                   " Intellisense engine with LSP support
Plug 'antoinemadec/coc-fzf'                                       " FZF interface for CoC lists
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}       " Treesitter-based syntax highlighting and code parsing

" Avante deps
Plug 'stevearc/dressing.nvim'                                     " Improved UI for vim.ui.select and vim.ui.input
Plug 'nvim-lua/plenary.nvim'                                      " Lua utility library used by many Neovim plugins
Plug 'MunifTanjim/nui.nvim'                                       " UI component library for Neovim
Plug 'MeanderingProgrammer/render-markdown.nvim'                  " Render Markdown with concealed syntax in buffers
Plug 'hrsh7th/nvim-cmp'                                           " Auto-completion engine for Neovim
Plug 'nvim-tree/nvim-web-devicons'                                " File type icons for Neovim plugins
Plug 'HakonHarnes/img-clip.nvim'                                  " Paste images from clipboard into documents
Plug 'ibhagwan/fzf-lua'                                           " FZF picker implemented in Lua for Neovim
" /Avante deps
Plug 'yetone/avante.nvim', { 'branch': 'main', 'do': 'make' }     " AI-powered code assistant for Neovim

call plug#end()

" <<<<<
" >>>>> General Settings
filetype indent off

set exrc
set secure

set foldlevel=99

set diffopt+=vertical
set wildignore=*.py[co]

set mouse=a

set ts=4
set sw=4
set nu
set expandtab
set cursorline
set cursorcolumn
set softtabstop=4
set shiftround
set showmatch

set fdm=manual

set jumpoptions=stack

set lazyredraw

set cmdheight=2
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=number

set undofile
" <<<<<
" >>>>> Color Scheme
if has('termguicolors')
    set termguicolors
endif

" The configuration options should be placed before `colorscheme sonokai`.
let g:sonokai_style = 'default'
" let g:sonokai_style = 'andromeda'
let g:sonokai_better_performance = 1

colorscheme sonokai
" <<<<<
" >>>>> Language indentation rules
let g:indentLine_setConceal = 0
let g:indentLine_fileTypeExclude = ["nerdtree"]

autocmd FileType clojure    set sw=2 | set ts=2 | set sts=2
autocmd FileType javascript set sw=2 | set ts=2 | set sts=2
autocmd FileType python     set sw=4 | set ts=4 | set sts=4
autocmd FileType puppet     set sw=2 | set ts=2 | set sts=2
autocmd FileType rust       set sw=4 | set ts=4 | set sts=4
autocmd FileType go         set sw=4 | set ts=4 | set sts=4 | set noexpandtab
" <<<<<
" >>>>> Clipboard
set clipboard=unnamedplus
" <<<<<
" >>>>> General Key Bindings
nmap <Space>k :wincmd k<CR>
nmap <Space>j :wincmd j<CR>
nmap <Space>h :wincmd h<CR>
nmap <Space>l :wincmd l<CR>

nnoremap _ :cprev<CR>
nnoremap + :cnext<CR>

nmap \\ :nohl<CR>:set nopaste<CR>
" vmap <Space><Space> :!LC_ALL=C sort -u<CR>
nmap <Space>i ggVG:!~/.vim/vimscripts/py_filter_imports.py --force-stdin --files %<CR>

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
hi EasyMotionTarget ctermbg=none ctermfg=white
hi EasyMotionShade  ctermbg=none ctermfg=blue
" <<<<<
" >>>>> Vista
nmap <S-Tab> :Vista coc<CR>
" <<<<<
" >>>>> airline
let g:airline#extensions#default#layout = [
    \ [ 'a', 'b', 'warning', 'error', 'c' ],
    \ [ 'x', 'y', 'z']
    \ ]
" <<<<<
" >>>>> fzf
nmap sf :Files<CR>
" nmap st :Tags<CR>
nmap st :CocFzfList symbols<CR>
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
" >>>>> riv (reStructuredText)
let g:riv_ignored_imaps = "<Tab>,<S-Tab>"
let g:riv_ignored_nmaps = "<Tab>,<S-Tab>"
" <<<<<
" >>>>> NERDTree
let NERDTreeIgnore = ['\.py[co]$', '\.o$', 'a\.out$', '^__pycache__$']
nmap <Tab> :NERDTreeToggle<CR>
nmap \l :NERDTreeFind<CR>
" <<<<<
" >>>>> coc.nvim
" \   'coc-git',
" \   'coc-jedi',
" \   'coc-rls',
let g:coc_global_extensions = [
\   'coc-json',
\   'coc-pyright',
\   'coc-rust-analyzer',
\   'coc-go',
\   'coc-tsserver',
\   'coc-clangd',
\ ]

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

if has('nvim')
  inoremap <silent><expr> <c-p> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

inoremap <expr><S-Tab> coc#pum#visible() ? coc#pum#prev(1) : ""
inoremap <silent><expr> <Tab> coc#pum#visible() ? coc#pum#next(1) : "\<Tab>"
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

nnoremap <silent> - :<C-u>call CocActionAsync('diagnosticNext',     'warning')<CR>
nnoremap <silent> = :<C-u>call CocActionAsync('diagnosticPrevious', 'warning')<CR>


" GoTo code navigation.
" nmap <silent> gd <Plug>(coc-definition)

function! s:coc_fzf_code_jump()
    let l:options = {
\        'source': [
\            "jumpReferences",
\            "jumpDeclaration",
\            "jumpTypeDefinition",
\            "jumpImplementation",
\            "jumpDefinition",
\        ],
\        'options': ["--no-sort"],
\        'sink': function("CocActionAsync"),
\    }
    call fzf#run(fzf#wrap(l:options))
endfunction

autocmd FileType c,cpp,java,php,python,perl,rust,clojure,go,yaml nmap <buffer> <C-]> <Plug>(coc-definition)
autocmd FileType c,cpp,java,php,python,perl,rust,clojure,go,yaml nmap <buffer> } :call <SID>coc_fzf_code_jump()<CR>

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <F2> <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>F  <Plug>(coc-format-selected)
nmap <leader>F  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" NeoVim-only mapping for visual mode scroll
" Useful on signatureHelp after jump placeholder of snippet expansion
if has('nvim')
  vnoremap <nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#nvim_scroll(1, 1) : "\<C-f>"
  vnoremap <nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#nvim_scroll(0, 1) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings fr CoCList
" Show all diagnostics.
" nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Modified by Proton: Replace CocList with CocFzfList
nnoremap <silent><nowait> <space><space>  :<C-u>CocFzfList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocFzfList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocFzfList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocFzfList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocFzfList symbols<cr>
" Do default action for next item.
" nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
nnoremap <silent><nowait> + :<C-u>CocNext<CR>
" Do default action for previous item.
" nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
nnoremap <silent><nowait> _ :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocFzfListResume<CR>

nmap ' <Plug>(coc-codelens-action)


" ---------------------
" Added by meta
nnoremap <Space><Enter> :<C-u>CocFzfList<CR>
vnoremap <Space><Enter> :CocFzfList<CR>

" <<<<<
" >>>>> Python rules
" autocmd FileType python let g:SuperTabDefaultCompletionType = "<c-x><c-o>"
" autocmd BufEnter *.py nnoremap <buffer> <C-]> :call jedi#goto()<CR>
vmap \p :!autopep8 -<CR>
" <<<<<
" >>>>> Rust rules
let g:rustfmt_autosave = 1
autocmd FileType rust set makeprg=cargo\ build
" <<<<<
" >>>>> Markdown quirks
let mdtypes = ['md', 'markdown']

if index(mdtypes, &filetype) == -1
  let g:table_mode_corner = '|'
else
  let g:table_mode_corner_corner = '+'
  let g:table_mode_header_fillchar = '='
  let g:airline_powerline_fonts = 1
endif
" <<<<<
" >>>>> Helm quirks
autocmd BufRead,BufNewFile */templates/*.yaml set ft=helm
autocmd BufRead,BufNewFile */templates/_helpers.tpl set ft=helm
autocmd BufRead,BufNewFile */templates/NOTES.txt set ft=gotmpl
" <<<<<
" >>>>> Misc stuff
" Trim trailing spaces
autocmd FileType c,cpp,java,php,python,perl,rust,clojure,go,yaml autocmd BufWritePre <buffer> :%s/\s\+$//e
autocmd BufNewFile,BufRead git-revise-todo set filetype=gitrebase
" <<<<<
" >>>>> Treesitter
lua <<EOF
require('nvim-treesitter.configs').setup {
  prefer_git = true,
  ensure_installed = "all",
  highlight = { enable = true },
  -- indent = { enable = true }
}
-- vim.treesitter.language.register("dockerfile", "Dockerfile")
EOF
" <<<<<
" >>>>> Avante.nvim
if has("nvim")
    lua <<EOF
    if vim.env.DEEPSEEK_API_KEY then
        require('avante').setup({
          provider = "deepseek",
          providers = {
            deepseek = {
              __inherited_from = "openai",
              api_key_name = "DEEPSEEK_API_KEY",
              endpoint = "https://api.deepseek.com",
              model = "deepseek-chat",
              max_tokens = 8192,
            },
          },
        })
    else
        vim.notify("DEEPSEEK_API_KEY environment variable not found. avante.nvim will not be initialized.", vim.log.levels.WARN)
    end
EOF
endif
" <<<<<
"
" vim: set foldmethod=marker foldmarker=>>>>>,<<<<< foldlevel=0:
