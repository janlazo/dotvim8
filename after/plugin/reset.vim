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
if exists('g:loaded_after_plugin_reset')
  finish
endif
let g:loaded_after_plugin_reset = 1
let s:cpoptions = &cpoptions
set cpoptions&vim

let s:formatoptions = &formatoptions

" Reset Vim options managed by ftplugin and syntax files
function s:reset_opts()
  let &formatoptions = s:formatoptions
endfunction

augroup dotvim8_reset
  autocmd!
  autocmd BufWinEnter,BufNewFile * call s:reset_opts()
augroup END

let &cpoptions = s:cpoptions
unlet s:cpoptions
