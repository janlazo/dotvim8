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
let s:cpoptions = &cpoptions
set cpoptions&vim
setlocal commentstring=<!--%s-->

function! s:make(ft)
  if empty(a:ft)
    echomsg 'Filetype required'
    return
  elseif !executable('pandoc')
    echomsg 'pandoc is not in $PATH'
    return
  endif

  let cur_file = expand('%:p')

  if empty(cur_file)
    echomsg 'Cannot get absolute filepath in buffer'
    return
  endif

  let output = fnamemodify(cur_file, ':r') . '.' . a:ft
  let job_cmd = ['pandoc']

  if executable('pandoc-citeproc')
    call extend(job_cmd, ['--filter', 'pandoc-citeproc'])
  endif

  call dotvim8#jobstart(extend(job_cmd, ['-so', output, cur_file]))
endfunction

command! -buffer -nargs=1 -complete=filetype Pandoc call s:make(<f-args>)
let &cpoptions = s:cpoptions
unlet s:cpoptions
