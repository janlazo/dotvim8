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
let s:base_dir = expand('<sfile>:p:h')

if has('win32')
  " neovim-qt mangles the runtimepath so revert to Vim defaults
  if !isdirectory($NVIM_QT_RUNTIME_PATH)
    set runtimepath&vim
  endif
endif

runtime shared.vim

if has('win32')
  if has('nvim-0.2')
    let s:python = exepath('python2.exe')

    if !empty(s:python)
      let g:python_host_prog  = s:python
    endif

    let s:python = exepath('python3.exe')

    if !empty(s:python)
      let g:python3_host_prog = s:python
    endif

    unlet s:python
  else
    let g:loaded_python_provider = 1
    let g:loaded_python3_provider = 1
  endif

  if !has('nvim-0.2.3')
    let g:loaded_ruby_provider = 1
  endif
endif

if !has('nvim-0.2.3')
  let g:loaded_node_provider = 1
endif

if has('nvim-0.2')
  set inccommand=nosplit
endif

if exists('g:nyaovim_version')
  set mouse=a
endif

call bundle#init()
