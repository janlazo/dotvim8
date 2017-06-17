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
" source this after tiny.vim
" options are grouped by feature (check :h feature-list)
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
