colorscheme ingretu
set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar
set guioptions-=l  "remove left-hand scroll bar
set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar
set guioptions-=R  "remove right-hand scroll bar
set guioptions-=b  "remove right-hand scroll bar

set guifont=Monaco\ for\ Powerline\ 11

map <silent> <F11>
\    :call system("wmctrl -ir " . v:windowid . " -b toggle,fullscreen")<CR>
