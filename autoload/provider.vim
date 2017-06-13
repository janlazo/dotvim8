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
    let dir = glob('$PYTHON2/')
  elseif a:version == 3
    let dir = glob('$PYTHON3/')
  else
    return ''
  endif

  let pythons_exe = copy(s:pythons[a:version])

  if len(dir)
    if has('win32') && !&shellslash
      let dir = escape(dir, '\')
    endif

    call map(pythons_exe, '"' . dir . '" . v:val')
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
