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
if exists('g:loaded_autoload_provider')
  finish
endif
let g:loaded_autoload_provider = 1

let s:pythons = {
\ '2': ['python2', 'python'],
\ '3': ['python3', 'python']
\ }

if has('win32')
  for s:arr in values(s:pythons)
    call map(s:arr, 'v:val . ".exe"')
  endfor
endif


" If defined, look in $PYTHON2 or $PYTHON3 for python executables
" Else, find in $PATH
" Return full path of python executable if it exists
" Return empty string otherwise
function! s:get_python_path(version) abort
  if a:version == 2
    let dir = glob('$PYTHON2')
  elseif a:version == 3
    let dir = glob('$PYTHON3')
  else
    return ''
  endif

  let pythons_exe = copy(s:pythons[a:version])

  if len(dir)
    if has('win32') && !&shellslash
      let dir = escape(dir, '\')
    endif

    call map(pythons_exe, '"' . dir . '" . / . v:val')
  endif

  for python in pythons_exe
    let python_exepath = exepath(python)

    if len(python_exepath)
      return python_exepath
    endif
  endfor

  return ''
endfunction


function! s:resolve_python() abort
  if has('python')
    let python = s:get_python_path(2)

    if len(python)
      let g:python_host_prog = python
    else
      let g:loaded_python_provider = 1
    endif
  endif

  if has('python3')
    let python = s:get_python_path(3)

    if len(python)
      let g:python3_host_prog = python
    else
      let g:loaded_python3_provider = 1
    endif
  endif
endfunction


function! s:resolve_ruby() abort
  if has('win32') && !has('nvim-0.2.')
    let g:loaded_ruby_provider = 1
  endif
endfunction


function! provider#resolve() abort
  call s:resolve_python()
  call s:resolve_ruby()
endfunction
