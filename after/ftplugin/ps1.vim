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

if !exists('*s:help')
  function! s:help()
    let newshell = (has('win32') || has('win32unix'))
    \ ? 'powershell.exe'
    \ : 'pwsh'
    let pager = has('win32') ? 'more' : 'less'
    let shell = &shell
    if !executable(newshell) || !SetShell(newshell)
      echoerr newshell 'cannot be set'
      return
    endif

    try
      let help_fmt = 'Get-Help %s | ' . pager
      let cmd = printf(help_fmt, dotvim8#shellescape(expand('<cword>')))
      call dotvim8#bang(cmd)
    finally
      call SetShell(shell)
    endtry
  endfunction
endif

nnoremap <buffer> K :call <SID>help()<CR>
let &cpoptions = s:cpoptions
unlet s:cpoptions
