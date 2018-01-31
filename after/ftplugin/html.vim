" Copyright 2018 Jan Edmund Doroin Lazo
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
let s:cpoptions = &cpoptions
set cpoptions&vim
setlocal commentstring=<!--%s-->

if !exists('*s:update_commentstring')
  function s:update_commentstring()
    let syntax_name = synIDattr(synID(line('.'), col('.'), 1), 'name')
    if syntax_name =~# '^css'
      setlocal commentstring=/*%s*/
    else
      setlocal commentstring=<!--%s-->
    endif
  endfunction
endif

autocmd CursorMoved <buffer> call s:update_commentstring()
let &cpoptions = s:cpoptions
unlet s:cpoptions
