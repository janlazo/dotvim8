" Copyright 2017 Jan Edmund Doroin Lazo
" 
" Licensed under the Apache License, Version 2.0 (the "License");
" you may not use this file except in compliance with the License.
" You may obtain a copy of the License at
" 
" http://www.apache.org/licenses/LICENSE-2.0
" 
" Unless required by applicable law or agreed to in writing, software
" distributed under the License is distributed on an "AS IS" BASIS,
" WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
" See the License for the specific language governing permissions and
" limitations under the License.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 4-space Indent
set tabstop=4 shiftwidth=4 expandtab nosmarttab
set autoindent shiftround

" Line Wrap
set wrap textwidth=72 formatoptions=crl

" Splits
set splitbelow splitright

" UI
"" Center
set nostartofline noshowmatch       " don't randomly move the cursor
set scrolloff=1 sidescroll=5        " always show 1 line, 5 cols
set display=lastline                " don't mangle last line of buffer

"" Left
set number norelativenumber

"" Bottom
set laststatus=2 cmdheight=2 showmode

" Fixes
set autoread
set novisualbell noerrorbells
set nolazyredraw                    " lazyredraw is still broken
set backspace=2 whichwrap=<,>,b,s
set fileformats=unix,dos,mac
set nrformats-=octal
