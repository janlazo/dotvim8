" source this after tiny.vim
" options are grouped by feature (check :h feature-list)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if has('smartindent')
  set nosmartindent
endif

if has('cindent')
  set nocindent
endif

if has('linebreak')
  set numberwidth=4   " left-pad 3-digit line number
endif

" relativenumber is slow and can break buffer redrawing
if !has('win32unix') && $TERM !=# 'cygwin' && len($TMUX) == 0
  set relativenumber
endif

if has('cmdline_info')
  set showcmd         " display last command
endif

" highlight matches, quick-jump to nearest
if has('extra_search')
  set hlsearch incsearch
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

if has('syntax')
  set nocursorline synmaxcol=500     " optimize for minified files

  if exists('+colorcolumn')
    set textwidth=76
    let &colorcolumn = &textwidth
  endif
endif
