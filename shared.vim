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
" Vim 7.4 (tiny) and Neovim 0.2.2 are the minimum supported versions.
" See `:h version` for feature checks.
" Check `v:version` for release + major version as an integer.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General
set cpoptions-=C cpoptions-=<
set nomodeline modelines=0
set shortmess+=s shortmess+=I
if has('patch-7.4.0314')
  set shortmess+=c
endif
if has('patch-7.4.1570')
  set shortmess+=F
endif

" Keys
set whichwrap=<,>,b,s nojoinspaces shiftround
set notimeout ttimeout ttimeoutlen=100
set keywordprg=:help
if has('patch-7.4.0868')
  " 4-space Indent
  set shiftwidth=4 smarttab expandtab
endif

" File
set fileformats=unix,dos suffixes=
set noswapfile directory= updatecount=0 updatetime=1000
if has('patch-7.4.0785')
  set nofixendofline
endif

" Do not force a memory flush to speedup manual writes.
if exists('+swapsync')
  set swapsync=
endif
if exists('+fsync')
  set nofsync
endif

" UI
set number textwidth=72 formatoptions=qlj
set sidescroll=5 nostartofline
set scrolloff=1 sidescrolloff=1 cmdheight=2 noshowmode
if has('patch-7.4.0977')
  set list listchars=tab:>\ ,trail:-,nbsp:+
endif

if 1
  let s:is_gui = has('gui_running')

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

  let s:font = {}
  let s:fontsize = {'min': 10, 'max': 72, 'cur': 12}
  if has('win32')
    let s:font = {
    \ 'type': ['Consolas'],
    \ 'size_prefix': 'h',
    \ 'sep': ':'
    \ }
    if !has('nvim')
      call extend(s:font.type, ['cANSI', 'qANTIALIASED'])
    endif
  elseif has('unix') && !has('win32unix')
    let s:font = {
    \ 'type': ['Monospace'],
    \ }
    if has('nvim')
      let s:font.size_prefix = 'h'
      let s:font.sep = ':'
    else
      let s:font.size_prefix = ''
      let s:font.sep = ' '
    endif
  endif
  function! s:update_fontsize(increment)
    if !s:is_gui || empty(s:font)
      return
    endif

    let s:fontsize.cur += a:increment
    if s:fontsize.cur < s:fontsize.min
      let s:fontsize.cur = s:fontsize.min
    elseif s:fontsize.cur > s:fontsize.max
      let s:fontsize.cur = s:fontsize.max
    endif

    let font = join(add(copy(s:font.type), s:font.size_prefix . s:fontsize.cur), s:font.sep)
    if has('nvim')
      if exists('*GuiFont')
        call GuiFont(font, 1)
      endif
    else
      let &guifont = font
    endif
  endfunction
endif

if has('win32')
  " cmd.exe uses %PROMPT% to set its prompt.
  " Default prompt is not user-friendly.
  " ConEmu's prompt is garbled in winpty.
  let $PROMPT = '$P$_$G$S'
endif

" {{{tiny
" Moved from small to tiny version since 8.0.1118
if has('windows')
  set splitbelow
  set showtabline=2

  if &tabpagemax < 50
    set tabpagemax=50
  endif

  " maktaba#buffer#Substitute()
  " https://github.com/google/vim-maktaba/blob/master/autoload/maktaba/buffer.vim
  function! s:remove_trailing_spaces()
    let cur_view = winsaveview()
    let [gdefault, ignorecase, smartcase] = [&gdefault, &ignorecase, &smartcase]
    set nogdefault noignorecase nosmartcase
    %s/\s\+$//ge
    let [&gdefault, &ignorecase, &smartcase] = [gdefault, ignorecase, smartcase]
    call winrestview(cur_view)
  endfunction
  nnoremap <silent> <Space>rs :call <SID>remove_trailing_spaces()<CR>
endif

" Moved from normal to tiny version since 8.0.1118
if has('vertsplit')
  set splitright
endif

