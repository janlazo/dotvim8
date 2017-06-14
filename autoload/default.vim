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

function! s:ui() abort
  " Center
  if has('syntax')
    set nocursorline      " don't block-highlight current row
  endif

  " Left
  if has('linebreak')
    set numberwidth=4     " show all line nums (max = 999)
  endif

  if has('win32unix')
    set norelativenumber
  else
    set relativenumber
  endif

  " Bottom
  if has('cmdline_info')
    set showcmd           " display last command
  endif

  " emulate basic statusline of lightline.vim
  if has('statusline')
    let statusline =  '%{default#mode_map[mode()]}'       " current mode
    let statusline .= ' | %t'                             " tail of filename
    let statusline .= ' [%R%M]'                           " file status flags
    let statusline .= '%='                                " right align
    let statusline .= '%{strlen(&ft)?&ft:"none"}'         " file type
    let statusline .= ' | %{strlen(&fenc)?&fenc:"none"}'  " file encoding
    let statusline .= ' | %{&ff}'                         " file format
    let statusline .= ' | %7(%l:%c%)'                     " line, column
    let &statusline = ' ' . statusline . ' '
  endif
endfunction


function! default#format_opts() abort
  set formatoptions=crl

  if v:version > 703
    set formatoptions+=j
  endif
endfunction


" Call this function after sourcing tiny.vim
function! default#init() abort
  " Line Wrap
  set textwidth=76

  if has('syntax') && exists('+colorcolumn')
    let &colorcolumn = &textwidth
  endif

  " Fixes
  if has('smartindent')
    set nosmartindent
  endif

  if has('cindent')
    set nocindent
  endif

  if has('syntax')
    set synmaxcol=500           " optimize for minified files
  endif

  " Enhancments
  call s:ui()

  if has('extra_search')
    set hlsearch incsearch    " highlight matches, quick-jump to nearest
  endif

  " Display hints, complete with selection via tab
  if has('wildmenu')
    set wildmenu wildmode=longest:full,full
  endif

  if has('win32')
    set shellslash    " '/' is closer to home row than '\\'
  endif

  if has('multi_byte')
    if &encoding ==# 'latin1' && has('gui_running')
      set encoding=utf-8
    endif
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
