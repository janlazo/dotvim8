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
if exists('g:loaded_autoload_dotvim8')
  finish
endif
let g:loaded_autoload_dotvim8 = 1
let s:cpoptions = &cpoptions
set cpoptions&vim

if has('win32')
  function! dotvim8#call(fn, ...)
    let shellslash = &shellslash

    try
      set noshellslash
      return call(a:fn, a:000)
    finally
      let &shellslash = shellslash
    endtry
  endfunction
else
  function! dotvim8#call(fn, ...)
    return call(a:fn, a:000)
  endfunction
endif

" cmd.exe supports double-quote escaping only with ^ as its escape character
" Wrap in ^" so cmd.exe does not dequote the token immediately
" Escape metacharacters used in interactive shell and batchfile
" Escape % to avoid environment variable expansion
" Escape all double quotes as \^"
" Escape backslashes and avoid escaping the closing ^"
function! s:shellesc_cmd(arg, script)
  let escaped = substitute(a:arg, '[&|<>()@^]', '^&', 'g')
  let escaped = substitute(escaped, '%', (a:script ? '%' : '^') . '&', 'g')
  let escaped = substitute(escaped, '"', '\\^&', 'g')
  let escaped = substitute(escaped, '\(\\\+\)\(\\^\)', '\1\1\2', 'g')
  return '^"'.substitute(escaped, '\(\\\+\)$', '\1\1', '').'^"'
endfunction

" Wrap in single quotes so environment variables are not expanded
" Double all inner single quotes
function! s:shellesc_ps1(arg)
  return "'".substitute(a:arg, "'", "''", 'g').'"'
endfunction

" Fix shellescape for Windows
" Assumes shellxquote is unset
function! dotvim8#shellescape(arg, ...)
  if empty(a:arg)
    return ''
  endif

  let shell = get(a:000, 0, &shell)
  let script = get(a:000, 1, 0)

  if shell =~# 'cmd.exe$'
    return s:shellesc_cmd(a:arg, script)
  elseif shell =~# 'powershell.exe$'
    return s:shellesc_ps1(a:arg)
  endif

  return dotvim8#call('shellescape', a:arg)
endfunction

" Vim    - !
" Neovim - terminal
function! dotvim8#bang(cmd)
  if empty(a:cmd)
    echom 'Command is empty string'
    return
  endif

  let cmd = a:cmd
  let [shell, shellcmdflag, shellxquote] = [&shell, &shellcmdflag, &shellxquote]

  try
    if has('win32')
      set shell=cmd.exe shellcmdflag=/c shellxquote=
    else
      set shell=sh shellcmdflag=-c
    endif

    if has('nvim')
      execute ':terminal' cmd
      startinsert
    else
      if !has('gui_running')
        let cmd = (has('win32') ? 'cls' : 'clear') . ' && ' . cmd
      endif

      execute ':silent !' cmd
      redraw!
    endif
  finally
    let [&shell, &shellcmdflag, &shellxquote] = [shell, shellcmdflag, shellxquote]
  endtry
endfunction

let &cpoptions = s:cpoptions
unlet s:cpoptions
