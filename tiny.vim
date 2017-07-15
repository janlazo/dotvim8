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
" Tiny
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 4-space Indent
set shiftwidth=4 tabstop=4 softtabstop=0 expandtab nosmarttab
set autoindent shiftround

" Line Wrap
set wrap textwidth=72 formatoptions=rl

" Splits
set splitbelow splitright

" UI
"" Center
set nostartofline noshowmatch       " don't randomly move the cursor
set scrolloff=1 sidescroll=5        " always show 1 line, 5 cols
set display=lastline                " don't mangle last line of buffer

"" Left
set number norelativenumber

"" Bottom
set laststatus=2 cmdheight=2 showmode

" Fixes
set autoread
set novisualbell noerrorbells
set nolazyredraw                    " lazyredraw is still broken
set backspace=2 whichwrap=<,>,b,s
set fileformats=unix,dos,mac
set nrformats-=octal complete-=i
set notimeout ttimeout ttimeoutlen=100
set noswapfile updatecount=0 nobackup patchmode=

if exists('+swapsync')
  set swapsync=
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Huge
" options below are grouped by feature (check :h feature-list)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('smartindent')
  set nosmartindent
endif

if has('cindent')
  set nocindent
endif

if has('linebreak')
  set numberwidth=4 textwidth=76  " 3-digit line number in 80 col terminals
  set nolinebreak                 " hard wrap on inserted lines

  if exists('+breakindent')
    set nobreakindent
  endif
endif

if has('cmdline_info')
  set showcmd         " display last command
  set noruler         " obseleted by statusline
endif

" highlight matches, quick-jump to nearest
if has('extra_search')
  set hlsearch incsearch
endif

" Display hints, complete with selection via tab
if has('wildmenu')
  set wildmenu wildmode=longest:full,full
endif

if has('mksession')
  set sessionoptions-=options
endif

if has('langmap')
  if exists('+langnoremap')
    set langnoremap
  elseif exists('+langremap')
    set nolangremap
  endif
endif

if has('mouse') && !has('gui_running')
  set mouse=
endif

if has('termguicolors')
  set notermguicolors
endif

if has('eval')
  let s:cpoptions = &cpoptions
  set cpoptions&vim
  let s:fix_ux = !has('win32unix') && $TERM !=# 'cygwin' && empty($TMUX)

  if s:fix_ux
    set relativenumber
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

  " emulate basic statusline from github.com/itchyny/lightline.vim
  if has('statusline')
    set noshowmode

    let g:statusline_mode_map = {}
    let g:statusline_mode_map.n = 'NORMAL'
    let g:statusline_mode_map.i = 'INSERT'
    let g:statusline_mode_map.R = 'REPLACE'
    let g:statusline_mode_map.v = 'VISUAL'
    let g:statusline_mode_map.V = 'V-LINE'
    let g:statusline_mode_map["\<C-v>"] = 'V-BLOCK'
    let g:statusline_mode_map.s = 'SELECT'
    let g:statusline_mode_map.S = 'S-LINE'
    let g:statusline_mode_map["\<C-s>"] = 'S-BLOCK'
    let g:statusline_mode_map.c = 'COMMAND'
    let g:statusline_mode_map.t = 'TERMINAL'

    let s:statusline =  ' %{get(g:statusline_mode_map, mode(), "")}'
    let s:statusline .= ' | %t'                             " tail of filename
    let s:statusline .= ' [%R%M]'                           " file status flags
    let s:statusline .= '%='                                " right align
    let s:statusline .= '%{strlen(&ft)?&ft:"none"}'         " file type
    let s:statusline .= ' | %{strlen(&fenc)?&fenc:"none"}'  " file encoding
    let s:statusline .= ' | %{&ff}'                         " file format
    let s:statusline .= ' |%4l:%-4c'                        " line, column
    let &statusline = s:statusline
    unlet s:statusline
  endif

  if has('syntax')
    set nocursorline synmaxcol=500      " optimize for minified files

    if exists('+colorcolumn')
      let &colorcolumn = &textwidth
    endif
  endif

  if has('windows')
    if &tabpagemax < 50
      set tabpagemax=50
    endif
  endif

  if has('win32')
    set shellslash    " '/' is closer to home row than '\\'

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

  if v:version > 703
    set formatoptions+=j
  endif

  if v:version >= 800 || has('nvim-0.1.6')
    set belloff=all
    set nofixendofline

    if has('linebreak')
      set linebreak
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

  let &cpoptions = s:cpoptions
  unlet s:cpoptions s:fix_ux
endif
