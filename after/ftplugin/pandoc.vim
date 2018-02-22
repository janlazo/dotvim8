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

if !exists('*s:version')
  " Return the version number in output of 'pandoc --version'
  " Return empty if pandoc is unavailable or the output cannot be parsed.
  function! s:version()
    if !executable('pandoc')
      return ''
    endif
    let pandoc_v = get(split(system('pandoc --version'), "\n"), 0, '')
    if empty(pandoc_v)
      return ''
    endif
    return get(split(pandoc_v), 1, '')
  endfunction
endif

if !exists('*s:job_exit')
  function! s:job_exit(id, data, ...)
    unlet s:pandoc_job
    if exists('b:pandoc_job')
      unlet b:pandoc_job
    endif
  endfunction
endif

if !exists('*s:make')
  function! s:make(ft)
    if empty(a:ft)
      echomsg 'Filetype required'
      return
    elseif !executable('pandoc')
      echomsg 'pandoc is not in $PATH'
      return
    elseif !exists('*CompareSemver')
      echomsg 'CompareSemver() required to compare versions'
      return
    elseif exists('s:pandoc_job')
      echomsg 'Check b:pandoc_job for current pandoc job'
      return
    endif

    let pandoc_v = s:version()

    if pandoc_v !~# '^[0-9]\.[0-9]'
      echomsg '"pandoc --version" returned invalid output'
      return
    endif

    let cur_file = expand('%:p')

    if empty(cur_file) || !filereadable(cur_file)
      echomsg 'File in current buffer does not exist'
      return
    endif

    let output = fnamemodify(cur_file, ':r') . '.' . a:ft
    let job_cmd = ['pandoc']

    " Data Path should be the file directory, not working directory
    if CompareSemver(pandoc_v, '2.0.0') >= 0
      call extend(job_cmd, ['--resource-path', fnamemodify(cur_file, ':h')])
    endif

    " Required for eps-to-pdf conversion
    if CompareSemver(pandoc_v, '2.0.5') >= 0
      call extend(job_cmd, ['--pdf-engine-opt=-shell-escape'])
    endif

    if executable('pandoc-citeproc')
      call extend(job_cmd, ['--filter', 'pandoc-citeproc'])
    endif

    call extend(job_cmd, ['-so', output, cur_file])

    let job_opts = {}
    let job_opts[has('nvim') ? 'on_exit' : 'exit_cb'] = function('s:job_exit')

    let pandoc_job = dotvim8#jobstart(job_cmd, job_opts)
    if !empty(pandoc_job)
      let s:pandoc_job = pandoc_job
      let b:pandoc_job = pandoc_job
    endif
  endfunction
endif

if !exists('*s:update_commentstring')
  function s:update_commentstring()
    let syntax_name = synIDattr(synID(line('.'), col('.'), 1), 'name')
    if (syntax_name !=# 'yamlDocumentStart' && syntax_name =~? 'yaml')
      setlocal commentstring=#%s
    else
      setlocal commentstring=<!--%s-->
    endif
  endfunction
endif

command! -buffer -nargs=1 -complete=filetype Pandoc call s:make(<f-args>)
autocmd CursorMoved <buffer> call s:update_commentstring()
let &cpoptions = s:cpoptions
unlet s:cpoptions
