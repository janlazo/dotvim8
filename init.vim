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
set inccommand=nosplit

if !has('nvim-0.3.2') && has('win32') && $TERM =~# 'cygwin' && executable('cygpath.exe')
  let s:msys_root = get(split(system('cygpath.exe -w /'), "\n"), 0, '')
  if isdirectory(s:msys_root) && empty($TERMINFO)
    let s:terminfo = s:msys_root.'usr\share\terminfo'
    if isdirectory(s:terminfo)
      let $TERMINFO = s:terminfo
    endif
    unlet s:terminfo
  endif
  unlet s:msys_root
endif
if !has('nvim-0.3')
  let g:loaded_node_provider = 1
  let g:loaded_ruby_provider = 1

  if has('win32')
    set runtimepath&vim
  endif
endif

runtime shared.vim
