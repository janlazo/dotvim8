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
" options are grouped by feature (:h feature-list)
" foldmarkers group options by version (:h version)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Fixes
set cpoptions-=C
set nomodeline modelines=0
set autoread
set shortmess+=sI
set backspace=2 whichwrap=<,>,b,s nojoinspaces
set gdefault
set fileformats=unix,dos
set nrformats-=octal complete-=i
set notimeout ttimeout ttimeoutlen=100
set noswapfile updatecount=0

" 4-space Indent
set shiftwidth=4 smarttab expandtab
set autoindent shiftround

" Line Wrap
set textwidth=72 formatoptions=rl

" UI
set number
set sidescroll=5 nostartofline
set scrolloff=1 sidescrolloff=1 display=lastline
set laststatus=2 cmdheight=2 showmode

if 1
  let s:base_dir = expand('<sfile>:p:h')
  let s:fix_ux = !has('win32unix') && $TERM !=# 'cygwin' && empty($TMUX)

  if v:version > 703
    set formatoptions+=j
  endif

  if v:version >= 800 || has('nvim-0.1.6')
    set shortmess+=cF belloff=all
    set nofixendofline

    if s:fix_ux
      set relativenumber
    endif
  endif

  function! SpaceToTab() abort
    setlocal noexpandtab
    retab!
  endfunction

  function! TabToSpace() abort
    setlocal expandtab
    retab
  endfunction

  nnoremap <silent> <Space>it :call SpaceToTab()<CR>
  nnoremap <silent> <Space>is :call TabToSpace()<CR>

  nnoremap <Plug>(RemoveTrailingSpace) :%s/\s\+%//g<CR>
  nmap <Space>rs <Plug>(RemoveTrailingSpace)

  " open vimrc or init.vim in new tab
  nnoremap <silent> <Space>v :tabedit $MYVIMRC<CR>
  nnoremap <silent> <Space>gv :tabedit $MYGVIMRC<CR>
endif

" {{{small
if has('windows')
  set splitbelow

  if &tabpagemax < 50
    set tabpagemax=50
  endif
endif
" }}}small
" {{{normal
if has('linebreak')
  " 3-digit line number in 80 col terminals
  set numberwidth=4 textwidth=76

  if v:version >= 800 || has('nvim-0.1.6')
    set linebreak
  endif
endif

if has('cmdline_info')
  " display last command
  set showcmd
  " obseleted by statusline
  set noruler
endif

if has('statusline')
  set noshowmode rulerformat=

  " {{{lightline
  " basic statusline from github.com/itchyny/lightline.vim
  let g:statusline_modes = {
  \ 'n': 'NORMAL',
  \ 'i': 'INSERT',
  \ 'R': 'REPLACE',
  \ 'v': 'VISUAL',
  \ 'V': 'V-LINE',
  \ "\<C-v>": 'V-BLOCK',
  \ 's': 'SELECT',
  \ 'S': 'S-LINE',
  \ "\<C-s>": 'S-BLOCK',
  \ 'c': 'COMMAND',
  \ 't': 'TERMINAL',
  \ 'r': 'PROMPT'
  \ }

  let s:statusline =  ' %{get(g:statusline_modes, mode(), "")}'
  let s:statusline .= ' | %t'                             " tail of filename
  let s:statusline .= ' [%R%M]'                           " file status flags
  let s:statusline .= '%='                                " right align
  let s:statusline .= '%{strlen(&ft)?&ft:"none"}'         " file type
  let s:statusline .= ' | %{strlen(&fenc)?&fenc:"none"}'  " file encoding
  let s:statusline .= ' | %{&ff}'                         " file format
  let s:statusline .= ' |%4l:%-4c'                        " line, column
  let &statusline = s:statusline
  unlet s:statusline
  " }}}lightline
endif

" highlight matches, quick-jump to nearest
if has('extra_search') && has('reltime')
  set hlsearch incsearch
endif

" Display hints, complete with selection via tab
if has('wildmenu')
  set wildmenu wildmode=longest:full,full
endif

if has('insert_expand')
  set completeopt=menuone,preview

  if v:version > 703 && has('patch-7.4.775')
    set completeopt+=noinsert,noselect
  endif
endif

if has('mksession')
  set sessionoptions-=options
endif

if has('mouse') && !has('gui_running')
  set mouse=
endif

if has('syntax')
   " optimize for minified files
  set synmaxcol=500

  if v:version > 702
    set colorcolumn=
  endif

  if v:version >= 800 || has('nvim-0.1.6')
    if s:fix_ux
      let &colorcolumn = &textwidth
    endif
  endif

  function! ToggleSpell() abort
    if !has('syntax') || has('nvim')
      return
    endif

    if &spell
      setlocal nospell complete-=kspell
    else
      setlocal spell complete+=kspell
    endif
  endfunction

  " Nobody uses 'Ex' mode
  " It is remapped to 'gq' in $VIMRUNTIME/defaults.vim in Vim 8+
  " Spell check gives false positives so it must be unset by default
  " Remap 'Ex' mode to toggle spell check
  nnoremap <silent> Q :call ToggleSpell()<CR>
endif

if has('multi_byte')
  if &encoding ==# 'latin1' && has('gui_running')
    set encoding=utf-8
  endif
endif

if has('cmdline_hist')
  if &history < 1000
    set history=1000
  endif
endif

if has('persistent_undo')
  set undofile
  let s:undodir = expand(s:base_dir . '/.undodir')

  if !isdirectory(s:undodir)
    call mkdir(s:undodir, 'p')
  endif

  let &undodir = s:undodir
  unlet s:undodir
endif

if has('vertsplit')
  set splitright
endif
" }}}normal
" {{{big
if has('langmap')
  if exists('+langnoremap')
    set langnoremap
  elseif exists('+langremap')
    set nolangremap
  endif
endif
" }}}big
" {{{huge
if has('win32')
  " '/' is closer to home row than '\\'
  set shellslash

  if $ConEmuANSI ==# 'ON' && !has('gui_running') && !has('nvim')
    if has('builtin_terms') && $ConEmuTask !~# 'Shells::cmd'
      set term=xterm
      set t_Co=256
      let &t_AB = "\e[48;5;%dm"
      let &t_AF = "\e[38;5;%dm"
    endif

    inoremap <Char-0x07F> <BS>
    nnoremap <Char-0x07F> <BS>
    vnoremap <Char-0x07F> <BS>
  endif
endif

" Escape Insert/Visual Mode via Alt/Meta + [hjkl]
if has('nvim') || has('win32') || has('gui_running')
  inoremap <silent> <M-h> <Esc>hl
  vnoremap <silent> <M-h> <Esc>hl

  inoremap <silent> <M-j> <Esc>jl
  vnoremap <silent> <M-j> <Esc>jl

  inoremap <silent> <M-k> <Esc>kl
  vnoremap <silent> <M-k> <Esc>kl

  inoremap <silent> <M-l> <Esc>ll
  vnoremap <silent> <M-l> <Esc>ll
endif
" }}}huge

if 1
  unlet s:fix_ux s:base_dir
endif