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
if 1
  " Disable defaults.vim
  let g:skip_defaults_vim = 1

  " unset 'compatible' in normal/huge versions
  if &compatible
    set nocompatible
  endif

  " Fix for Vim 7.2 (Windows)
  if empty($MVIMRC)
    let $MYVIMRC = expand('<sfile>:p')
  endif
endif

if has('win32')
  " Fix inconsistent slashes in each filepath
  let &runtimepath = tr(&runtimepath, '/', '\')
endif

if has('gui_running')
  " remove all GUI bloat taking up screen space
  set guioptions=cMgRLv
endif

runtime shared.vim
