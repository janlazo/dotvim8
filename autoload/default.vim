if exists('g:loaded_autoload_default')
  finish
endif
let g:loaded_autoload_default = 1


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

  if has('statusline')
    set statusline=%t                               " tail of filename
    set statusline+=\ [%{strlen(&ft)?&ft:'none'}    " file type
    set statusline+=,%{strlen(&fenc)?&fenc:'none'}  " file encoding
    set statusline+=,%{&ff}]                        " file format
    set statusline+=[%R%M]                          " file status flags
    set statusline+=%=                              " right align
    set statusline+=[B:%n\|L:%l/%L\|C:%c]           " [buffer|line|column]
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
