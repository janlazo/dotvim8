if exists('g:loaded_autoload_default')
  finish
endif
let g:loaded_autoload_default = 1

" Copied from github.com/itchyny/lightline.vim
let default#mode_map = {
  \ 'n': 'NORMAL',
  \ 'i': 'INSERT',
  \ 'R': 'REPLACE',
  \ 'v': 'VISUAL',
  \ 'V': 'V-LINE',
  \ "\<C-v>": 'V-BLOCK',
  \ 'c': 'COMMAND',
  \ 's': 'SELECT',
  \ 'S': 'S-LINE',
  \ "\<C-s>": 'S-BLOCK',
  \ 't': 'TERMINAL'
  \ }


function! default#format_opts() abort
  set formatoptions=crl

  if v:version > 703
    set formatoptions+=j
  endif
endfunction


" Call this function after sourcing tiny.vim and huge.vim
function! default#init() abort
  " emulate basic statusline from lightline.vim
  if has('statusline')
    set noshowmode
    let statusline =  ' %{default#mode_map[mode()]}'      " current mode
    let statusline .= ' | %t'                             " tail of filename
    let statusline .= ' [%R%M]'                           " file status flags
    let statusline .= '%='                                " right align
    let statusline .= '%{strlen(&ft)?&ft:"none"}'         " file type
    let statusline .= ' | %{strlen(&fenc)?&fenc:"none"}'  " file encoding
    let statusline .= ' | %{&ff}'                         " file format
    let statusline .= ' |%4l:%-4c'                        " line, column
    let &statusline = statusline
  endif

  " Filetype
  let g:tex_flavor = 'latex'

  " Reset settings mangled by ftplugin, syntax files
  if has('autocmd')
    augroup default_config
      autocmd!
      autocmd BufWinEnter,BufNewFile * call default#format_opts()
    augroup END
  endif

  " External
  runtime! macros/matchit.vim   " '%' jumps to begin/end pairs
endfunction
