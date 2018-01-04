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

" Open url in default browser.
" Additional arguments are joined with '%20' as space character
" and the resulting string is appended to the url.
"
" TODO
" - validate url
" - support other OS
function! s:browse(url, ...)
  if empty(a:url)
    echomsg 'Url must be non-empty string'
    return
  endif

  let url = a:url . join(a:000, '%20')
  let cmd = ''

  if has('win32') || has('win32unix')
    if executable('rundll32.exe')
      let cmd = ['rundll32.exe', 'url.dll,FileProtocolHandler', url]
    endif
  elseif has('unix')
    if executable('xdg-open')
      let cmd = ['xdg-open', url]
    elseif executable('x-www-browser')
      let cmd = ['x-www-browser', url]
    endif
  endif

  if empty(cmd)
    echomsg 'Not supported in this environment'
    return
  endif

  call dotvim8#jobstart(cmd)
endfunction

command! -nargs=1 Browse call s:browse(<f-args>)
command! -nargs=+ BrowseMDN
\ call s:browse('https://developer.mozilla.org/en-US/search?q=', <f-args>)
command! -nargs=+ BrowsePHP
\ call s:browse('https://secure.php.net/manual-lookup.php?pattern=', <f-args>)
command! -nargs=+ BrowseDDG
\ call s:browse('https://duckduckgo.com/?q=', <f-args>)

let &cpoptions = s:cpoptions
unlet s:cpoptions
