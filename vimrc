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

" Keys
set autoindent backspace=2 nrformats-=octal

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

if has('multi_byte')
  if has('win32') || (has('gui_running') && &encoding ==# 'latin1')
    set encoding=utf-8
  endif
endif

if has('win32')
  " Fix inconsistent slashes in each filepath
  let &runtimepath = tr(&runtimepath, '/', '\')
endif

if has('gui_running')
  set guioptions=cMgRLv
  behave xterm
endif

runtime shared.vim

if has('patch-8.1.1270') && has('patch-8.1.1375')
  set shortmess-=S
endif

if has('gui_running')
  let &columns = 81 + &numberwidth
endif