" Moved from normal to tiny version since 8.1.1979
if has('modify_fname')
  let s:base_dir = expand('<sfile>:p:h')

  function! s:set_shell(shell)
    if v:version < 704
      echoerr a:shell 'is not supported for Vim ' v:version
      return
    elseif !executable(a:shell)
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
      set shellquote= noshellslash

      if has('nvim')
        let &shellcmdflag = '/s /c'
        let &shellxquote= '"'
        set shellxescape=
      else
        let &shellcmdflag = '/c'
        let &shellxquote = '('
        let &shellxescape = '"&|<>()@^'
      endif
    elseif (shell ==# 'powershell.exe' || shell ==# 'pwsh')
      let &shell = a:shell
      let &shellcmdflag = '-NoProfile -NoLogo -ExecutionPolicy RemoteSigned -Command'
      set shellxescape= noshellslash
      let &shellredir = '| Out-File -Encoding UTF8'
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
    elseif v:version >= 800 && shell =~# '^wsl'
      let &shell = a:shell
      let &shellcmdflag = 'bash --login -c'
      let &shellredir = '>%s 2>&1'
      if has('quickfix')
        let &shellpipe = '2>&1 | tee'
      endif
      let &shellxquote = '"'
      set shellxescape= shellquote= shellslash
    elseif shell =~# '^sh' || shell =~# '^bash'
      let &shell = a:shell
      let &shellcmdflag = '-c'
      set shellquote= shellslash shellxescape=
      let &shellredir = '>%s 2>&1'
      if has('quickfix')
        let &shellpipe = '2>&1 | tee'
      endif

      let &shellxquote = (!has('nvim') && has('win32')) ? '"' : ''
    else
      echoerr a:shell 'is not supported in Vim' v:version
    endif
  endfunction

  if has('win32')
    call s:set_shell(has('nvim') || empty($COMSPEC) ? 'cmd.exe' : $COMSPEC)
  elseif has('win32unix')
    call s:set_shell('sh')
  elseif has('unix') && executable($SHELL)
    call s:set_shell($SHELL)
  endif
endif

" Moved from normal to tiny version since 8.1.1901
if has('insert_expand')
  set complete-=i completeopt=menuone,preview
  if has('patch-7.4.0784')
    set completeopt+=noselect
  endif
  if has('patch-8.0.0043')
    set completeopt+=noinsert
  endif
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
if has('path_extra')
  set path=.,, define=
endif

if has('find_in_path')
  set include= includeexpr=
endif

if has('linebreak')
  " 3-digit line number in 80 col terminals
  set numberwidth=4

  if has('patch-8.0.0380')
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

  execute 'nnoremap Q :nohlsearch <Bar>' maparg('Q', 'n')
endif

if has('wildmenu')
  " Display hints, complete with selection via tab
  set wildmenu wildmode=longest:full,full
endif

if has('mksession')
  set sessionoptions=buffers,curdir,tabpages,winsize
endif

if has('mouse')
  set mouse=
endif

if has('syntax')
   " optimize for minified files
  set synmaxcol=320

  let &colorcolumn = has('patch-8.0.0675') ? &textwidth : ''

  function! s:toggle_spell() abort
    let &l:spell = !&l:spell
    if has('insert_expand')
      execute 'setlocal complete'.(&l:spell ? '+' : '-').'=kspell'
    endif
  endfunction

  if has('modify_fname')
    let s:spelldir = expand(s:base_dir . '/spell')

    " spellfile#WritableSpellDir() requires that ~/.vim/spell exists.
    if !isdirectory(s:spelldir)
      call mkdir(s:spelldir)
    endif

    if has('win32') && has('nvim') && !has('nvim-0.3.2')
      " Neovim uses hardcoded XDG paths on Windows but XDG is for Linux.
      " Redefine spellfile#WritableSpellDir() to point here.
      function! spellfile#WritableSpellDir()
        return s:spelldir
      endfunction
    else
      unlet s:spelldir
    endif
  endif

  function! s:set_color()
    if has('termguicolors')
    \ && (has('nvim')
          \ || !has('win32')
          \ || !has('patch-8.0.1531')
          \ || has('vcon'))
      let &termguicolors = &t_Co == 256 && empty($TMUX) && !has('osx')
      \ && (has('nvim')
            \ ? has('nvim-0.3.2')
            \ : (has('win32')
                \ ? (has('vcon') && has('patch-8.1.0839'))
                \ : has('patch-8.0.0146')))
    endif

    " Last color should always work
    if s:is_gui
      set background=light
      let colors = ['gruvbox8_soft', 'morning']
    else
      set background=dark
      let colors = ['gruvbox8_hard', 'torte']
    endif
    if has('patch-7.4.1036')
      for color in colors
        execute 'silent! colorscheme' color
        if get(g:, 'colors_name', 'default') ==# color
          return
        endif
      endfor
    else
      execute 'colorscheme' colors[-1]
    endif
  endfunction

  function! s:synname()
    return synIDattr(synID(line('.'), col('.'), 1), 'name')
  endfunction
endif

if has('persistent_undo')
  if has('modify_fname')
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

  if has('modify_fname') && exists('+viminfofile')
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
" }}}normal
" {{{big
if has('langmap')
  if exists('+langnoremap')
    set langnoremap
  elseif exists('+langremap')
    set nolangremap
  endif
endif

if has('signs') && has('patch-7.4.2201')
  set signcolumn=yes
endif
" }}}big

" Moved from normal to tiny version since 8.1.1210
if has('user_commands')
  command! SpaceToTab setlocal noexpandtab | retab!
  command! TabToSpace setlocal expandtab | retab

  if has('modify_fname')
    command! -nargs=1 SetShell call s:set_shell(<f-args>)
  endif

  if has('syntax')
    command! SynName echo s:synname()
    command! ToggleSpell call <SID>toggle_spell()
  endif
endif

" Moved from normal to tiny version since 8.0.1564
if has('autocmd') && has('modify_fname')
  " Vim
  let g:vimsyn_embed = ''
  let g:vim_indent_cont = 0

  " standard-plugin
  let g:loaded_getscriptPlugin = 1
  let g:loaded_logiPat = 1
  let g:loaded_vimballPlugin = 1
  let g:netrw_home = s:base_dir
  let g:netrw_dirhistmax = 0
  let g:netrw_banner = 0

  " Shell
  let g:is_posix = 1

  " HTML
  let g:html_indent_script1 = 'auto'
  let g:html_indent_style1 = 'auto'

  " Tex
  let g:tex_flavor = 'latex'

  " C
  let g:c_syntax_for_h = 1

  function! s:vim_enter()
    if has('nvim')
      " Detect nvim-qt
      let s:is_gui = s:is_gui || (exists('g:GuiLoaded') && has('nvim-0.3'))
    endif
    if s:is_gui
      set mouse=a

      let $TERM = ''
      if $ConEmuANSI ==# 'ON'
        let $ConEmuANSI = 'OFF'
      endif

      if has('nvim')
        if exists(':GuiLinespace') == 2
          GuiLinespace 1
        endif
      else
        set linespace=1
      endif

      call s:update_fontsize(0)
      nnoremap <silent> <A-=> :call <SID>update_fontsize(1)<CR>
      nnoremap <silent> <A--> :call <SID>update_fontsize(-1)<CR>
      if has('nvim') || (has('unix') && !has('win32unix'))
        nnoremap <silent> <C-ScrollWheelUp>   :call <SID>update_fontsize(1)<CR>
        nnoremap <silent> <C-ScrollWheelDown> :call <SID>update_fontsize(-1)<CR>
      endif
    endif
    if has('syntax')
      call s:set_color()
    endif

    if has('insert_expand') && get(g:, 'did_coc_loaded', 0)
      inoremap <silent> <expr> <TAB>   pumvisible() ? "\<C-n>" : "\<TAB>"
      inoremap <silent> <expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
      inoremap <silent> <expr> <CR>    pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
    endif
  endfunction
  augroup vimrc
    autocmd!
    autocmd VimEnter * call s:vim_enter()
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
      let g:matchup_matchparen_deferred =
      \ has('nvim') ? has('nvim-0.3') : has('timers')
      let g:matchup_matchpref_html_nolists = 1
    elseif has('syntax') && !has('nvim')
      if has('patch-7.4.1649')
        packadd matchit
      else
        runtime macros/matchit.vim
      endif
    endif
    Plug 'tpope/vim-scriptease'
    Plug 'tpope/vim-unimpaired'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-commentary'
    if has('syntax')
      " Change comment format based on syntax group
      " Required for html, pandoc
      function! s:update_commentstring()
        let syntax_name = s:synname()
        if syntax_name =~# '^[s]\?css'
          let b:commentary_format = '/* %s */'
        elseif syntax_name =~# '^javascript' || syntax_name =~# '^php'
          let b:commentary_format = '// %s'
        elseif syntax_name =~# '^html'
          let b:commentary_format = '<!-- %s -->'
        elseif (syntax_name !=# 'yamlDocumentStart' && syntax_name =~? 'yaml')
          let b:commentary_format = '# %s'
        elseif exists('b:commentary_format')
          unlet b:commentary_format
        endif
      endfunction
      autocmd vimrc CursorHold * call s:update_commentstring()
      autocmd vimrc CursorMoved * call s:update_commentstring()
    endif
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
      let g:rooter_patterns = [
      \ 'package.json', 'composer.json', 'Gemfile',
      \ 'go.mod', 'Cargo.toml', 'Podfile', 'pom.xml', 'build.gradle',
      \ 'Makefile', 'CMakeLists.txt',
      \ '.git/', '.hg/'
      \ ]

    call plug#('junegunn/fzf', executable('bash') ? {
    \ 'dir': expand('~/.fzf'),
    \ 'do': 'bash ./install --bin'
    \ } : s:plug_disable)
    if has('unix') && executable('x-terminal-emulator')
      let g:fzf_launcher = 'x-terminal-emulator -e bash -ic %s'
    endif
    Plug 'junegunn/fzf.vim'
      let g:fzf_command_prefix = 'Fzf'
    call plug#('tpope/vim-fugitive', {
    \ 'tag': 'v2.5'
    \ })

    let s:base_cond = v:version >= 800
    call plug#('editorconfig/editorconfig-vim', s:base_cond ? {} : s:plug_disable)
    if s:base_cond
      let g:EditorConfig_preserve_formatoptions = 1
      let g:EditorConfig_max_line_indicator = 'none'
      let g:EditorConfig_exclude_patterns = ['scp://.*', 'fugitive://.*']
    endif
    " }}}plug-core

    " {{{plug-color
    Plug 'lifepillar/vim8-colorschemes'
    let s:base_cond = has('nvim') ? has('nvim-0.3.1') : has('patch-8.0.0616')
    call plug#('lifepillar/vim-gruvbox8', s:base_cond ? {} : s:plug_disable)
    " }}}plug-color

    " {{{plug-autocomplete
    " Sources
    Plug 'lervag/vimtex'

    " coc.nvim
    let s:base_cond = (has('nvim')
    \ ? has('nvim-0.4.0')
    \ : has('patch-8.1.1522') && has('textprop'))
    \ && executable('node') && executable('npm')
    let s:base_config = {'tag': 'v0.0.74', 'branch': 'release'}
    call plug#('neoclide/coc.nvim', s:base_cond ? s:base_config : s:plug_disable)
    if s:base_cond
      let g:coc_global_extensions = [
      \ 'coc-tag', 'coc-vimtex',
      \ 'coc-css', 'coc-html', 'coc-json', 'coc-svg', 'coc-yaml',
      \ 'coc-tsserver', 'coc-vetur', 'coc-vimlsp',
      \ ]
      if executable('python3')
        call add(g:coc_global_extensions, 'coc-python')
      endif
      if executable('ruby') && executable('solargraph')
        call add(g:coc_global_extensions, 'coc-solargraph')
      endif
    endif
    " }}}plug-autocomplete

    " {{{plug-ft
    " Vim
    Plug 'junegunn/vader.vim'

    " Shell
    Plug 'ericpruitt/tmux.vim', {'rtp': 'vim'}
    Plug 'PProvost/vim-ps1'

    " Document
    Plug 'tpope/vim-markdown'
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
    let s:base_cond = has('patch-7.4.2071')
    call plug#('posva/vim-vue', s:base_cond ? {} : s:plug_disable)
      let g:vue_pre_processors = ['scss']
      let g:no_plugin_maps = 1
      let g:no_vue_maps = 1

    " Database
    Plug 'lifepillar/pgsql.vim'
      let g:sql_type_default = 'pgsql'

    " Data
    Plug 'cespare/vim-toml'
    Plug 'elzr/vim-json'
      let g:vim_json_syntax_conceal = 0

    " System
    Plug 'StanAngeloff/php.vim'
    Plug 'OrangeT/vim-csharp'
    Plug 'bumaociyuan/vim-swift'
    Plug 'rust-lang/rust.vim'
    Plug 'tbastos/vim-lua'
    " }}}plug-ft

    unlet s:plug_disable s:base_cond
    silent! call plug#end()
  endif
  " }}}vim-plug
endif

if has('modify_fname')
  unlet s:base_dir
endif
