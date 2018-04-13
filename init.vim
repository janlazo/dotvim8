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
if has('win32')
  " neovim-qt mangles the runtimepath so revert to Vim defaults
  if !isdirectory($NVIM_QT_RUNTIME_PATH)
    set runtimepath&vim
  endif
endif

runtime shared.vim

if has('nvim-0.2')
  set inccommand=nosplit

  let s:hosts = {
  \ 'python':  'python2.exe',
  \ 'python3': 'python3.exe'
  \ }
  for [s:key, s:val] in items(s:hosts)
    let s:val = exepath(s:val)
    if !empty(s:val)
      let g:[s:key . '_host_prog'] = s:val
    endif
  endfor
  unlet s:hosts s:key s:val
else
  let g:loaded_python_provider = 1
  let g:loaded_python3_provider = 1
endif

if !has('nvim-0.2.3')
  let g:loaded_node_provider = 1
  let g:loaded_ruby_provider = 1
endif

call bundle#init()
