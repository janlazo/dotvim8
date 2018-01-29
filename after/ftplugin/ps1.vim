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
    if !executable('powershell')
      echomsg 'powershell is unavailable in PATH'
      return
    elseif !executable(&shell)
      echomsg '''shell'' is not executable'
      return
    endif

    let shell = &shell

    try
      call dotvim8#set_shell('powershell')
      let help_fmt = 'Get-Help %s | more'
      let cmd = printf(help_fmt, dotvim8#shellescape(expand('<cword>')))
      call dotvim8#bang(cmd)
    finally
      call dotvim8#set_shell(shell)
    endtry
  endfunction
endif

nnoremap <buffer> K :call <SID>help()<CR>
let &cpoptions = s:cpoptions
unlet s:cpoptions
