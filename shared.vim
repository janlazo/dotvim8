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
" Feature/Version checks group options, variables, functions, mappings.
" Folds group these checks by version type (ie. tiny,normal,huge).
" Vim 7.2 (tiny) and Neovim 0.1.6 are the mimimum supported versions.
" See `:h version` for feature checks.
" Check `v:version` for release + major version as an integer.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General
set cpoptions-=C cpoptions-=<
set nomodeline modelines=0
set shortmess+=s shortmess+=I

" Keys
set backspace=2 whichwrap=<,>,b,s nrformats-=octal nojoinspaces
set notimeout ttimeout ttimeoutlen=100
set keywordprg=:help
set autoindent shiftround

" File
set autoread fileformats=unix,dos suffixes=
set noswapfile updatecount=0 directory=

" Do not force a memory flush to speedup manual writes.
if exists('+swapsync')
  set swapsync=
endif
if exists('+fsync')
  set nofsync
endif

" UI
set number textwidth=72 formatoptions=ql
set sidescroll=5 nostartofline
set scrolloff=1 sidescrolloff=1 display=lastline
set laststatus=2 cmdheight=2 noshowmode

if 1
  let s:is_gui = has('nvim') ?
  \ (exists('g:nyaovim_version') ||
    \ exists('g:GtkGuiLoaded') ||
    \ exists('g:gui_oni')) :
  \ has('gui_running')

  if v:version >= 704
    set formatoptions+=j

    " 4-space Indent
    set shiftwidth=4 smarttab expandtab
  endif

  if v:version >= 800 || has('nvim-0.1.6')
    set shortmess+=c shortmess+=F
    set belloff=all
    set nofixendofline
    set list listchars=tab:>\ ,trail:-,nbsp:+
  endif

  " Compare 2 version strings, both in semver format.
  " If a >  b, return 1.
  " If a == b, return 0.
  " If a <  b, return -1.
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

  " Q defaults to Ex mode but I don't use it.
  " $VIMRUNTIME/defaults.vim remaps Q to gq but I don't format comments.
  " Remap it to redraw the screen.
  nnoremap <silent> Q :redraw!<CR>
endif

if has('win32')
  " cmd.exe uses %PROMPT% to set its prompt.
  " Default prompt is not user-friendly.
  " ConEmu's prompt is garbled in winpty.
  let $PROMPT = '$P$_$G$S'

  " Force xterm rendering on ConEmu, not :terminal, for truecolor.
  " Detect winpty by checking environment variables for Vim/Neovim server.
  if $ConEmuANSI ==# 'ON'
    if s:is_gui
      let $ConEmuANSI = 'OFF'
    elseif v:version >= 704 && !has('nvim') && has('builtin_terms') &&
      \ empty($VIM_SERVERNAME) && empty($NVIM_LISTEN_ADDRESS)
      set term=xterm t_Co=256
      let &t_AB = "\e[48;5;%dm"
      let &t_AF = "\e[38;5;%dm"
      let &t_kb = nr2char(127)
      let &t_kD = "^[[3~"
    endif
  endif
endif

" {{{tiny
" Moved from small to tiny version since 8.0.1118
if has('windows')
  set splitbelow
  set showtabline=2

  if &tabpagemax < 50
    set tabpagemax=50
  endif

  function! s:remove_trailing_spaces()
    let cur_view = winsaveview()
    %s/\s\+$//ge
    call winrestview(cur_view)
  endfunction
  nnoremap <silent> <Space>rs :call <SID>remove_trailing_spaces()<CR>
endif

" Moved from normal to tiny version since 8.0.1118
if has('vertsplit')
  set splitright
endif
" }}}tiny
" {{{small
" Moved from normal to small version since 8.0.1129
if has('cmdline_hist')
  if &history < 1000
    set history=1000
  endif
