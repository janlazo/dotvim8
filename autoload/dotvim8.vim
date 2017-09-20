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
let s:use_term = has('nvim') ?
                \ (has('nvim-0.2.1') || !has('win32')) :
                \ (has('terminal') && has('patch-8.0.1123'))

if has('win32')
  function! s:call(fn, ...)
    let shellslash = &shellslash

    try
      set noshellslash
      return call(a:fn, a:000)
    finally
      let &shellslash = shellslash
    endtry
  endfunction
else
  function! s:call(fn, ...)
    return call(a:fn, a:000)
  endfunction
endif

function! s:escape_ex(cmd)
  return escape(a:cmd, '%#!')
endfunction

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
  return "'".substitute(a:arg, "'", "''", 'g')."'"
endfunction

" Pass an executable shell to set all shell options for the following:
" system(), :!, job, terminal
function! dotvim8#set_shell(shell)
  if !executable(a:shell)
    echom '''shell'' is not executable'
    return
  endif

  let shell = fnamemodify(a:shell, ':t')

  if shell ==# 'cmd.exe'
    let &shell = a:shell
    set shellcmdflag=/c shellquote=
    let &shellredir = '>%s 2>&1'

    if has('nvim')
      set shellxquote= shellxescape=
    else
      set shellxquote=(
      let &shellxescape = '"&|<>()@^'
    endif
  elseif shell ==# 'powershell.exe'
    let &shell = a:shell
    let &shellcmdflag = '-NoProfile -NoLogo -Command'
    set shellxescape= shellquote=
    let &shellredir = '>%s 2>&1'

    if !has('nvim') && has('win32')
      let &shellxquote = '"'
    else
      set shellxquote=
    endif
  elseif shell ==# 'sh' || shell ==# 'bash'
    let &shell = a:shell
    set shellcmdflag=-c shellxescape= shellquote=
    let &shellredir = '>%s 2>&1'

    if !has('nvim') && has('win32')
      let &shellxquote = '"'
    else
      set shellxquote=
    endif
  endif
endfunction

" Fix shellescape for external programs in Windows
" Try regular shellescape with noshellslash for internal commands in cmd.exe
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

  return s:call('shellescape', a:arg)
endfunction

" Vim without +terminal        - !
" Vim with +terminal or Neovim - terminal
function! dotvim8#bang(cmd)
  if empty(a:cmd)
    echom 'Command is empty string'
    return
  elseif !executable(&shell)
    echom '''shell'' is not executable'
    return
  endif

  if s:use_term
    if has('nvim')
      execute ':terminal' s:escape_ex(a:cmd)
      startinsert
    else
      call term_start(join([&shell, &shellcmdflag, a:cmd]))
    endif
  elseif has('nvim') && &shell =~# 'cmd.exe$'
    call jobstart('start /wait cmd /c ' . a:cmd)
  else
    if has('gui_running')
      let cmd = a:cmd
    else
      let cls = &shell =~# 'cmd.exe$' || &shell =~# 'powershell.exe$' ?
                \ 'cls' : 'clear'
      let cmd = cls . ' && ' . a:cmd
    endif

    execute ':silent !' s:escape_ex(cmd)
    redraw!
  endif
endfunction

let &cpoptions = s:cpoptions
unlet s:cpoptions
