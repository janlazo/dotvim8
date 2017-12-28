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
if exists('g:loaded_after_plugin_browse')
  finish
endif
let g:loaded_after_plugin_browse = 1
let s:cpoptions = &cpoptions
set cpoptions&vim

" TODO - support other OS
function s:browse(url)
  if !(has('win32') || has('win32unix'))
    echomsg 'Not supported in this environment'
    return
  elseif empty(a:url)
    echomsg 'Url must be non-empty string'
    return
  endif

  let cmd = ['rundll32', 'url.dll,FileProtocolHandler', a:url]
  call dotvim8#jobstart(cmd)
endfunction

command! -nargs=1 Browse call s:browse(<f-args>)

let &cpoptions = s:cpoptions
unlet s:cpoptions