endif
" }}}small
" {{{normal
if has('multi_byte') && !has('nvim')
  if has('win32') || (has('gui_running') && &encoding ==# 'latin1')
    set encoding=utf-8
  endif
endif

if has('modify_fname')
  let s:base_dir = expand('<sfile>:p:h')

  function! s:set_shell(shell)
    if !executable(a:shell)
      echoerr a:shell 'is not executable'
      return
    endif

    let shell = fnamemodify(a:shell, ':t')

    if shell ==# 'cmd.exe'
      let &shell = a:shell
      let &shellredir = '>%s 2>&1'
      if has('quickfix')
        let &shellpipe = &shellredir
      endif
      set shellquote=

      if has('nvim')
        let &shellcmdflag = '/s /c'
        let &shellxquote= '"'
        set shellxescape=
      else
        set shellcmdflag=/c

        if v:version >= 704
          set shellxquote=(
          let &shellxescape = '"&|<>()@^'
        endif
      endif
    elseif shell =~# '^powershell' && v:version >= 704
      let &shell = a:shell
      let &shellcmdflag = '-NoProfile -NoLogo -ExecutionPolicy RemoteSigned -Command'
      set shellxescape=
      let &shellredir = '>'
      if has('quickfix')
        let &shellpipe = '|'
      endif

      if has('nvim')
        set shellxquote=
        let &shellquote = '('
      else
        let &shellxquote = has('win32') ? '"' : ''
        set shellquote=
      endif
    elseif shell =~# '^wsl' && v:version >= 800
      let &shell = a:shell
      let &shellcmdflag = 'bash --login -c'
      let &shellredir = '>%s 2>&1'
      if has('quickfix')
        let &shellpipe = '2>&1 | tee'
      endif
      let &shellxquote = '"'
      set shellxescape= shellquote=
    elseif shell =~# '^sh' || shell =~# '^bash'
      let &shell = a:shell
      set shellcmdflag=-c shellquote=
      let &shellredir = '>%s 2>&1'
      if has('quickfix')
        let &shellpipe = '2>&1 | tee'
      endif

      if v:version >= 704
        set shellxescape=
        let &shellxquote = (!has('nvim') && has('win32')) ? '"' : ''
      endif
    else
      echoerr a:shell 'is not supported in Vim' v:version
    endif
  endfunction

  if has('win32')
    call s:set_shell(has('nvim') || empty($COMSPEC) ? 'cmd.exe' : $COMSPEC)
  elseif has('win32unix')
    call s:set_shell('sh')
  endif
endif

if has('path_extra')
  set path=.,, define=
endif

if has('find_in_path')
  set include= includeexpr=
endif

if has('linebreak')
  " 3-digit line number in 80 col terminals
  set numberwidth=4 textwidth=76

  if v:version >= 800 || has('nvim-0.1.6')
    set linebreak
  endif
endif

if has('cmdline_info')
  set noshowcmd noruler
endif

if has('statusline')
  " basic statusline from github.com/itchyny/lightline.vim
  let s:modes = {
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

  " TODO - support low-width screens (add max width, minimize space)
  function! Statusline()
    let lhs = ['%8{"'.get(s:modes, mode(), 'MODE').'"}', '%t [%W%R%M]']
    let rhs = [&fileformat, '%4l:%-4c']
    if strlen(&fileencoding)
      call insert(rhs, &fileencoding)
    endif
    if strlen(&filetype)
      call insert(rhs, &filetype)
    endif
    return join(lhs, ' | ').'%='.join(rhs, ' | ')
  endfunction

  set statusline=%!Statusline()
endif

if has('extra_search') && has('reltime')
  " highlight matches, quick-jump to nearest
  set hlsearch incsearch

  if v:version >= 704
    execute 'nnoremap Q :nohlsearch <Bar>' maparg('Q', 'n')
  endif
endif

if has('wildmenu')
  " Display hints, complete with selection via tab
  set wildmenu wildmode=longest:full,full
endif

if has('insert_expand')
  set complete-=i completeopt=menuone,preview

  if v:version >= 800
    set completeopt+=noinsert,noselect
  endif
endif

if has('mksession')
  set sessionoptions=buffers,curdir,tabpages,winsize
endif

if has('mouse')
  let &mouse = s:is_gui ? 'a' : ''
endif

if has('syntax')
   " optimize for minified files
  set synmaxcol=500

  if v:version >= 703
    set colorcolumn=
  endif

  if v:version >= 800 || has('nvim-0.1.6')
    let &colorcolumn = &textwidth
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
      " Neovim uses hardcoded XDG paths on Windows but XDG is for Linux.
      " Redefine spellfile#WritableSpellDir() to point here.
      " Patch 8.0.1378 prevents autoloaded function definition.
      function! spellfile#WritableSpellDir()
        return s:spelldir
      endfunction
    else
      unlet s:spelldir
    endif
  endif

  function! s:set_color()
    let has_tgc = has('nvim') ?
    \ has('nvim-0.1.6') :
    \ (!has('win32') || !has('patch-8.0.1531') || has('vcon'))
    let use_tgc = has('nvim') ?
    \ has('nvim-0.2.1') :
    \ (has('patch-8.0.142') && has('patch-8.0.146'))
    if has('termguicolors') && has_tgc
      let &termguicolors = use_tgc && &t_Co == 256 && empty($TMUX)
    endif

    if s:is_gui
      let colors = ['gruvbox8_soft', 'morning']
    else
      let colors = ['torte']
      if &t_Co == 256
        call insert(colors, 'jellybeans')
      endif
    endif
    for color in colors
      execute 'silent! colorscheme' color
      if get(g:, 'colors_name', 'default') ==# color
        break
      endif
    endfor
  endfunction
endif

if has('persistent_undo')
  if exists('s:base_dir')
    let &undodir = expand(s:base_dir . '/.undodir')

    if !isdirectory(&undodir)
      call mkdir(&undodir, 'p')
    endif
  else
    set noundofile undodir=
  endif
endif

if has('comments')
  set comments=
endif

if has('folding')
  set nofoldenable
  set commentstring=
endif

if has('viminfo')
  set viminfo='100,<50,s10,h

  if exists('+viminfofile') && exists('s:base_dir')
    let &viminfofile = expand(s:base_dir . '/.viminfo')
  endif
elseif exists('+shada')
  set shada='100,<50,s10,h
endif

if has('quickfix')
  if has('win32')
    " FIXME - findstr requires prepending /c: to the regex
    let &grepprg = executable('findstr.exe') ? 'findstr /s /r /p /n $* nul' : ''
  endif
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

" Moved from normal to tiny version since 8.0.1564
if has('autocmd')
  " Vim
  let g:vimsyn_embed = ''
  let g:vim_indent_cont = 0

  " standard-plugin
  let g:loaded_getscriptPlugin = 1
  let g:loaded_logiPat = 1
  let g:loaded_vimballPlugin = 1
  if exists('s:base_dir')
    let g:netrw_home = s:base_dir
  endif
  let g:netrw_dirhistmax = 0
  let g:netrw_banner = 0

  " Shell
  let g:is_posix = 1

  " HTML
  let g:html_indent_script1 = "auto"
  let g:html_indent_style1 = "auto"

  " Tex
  let g:tex_flavor = 'latex'

  augroup vimrc
    autocmd!
  augroup END

  " {{{vim-plug
  let g:plug_window = 'tabnew'
  silent! call plug#begin(expand(s:base_dir . '/bundle'))
  if exists('g:loaded_plug')
    let s:plug_disable = {'on': []}
    let s:base_cond = 1
    " {{{plug-core
    let s:base_cond = v:version >= 800 && has('syntax') && has('reltime')
    call plug#('andymass/vim-matchup', s:base_cond ? {} : s:plug_disable)
    if s:base_cond
      let g:matchup_matchparen_status_offscreen = 0
      let g:matchup_matchparen_deferred = !has('nvim') || has('nvim-0.3')
      let g:matchup_matchpref_html_nolists = 1
    elseif has('syntax') && !has('nvim')
      runtime! macros/matchit.vim
    endif
    Plug 'tpope/vim-scriptease'
    Plug 'tpope/vim-unimpaired'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-endwise'
    Plug 'tpope/tpope-vim-abolish'
    Plug 'tpope/vim-repeat'
    Plug 'justinmk/vim-dirvish'
    Plug 'AndrewRadev/splitjoin.vim'
    Plug 'tommcdo/vim-lion'
    Plug 'airblade/vim-rooter'
      let g:rooter_use_lcd = 1
      let g:rooter_silent_chdir = 1
      let g:rooter_targets = '*'
      let g:rooter_change_directory_for_non_project_files = 'current'
      let g:rooter_patterns = []
      " C/C++
      call extend(g:rooter_patterns, ['CMakeLists.txt', 'Makefile'])
      " Javascript
      call extend(g:rooter_patterns, ['package.json'])
      " PHP
      call extend(g:rooter_patterns, ['composer.json'])
      " Java
      call extend(g:rooter_patterns, ['pom.xml'])
      " Version Control
      call extend(g:rooter_patterns, ['.git/', '.hg/', '.svn/'])

    let s:fzf_path = expand('~/.fzf')
    if isdirectory(s:fzf_path)
      call plug#(s:fzf_path)
    else
      call plug#('junegunn/fzf', executable('bash') ? {
      \ 'dir': s:fzf_path,
      \ 'do': 'bash ./install --bin'
      \ } : s:plug_disable)
    endif
    unlet s:fzf_path
    Plug 'janlazo/fzf.vim'
      let g:fzf_command_prefix = 'Fzf'
    Plug 'tpope/vim-fugitive'

    call plug#('Shougo/echodoc.vim', has('patch-7.4.774') ? {
    \ 'do': ':call echodoc#enable()'
    \ } : s:plug_disable)
    let s:base_cond = has('timers')
    call plug#('prabirshrestha/asyncomplete.vim', s:base_cond ? {} : s:plug_disable)
    if s:base_cond
      inoremap <silent> <expr> <TAB>   pumvisible() ? "\<C-n>" : "\<TAB>"
      inoremap <silent> <expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"
      inoremap <silent> <expr> <CR>    <C-R>=(pumvisible() ? "\<C-y>" : '')<CR><CR>
    endif
    Plug 'Shougo/neco-vim'
    call plug#('prabirshrestha/asyncomplete-necovim.vim', s:base_cond ? {} : s:plug_disable)
    if s:base_cond
      autocmd vimrc User asyncomplete_setup
      \ call asyncomplete#register_source(asyncomplete#sources#necovim#get_source_options({
      \ 'name': 'necovim',
      \ 'whitelist': ['vim'],
      \ 'completor': function('asyncomplete#sources#necovim#completor')
      \ }))
    endif

    Plug 'nanotech/jellybeans.vim'
      " Windows' default terminal doesn't use ANSI in 8-16 color terminals
      let g:jellybeans_use_lowcolor_black = 0
      let g:jellybeans_use_term_italics = 0
      let g:jellybeans_use_gui_italics = 0
    call plug#('lifepillar/vim-gruvbox8', v:version >= 800 ? {} : s:plug_disable)
    " }}}plug-core
    " {{{plug-python
    let s:base_cond = has('python') || has('python3')
    call plug#('editorconfig/editorconfig-vim', s:base_cond ? {} : s:plug_disable)
    if s:base_cond
      let g:EditorConfig_preserve_formatoptions = 1
      let g:EditorConfig_max_line_indicator = 'none'
      let g:EditorConfig_exclude_patterns = ['scp://.*', 'fugitive://.*']
    endif
    " }}}plug-python
    " {{{plug-ft
    " Vim
    Plug 'junegunn/vader.vim'

    " Shell
    Plug 'ericpruitt/tmux.vim', {'rtp': 'vim'}
    Plug 'PProvost/vim-ps1'

    " Document
    Plug 'tpope/vim-markdown'
    Plug 'lervag/vimtex'
    Plug 'vim-pandoc/vim-pandoc-syntax'
    Plug 'aklt/plantuml-syntax'

    " Web
    Plug 'othree/html5.vim'
    Plug 'ap/vim-css-color'
    Plug 'JulesWang/css.vim'
    Plug 'othree/csscomplete.vim'
    Plug 'othree/yajs.vim'
    Plug 'othree/es.next.syntax.vim'
    Plug 'kchmck/vim-coffee-script'
    Plug 'leafgarland/typescript-vim'
    Plug 'mxw/vim-jsx'
      let g:jsx_ext_required = 1

    " Database
    Plug 'exu/pgsql.vim'
      let g:sql_type_default = 'pgsql'

    " Data
    Plug 'cespare/vim-toml'

    " System
    Plug 'OrangeT/vim-csharp'
    Plug 'rust-lang/rust.vim'
    Plug 'tbastos/vim-lua'
    " }}}plug-ft
    call plug#('daa84/neovim-gtk', exists('g:GtkGuiLoaded') ? {
    \ 'rtp': 'runtime'
    \ } : s:plug_disable)
    unlet s:plug_disable s:base_cond
    silent! call plug#end()

    silent! call echodoc#enable()
  endif
  " }}}vim-plug

  if has('nvim')
    function! s:vim_enter()
      let s:is_gui = s:is_gui || (exists('g:GuiLoaded') && has('nvim-0.3'))
      if s:is_gui
        set mouse=a
        if $ConEmuANSI ==# 'ON'
          let $ConEmuANSI = 'OFF'
        endif
      endif

      call s:set_color()
    endfunction
    autocmd vimrc VimEnter * call s:vim_enter()
  else
    if has('gui_running')
      set background=light
      behave xterm
      let &columns = 81 + &numberwidth
    endif
    if has('syntax')
      call s:set_color()
    endif
  endif
endif

if 1
  if exists('s:base_dir')
    unlet s:base_dir
  endif
endif
