" Copyright 2017 Jan Edmund Doroin Lazo
"
" Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
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
setlocal commentstring=#%s

if !exists('*s:help')
  function! s:help()
    if !executable('gnuplot')
      echomsg 'gnuplot is unavailable in PATH'
      return
    endif
    call dotvim8#bang('gnuplot -e "help '.expand('<cword>').'; pause -1"')
  endfunction
endif

nnoremap <silent> <buffer> K :call <SID>help()<CR>
