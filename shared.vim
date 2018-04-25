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

" Speedup writes and avoid swap errors by not forcing a flush on every :write
" Check if the option works because Vim/Neovim may disable/ignore it.
if exists('+fsync')
  set nofsync
endif
if exists('+swapsync')
  set swapsync=
endif

" Consistent Indentation
set autoindent shiftround

" Line Wrap
set textwidth=72 formatoptions=l

" UI
set number
set sidescroll=5 nostartofline
set scrolloff=1 sidescrolloff=1 display=lastline
set laststatus=2 cmdheight=2 noshowmode

if 1
  let s:fix_ux = !has('win32unix') && $TERM !=# 'cygwin' && empty($TMUX)
  let s:is_gui = has('gui_running') || exists('g:nyaovim_version')

  if v:version >= 704
    set formatoptions+=j

    " 4-space Indent
    set shiftwidth=4 smarttab expandtab
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

  " Q defaults to Ex mode but I don't use it
  " $VIMRUNTIME/defaults.vim remaps Q to gq but I don't format comments
  " Remap it to redraw the screen
  nnoremap <silent> Q :redraw!<CR>
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

  " open vimrc, gvimrc, or init.vim in new tab
  nnoremap <silent> <Space>v :tabedit $MYVIMRC<CR>
  nnoremap <silent> <Space>gv :tabedit $MYGVIMRC<CR>
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
if has('modify_fname')
  let s:base_dir = expand('<sfile>:p:h')

  " TODO - set shellpipe (depends on +quickfix)
  function! s:set_shell(shell)
    if !executable(a:shell)
      echoerr a:shell 'is not executable'
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
      let &shellxquote = '"'
      set shellxescape= shellquote=
    elseif shell =~# '^sh' || shell =~# '^bash'
      let &shell = a:shell
      set shellcmdflag=-c shellquote=
      let &shellredir = '>%s 2>&1'

      if v:version >= 704
        set shellxescape=
        let &shellxquote = (!has('nvim') && has('win32')) ? '"' : ''
      endif
    else
      echoerr a:shell 'is not supported in Vim' v:version
    endif
  endfunction

  if has('win32')
    call s:set_shell(empty($COMSPEC) ? 'cmd.exe' : $COMSPEC)
  elseif has('win32unix')
    call s:set_shell('sh')
  endif
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
    let rhs = [&fileformat, '%3l:%-3c']
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

" highlight matches, quick-jump to nearest
if has('extra_search') && has('reltime')
  set hlsearch incsearch

  if v:version >= 704
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
  set sessionoptions=blank,buffers,curdir,tabpages,winsize
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

if has('win32')
  " cmd.exe uses %PROMPT% to set its prompt
  " default prompt is not user-friendly
  " ConEmu breaks it for winpty so :terminal has garbled prompt
  let $PROMPT = '$P$_$G$S'

  " Force xterm rendering in ConEmu for truecolor
  " Unset ConEmuANSI in GUIs so that terminal Vim doesn't break.
  if $ConEmuANSI ==# 'ON'
    if s:is_gui
      let $ConEmuANSI = ''
    elseif v:version >= 704 && !has('nvim') && has('builtin_terms')
      set term=xterm t_Co=256
      let &t_AB = "\e[48;5;%dm"
      let &t_AF = "\e[38;5;%dm"
      let &t_kb = nr2char(127)
      let &t_kD = "^[[3~"
    endif
  endif
endif
" }}}big

