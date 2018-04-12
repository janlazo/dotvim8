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
set cpoptions-=C cpoptions-=<
set nomodeline modelines=0
set autoread
set shortmess+=sI
set backspace=2 whichwrap=<,>,b,s nojoinspaces
set fileformats=unix,dos
set nrformats-=octal
set notimeout ttimeout ttimeoutlen=100
set noswapfile updatecount=0 directory=
set keywordprg=:help

" 4-space Indent
set shiftwidth=4 smarttab expandtab
set autoindent shiftround

" Line Wrap
set textwidth=72 formatoptions=l

" UI
set number
set sidescroll=5 nostartofline
set scrolloff=1 sidescrolloff=1 display=lastline
set laststatus=2 cmdheight=2 showmode

if 1
  let s:fix_ux = !has('win32unix') && $TERM !=# 'cygwin' && empty($TMUX)

  if v:version > 703
    set formatoptions+=j
  endif

  if v:version >= 800 || has('nvim-0.1.6')
    set shortmess+=cF belloff=all
    set nofixendofline
    set list listchars=tab:>\ ,trail:-,nbsp:+
  endif

  " Compare 2 version strings, both in semver format.
  " If a >  b, return 1.
  " If a == b, return 0.
  " If a <  b, return -1
  function! CompareSemver(a, b)
    let a = split(a:a, '\.', 0)
    let b = split(a:b, '\.', 0)

    for i in range(max([len(a), len(b)]))
      if str2nr(get(a, i, 0)) > str2nr(get(b, i, 0))
        return 1
      elseif str2nr(get(a, i, 0)) < str2nr(get(b, i, 0))
        return -1
      endif
    endfor

    return 0
  endfunction

  function! s:remove_trailing_spaces()
    let cur_view = winsaveview()
    %s/\s\+$//ge
    call winrestview(cur_view)
  endfunction

  nnoremap <silent> <Space>rs :call <SID>remove_trailing_spaces()<CR>

  " open vimrc or init.vim in new tab
  nnoremap <silent> <Space>v :tabedit $MYVIMRC<CR>
  nnoremap <silent> <Space>gv :tabedit $MYGVIMRC<CR>

  " Q defaults to Ex mode but I don't use it
  " $VIMRUNTIME/defaults.vim remaps Q to gq but I don't format comments
  " Remap it to redraw the screen
  nnoremap <silent> Q :redraw!<CR>
endif

" {{{small
if has('windows')
  set splitbelow
  set showtabline=2

  if &tabpagemax < 50
    set tabpagemax=50
  endif
endif
" }}}small
" {{{normal
if has('modify_fname')
  let s:base_dir = expand('<sfile>:p:h')

  function! s:set_shell(shell)
    if !executable(a:shell)
      echoerr '&shell is not executable'
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
        set shellcmdflag=/c shellxquote=( shellxescape&vim
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
endif

if has('linebreak')
  " 3-digit line number in 80 col terminals
  set numberwidth=4 textwidth=76

  if v:version >= 800 || has('nvim-0.1.6')
    set linebreak
  endif
endif

if has('cmdline_info')
  " display last command
  let &showcmd = s:fix_ux

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

  if v:version > 703
    execute 'nnoremap Q :nohlsearch <Bar>' maparg('Q', 'n')
  endif
endif

" Display hints, complete with selection via tab
if has('wildmenu')
  set wildmenu wildmode=longest:full,full
endif

if has('insert_expand')
  set complete-=i completeopt=menuone,preview

  if v:version >= 800
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

  function! s:toggle_spell() abort
    let &l:spell = !&l:spell
    if has('insert_expand')
      execute 'setlocal complete'.(&l:spell ? '+' : '-').'=kspell'
    endif
  endfunction

  if exists('s:base_dir')
    let s:spelldir = expand(s:base_dir . '/spell')

    " spellfile#WritableSpellDir() requires that ~/.vim/spell exists.
    if !isdirectory(s:spelldir)
      call mkdir(s:spelldir)
    endif

    if has('win32') && has('nvim') && !has('nvim-0.2.1') && !has('patch-8.0.1378')
      " Neovim uses hardcoded XDG directories on Windows but XDG is for Linux.
      " Redefine spellfile#WritableSpellDir() to point here
      " Patch 8.0.1378 prevents autoloaded function definition in $MYVIMRC
      function! spellfile#WritableSpellDir()
        return s:spelldir
      endfunction
    else
      unlet s:spelldir
    endif
  endif
endif

if has('cmdline_hist')
  if &history < 1000
    set history=1000
  endif
endif

if has('persistent_undo')
  set noundofile

  if exists('s:base_dir')
    let &undodir = expand(s:base_dir . '/.undodir')

    if !isdirectory(&undodir)
      call mkdir(&undodir, 'p')
    endif

    set undofile
  else
    set undodir=
  endif
endif

if has('vertsplit')
  set splitright
endif

if has('folding')
  set nofoldenable
endif

if has('viminfo') && exists('+viminfofile') && exists('s:base_dir')
  let &viminfofile = expand(s:base_dir . '/.viminfo')
endif

if has('user_commands')
  command! SpaceToTab setlocal noexpandtab | retab!
  command! TabToSpace setlocal expandtab | retab

  if has('modify_fname')
    command! -nargs=1 SetShell call s:set_shell(<f-args>)
  endif

  if has('syntax')
    command! SynName echo synIDattr(synID(line('.'), col('.'), 1), 'name')
    command! ToggleSpell call <SID>toggle_spell()
  endif
endif

if has('autocmd')
  " Vim
  let g:vimsyn_embed = ''
  let g:vim_indent_cont = 0

  " Tex
  let g:tex_flavor = 'latex'

  " Netrw
  let g:netrw_dirhistmax = 0

  " Shell
  let g:is_posix = 1

  " HTML
  let g:html_indent_script1 = "auto"
  let g:html_indent_style1 = "auto"
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

" Neovim GUIs set this before sourcing init.vim so unset it here
if has('termguicolors') &&
   \ (has('nvim') || !has('win32') || !has('patch-8.0.1531') || has('vcon'))
  set notermguicolors
endif
" }}}big
" {{{huge
if has('win32')
  call s:set_shell(empty($COMSPEC) ? 'cmd.exe' : $COMSPEC)

  " FIXME - findstr requires prepending /c: to the regex
  let &grepprg = executable('findstr.exe') ? 'findstr /s /r /p /n $* nul' : ''

  " cmd.exe uses %PROMPT% to set its prompt
  " default prompt is not user-friendly
  " ConEmu breaks it for winpty so :terminal has garbled prompt
  let $PROMPT = '$P$_$G$S'
endif
" }}}huge

if 1
  unlet s:fix_ux
endif
