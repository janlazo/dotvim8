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
let s:has_term = has('nvim') ?
                \ (has('nvim-0.2.1') || !has('win32')) :
                \ (has('terminal') && has('patch-8.0.1108'))
let s:has_job = has('nvim') ?
                \ (has('nvim-0.2') || !has('win32')) :
                \ (has('job') && has('channel') && has('patch-8.0.87'))

function! s:escape_ex(cmd)
  return escape(a:cmd, '%#!')
endfunction

" cmd.exe supports double-quote escaping only with ^ as its escape character
" Escape metacharacters used in interactive shell and batchfile
" Escape % and ! to avoid environment variable expansion
" Return an escaped string, wrapped in ^", so cmd.exe doesn't dequote it yet.
function! s:shellesc_cmd(arg, script)
  let escaped = substitute(escaped, '%', (a:script ? '%' : '^') . '&', 'g')
  return substitute('"'.escaped.'"', '[&|<>()@^!"]', '^&', 'g')
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
    echomsg '''shell'' is not executable'
    return
  endif

  let shell = fnamemodify(a:shell, ':t')

  if shell ==# 'cmd.exe'
    let &shell = a:shell
    let &shellredir = '>%s 2>&1'
    set shellquote=

    if has('nvim')
      let &shellcmdflag = '/s /c'
      let &shellxquote= '"'
      set shellxescape=
    else
      set shellcmdflag=/c shellxquote&vim shellxescape&vim
    endif
  elseif shell =~# '^powershell'
    let &shell = a:shell
    let &shellcmdflag = '-NoProfile -NoLogo -ExecutionPolicy RemoteSigned -Command'
    set shellxescape=
    let &shellpipe = '|'
    let &shellredir = '>'

    if has('nvim')
      set shellxquote=
      let &shellquote = '('
    else
      let &shellxquote = has('win32') ? '"' : ''
      set shellquote=
    endif
  elseif shell =~# '^wsl'
    let &shell = a:shell
    let &shellcmdflag = 'bash --login -c'
    let &shellredir = '>%s 2>&1'
    set shellxquote=\" shellxescape= shellquote=
  elseif shell =~# '^sh' || shell =~# '^bash'
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

  let opts = get(a:000, 0, {})
  let shell = fnamemodify(get(opts, 'shell', &shell), ':t')
  let script = get(opts, 'script', 0)
  let arg = get(opts, 'escape_argv', 1) && (has('win32') || has('win32unix')) ?
            \ escape(a:arg, '"\') : a:arg

  if shell ==# 'cmd.exe'
    return s:shellesc_cmd(arg, script)
  elseif shell =~# '^powershell'
    return s:shellesc_ps1(arg)
  elseif has('win32') || has('win32unix')
    let shellslash = &shellslash
    try
      set shellslash
      return shellescape(arg)
    finally
      let &shellslash = shellslash
    endtry
  endif

  return shellescape(a:arg)
endfunction

" Vim without +terminal        - !
" Vim with +terminal or Neovim - terminal
function! dotvim8#bang(cmd)
  if empty(a:cmd)
    echomsg 'Command is empty string'
    return
  elseif !executable(&shell)
    echomsg '''shell'' is not executable'
    return
  endif

  if s:has_term
    if has('nvim')
      enew
      call termopen(a:cmd)
      startinsert
    else
      if &shell =~# 'cmd.exe$'
        let cmd = ['cmd', '/s', '/c', '"' . a:cmd . '"']
      else
        let cmd = [&shell, &shellcmdflag, a:cmd]
      endif

      " Vim escapes the double quotes with backslashes
      " This can break either the executable, internal command, or the entire command
      " This escaping is unreliable in cmd.exe and invalid in powershell.exe
      " Also, Vim does not officially support powershell.exe
      if has('win32')
        let cmd = join(cmd)
      endif

      call term_start(cmd)
    endif
  elseif has('nvim') && s:has_job && &shell =~# 'cmd.exe$'
    call jobstart('start /wait cmd /s /c "' . a:cmd . '"')
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

" On Vim, use job_start() and return a job object.
" On Neovim, use jobstart() and return a job id.
" If jobs feature is unsupported (Vim 7, Windows 7+),
" then fallback to system() and return an empty string.
" On failure, return -1.
function! dotvim8#jobstart(cmd, ...)
  if empty(a:cmd)
    echomsg 'Command required'
    return -1
  endif

  let cmd_type = type(a:cmd)

  if cmd_type != type('') && cmd_type != type([])
    echomsg 'Invalid command type'
    return -1
  endif

  let opts = get(a:000, 0, {})

  if !s:has_job
    " TODO - Escape each list entry for &shell
    let cmd = (cmd_type == type([])) ? join(a:cmd) : a:cmd
    call system(cmd)
    return ''
  endif

  if has('nvim')
    let job_id = jobstart(a:cmd, opts)
    return job_id
  else
    let job_obj = job_start(a:cmd, opts)
    return job_obj
  endif
endfunction

let &cpoptions = s:cpoptions
unlet s:cpoptions
