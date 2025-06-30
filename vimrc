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
set nocompatible
" Moved from normal to tiny version since 8.1.882
if has('multi_byte')
  if has('win32') || (has('gui_running') && &encoding ==# 'latin1')
    set encoding=utf-8
  endif
endif
if has('patch-7.4.1570')
  set shortmess+=F
endif
if has('patch-8.1.1270') && has('patch-8.1.1375')
  set shortmess-=S
endif

" Keys
set autoindent backspace=2 nrformats-=octal
set ttimeout ttimeoutlen=50
if has('patch-7.4.0868')
  set smarttab
endif

" File
set autoread

" UI
set display=lastline laststatus=2

if has('patch-7.4.0793')
  set belloff=all
endif

if has('patch-7.4.2111')
  let g:skip_defaults_vim = 1
endif

if has('win32')
  " Fix inconsistent slashes in each filepath
  let &runtimepath = tr(&runtimepath, '/', '\')
endif

if has('gui_running')
  set guioptions=cMgRLv
  if has('terminal') && has('patch-8.1.1514')
    set guioptions+=!
  endif
  behave xterm
endif

" {{{tiny
" Moved from normal to tiny version since 8.1.1979
if has('modify_fname')
  let s:base_dir = expand('<sfile>:p:h')
endif

" Moved from small to tiny version since 8.0.1118
if has('windows')
  set tabpagemax=50
endif

" Moved from normal to tiny version since 8.1.1901
if has('insert_expand')
  set complete-=i
endif

" Moved from small to tiny version since 8.1.1823
if has('cmdline_hist')
  if has('patch-7.4.0336')
    set history=10000
  endif
endif

" Moved from normal to tiny version since 9.0.278
if has('wildignore')
  if has('patch-8.2.4325')
    set wildoptions+=pum
  endif
endif

" Moved from normal to tiny version since 9.0.279
if has('wildmenu')
  set wildmenu
endif
" }}}tiny
"{{{normal
if has('extra_search')
  set hlsearch

  if has('reltime')
    set incsearch
  endif
endif

" Vim's X-11 clipboard is broken.
" https://wiki.ubuntu.com/ClipboardPersistence#Broken_Applications
if has('clipboard')
  set clipboard=
endif

if has('persistent_undo')
  if has('modify_fname')
    let &undodir = expand(s:base_dir . '/.undodir')

    if !isdirectory(&undodir)
      call mkdir(&undodir, 'p')
    endif
  else
    set undodir=
  endif
endif
"}}}normal
" {{{huge
if has('langmap')
  if exists('+langremap')
    set nolangremap
  elseif exists('+langnoremap')
    set langnoremap
  endif
endif
" }}}huge

runtime shared.vim

if has('gui_running')
  let &columns = 81 + &numberwidth
endif

if has('modify_fname')
  unlet s:base_dir
endif
