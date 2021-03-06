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
let s:has_term = has('nvim') || (has('terminal') && has('patch-8.0.1108'))
let s:has_job = has('nvim') || (has('job') && has('channel')
                                \ && has('patch-8.0.87'))

function! s:escape_ex(cmd)
  return escape(a:cmd, '%#!')
endfunction

" cmd.exe supports double-quote escaping only with ^ as its escape character
" Escape metacharacters used in interactive shell and batchfile
" Escape % and ! to avoid environment variable expansion
" Return an escaped string, wrapped in ^", so cmd.exe doesn't dequote it yet.
function! s:shellesc_cmd(arg, script)
  let escaped = substitute('"'.a:arg.'"', '[&|<>()@^!"]', '^&', 'g')
  return substitute(escaped, '%', (a:script ? '%' : '^') . '&', 'g')
endfunction

" Wrap in single quotes so environment variables are not expanded
" Double all inner single quotes
function! s:shellesc_ps1(arg)
  return "'".substitute(escape(a:arg, '\"'), "'", "''", 'g')."'"
endfunction

function! s:shellesc_sh(arg)
  return "'".substitute(a:arg, "'", "'\\\\''", 'g')."'"
endfunction

" Fix shellescape for external programs in Windows
function! dotvim8#shellescape(arg, ...)
  if empty(a:arg)
    return ''
  endif

  let opts = get(a:000, 0, {})
  let shell = fnamemodify(UnescapeShell(get(opts, 'shell', &shell)), ':t')
  let script = get(opts, 'script', 0)

  if shell =~# 'cmd\.exe'
    return s:shellesc_cmd(a:arg, script)
  elseif shell =~# 'powershell\.exe' || shell =~# 'pwsh'
    return s:shellesc_ps1(a:arg)
  endif

  return s:shellesc_sh(a:arg)
endfunction

" Vim without +terminal        - !
" Vim with +terminal or Neovim - terminal
function! dotvim8#bang(cmd)
  if empty(a:cmd)
    echomsg 'Command is empty string'
    return
  endif
  let shell = UnescapeShell(&shell)

  if s:has_term
    if has('nvim')
      enew
      call termopen(a:cmd)
      startinsert
    else
      if shell =~# 'cmd\.exe'
        let cmd = ['cmd', '/s', '/c', '"' . a:cmd . '"']
      else
        let cmd = [shell, &shellcmdflag, a:cmd]
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
  else
    if has('gui_running')
      let cmd = (has('unix') && executable('x-terminal-emulator')) ?
                \ 'x-terminal-emulator -e ' . dotvim8#shellescape(a:cmd) : a:cmd
    else
      let cls = shell =~# 'cmd\.exe'
                \ || shell =~# 'powershell\.exe'
                \ || shell =~# 'pwsh'
                \ ? 'cls' : 'clear'
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
