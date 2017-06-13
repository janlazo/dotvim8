" 4-space Indent
set tabstop=4 shiftwidth=4 expandtab nosmarttab
set autoindent shiftround

" Line Wrap
set wrap textwidth=72

" Splits
set splitbelow splitright

" UI
"" Center
set nostartofline noshowmatch       " don't randomly move the cursor
set scrolloff=1 sidescroll=5        " always show 1 line, 5 cols
set display=lastline                " don't mangle last line of buffer

"" Left
set number relativenumber

"" Bottom
set laststatus=2 cmdheight=2 noshowmode

" Fixes
set autoread
set novisualbell noerrorbells
set nolazyredraw                    " lazyredraw is still broken
set backspace=2 whichwrap=<,>,b,s
set fileformats=unix,dos,mac
set nrformats-=octal
