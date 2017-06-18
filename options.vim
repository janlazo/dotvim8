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
" Tiny
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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Huge
" options below are grouped by feature (check :h feature-list)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('smartindent')
  set nosmartindent
endif

if has('cindent')
  set nocindent
endif

if has('linebreak')
  set numberwidth=4   " left-pad 3-digit line number
endif

" relativenumber is slow and can break buffer redrawing
if !has('win32unix') && $TERM !=# 'cygwin' && len($TMUX) == 0
  set relativenumber
endif

if has('cmdline_info')
  set showcmd         " display last command
endif

" highlight matches, quick-jump to nearest
if has('extra_search')
  set hlsearch incsearch
endif

" Display hints, complete with selection via tab
if has('wildmenu')
  set wildmenu wildmode=longest:full,full
endif

if has('win32')
  set shellslash    " '/' is closer to home row than '\\'
endif

if has('multi_byte')
  if &encoding ==# 'latin1' && has('gui_running')
    set encoding=utf-8
  endif
endif

if has('syntax')
  set nocursorline synmaxcol=500     " optimize for minified files

  if exists('+colorcolumn')
    set textwidth=76
    let &colorcolumn = &textwidth
  endif
endif