" Moved from normal to tiny version since 8.0.1564
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

  " {{{vim-plug
  let g:plug_window = 'tabnew'
  silent! call plug#begin(expand(s:base_dir . '/bundle'))
  if exists('g:loaded_plug')
    function! s:set_color()
      if has('termguicolors') &&
         \ (has('nvim-0.1.6') || !has('win32') || !has('patch-8.0.1531') || has('vcon'))
        if (has('nvim-0.2.1') || (has('patch-8.0.142') && has('patch-8.0.146'))) &&
           \ &t_Co == 256 && empty($TMUX)
          set termguicolors
        else
          set notermguicolors
        endif
      endif

      if has('syntax')
        let cur_color = get(g:, 'colors_name', 'default')
        if (has('gui_running') || &t_Co == 256) && cur_color !=# 'jellybeans'
          silent! colorscheme jellybeans
        endif
        let cur_color = get(g:, 'colors_name', 'default')
        if cur_color ==# 'default'
          silent! colorscheme torte
        endif
      endif
    endfunction

    let g:plug_disable = {'on': []}
    " {{{plug-core
    Plug 'chrisbra/matchit', (has('syntax') && v:version >= 800) ? {} : g:plug_disable
      if has('syntax') && v:version < 800 && !has('nvim')
        runtime! macros/matchit.vim
      endif
    Plug 'tpope/vim-scriptease'
    Plug 'tpope/vim-unimpaired'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-endwise'
    Plug 'tpope/tpope-vim-abolish'
    Plug 'tpope/vim-speeddating'
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

    let g:fzf_path = expand('~/.fzf')
    if isdirectory(g:fzf_path)
      Plug g:fzf_path
    else
      Plug 'junegunn/fzf', executable('bash') ? {
      \ 'dir': g:fzf_path,
      \ 'do': 'bash ./install --bin'
      \ } : g:plug_disable
    endif
    unlet g:fzf_path
    Plug 'janlazo/fzf.vim'
      let g:fzf_command_prefix = 'Fzf'
    Plug 'tpope/vim-fugitive'

    Plug 'Shougo/echodoc.vim', has('patch-7.4.774') ? {
    \ 'do': ':call echodoc#enable()'
    \ } : g:plug_disable
    let g:base_cond = has('timers')
    Plug 'prabirshrestha/asyncomplete.vim', g:base_cond ? {} : g:plug_disable
      if g:base_cond
        inoremap <silent> <expr> <TAB>   pumvisible() ? "\<C-n>" : "\<TAB>"
        inoremap <silent> <expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"
        inoremap <silent> <expr> <CR>    <C-R>=(pumvisible() ? "\<C-y>" : '')<CR><CR>
      endif
    Plug 'Shougo/neco-vim'
    Plug 'prabirshrestha/asyncomplete-necovim.vim', g:base_cond ? {} : g:plug_disable
      if g:base_cond
        autocmd User asyncomplete_setup
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
    " }}}plug-core
    " {{{plug-python
    let g:base_cond = has('python') || has('python3')
    Plug 'editorconfig/editorconfig-vim', g:base_cond ? {} : g:plug_disable
      let g:EditorConfig_preserve_formatoptions = 1
      let g:EditorConfig_max_line_indicator = 'none'
      let g:EditorConfig_exclude_patterns = ['scp://.*', 'fugitive://.*']
    Plug 'Valloric/MatchTagAlways', g:base_cond ? {} : g:plug_disable
      let g:mta_filetypes = {'html': 1, 'xml': 1, 'xhtml': 1, 'php': 1}
    " }}}plug-python
    " {{{plug-ft
    " Vim
    Plug 'junegunn/vader.vim'

    " Shell
    Plug 'keith/tmux.vim'
    Plug 'PProvost/vim-ps1'

    " Document
    Plug 'tpope/vim-markdown'
    Plug 'lervag/vimtex'
    Plug 'vim-pandoc/vim-pandoc-syntax'
    Plug 'aklt/plantuml-syntax'

    " Web
    Plug 'othree/html5.vim'
    Plug 'ap/vim-css-color'
    Plug 'hail2u/vim-css3-syntax'
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
    Plug 'daa84/neovim-gtk', exists('g:GtkGuiLoaded') ? {
    \ 'rtp': 'runtime'
    \ } : g:plug_disable
    unlet g:plug_disable g:base_cond
    silent! call plug#end()

    silent! call echodoc#enable()
    if has('nvim')
      autocmd VimEnter * call s:set_color()
    else
      call s:set_color()
    endif
  endif
  " }}}vim-plug
endif

if 1
  unlet s:fix_ux s:is_gui
  if exists('s:base_dir')
    unlet s:base_dir
  endif
endif
