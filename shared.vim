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
" Vim 7.4 (tiny) and Neovim 0.3.8 are the minimum supported versions.
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

" Keys
set whichwrap=<,>,b,s nojoinspaces shiftround
set notimeout
set keywordprg=:help
if has('patch-7.4.0868')
  " 2-space Indent
  set shiftwidth=2 expandtab
endif

" File
set fileformats=unix,dos
set noswapfile directory= updatecount=0 updatetime=1000
if has('patch-7.4.0785')
  set nofixendofline
endif
if has('nvim-0.5') || has('patch-8.1.1334')
  set hidden
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

  let s:font = {
  \ 'type': [],
  \ 'sep': ':',
  \ 'size_prefix': 'h',
  \ 'size_min': 10,
  \ 'size_cur': 12,
  \ 'size_max': 72,
  \ }
  if has('win32')
    call add(s:font.type, 'Consolas')
    if !has('nvim')
      call extend(s:font.type, ['cANSI', 'qANTIALIASED'])
    endif
  elseif has('unix') && !has('win32unix')
    call add(s:font.type, 'DejaVu Sans Mono')
    if !has('nvim')
      let s:font.size_prefix = ''
      let s:font.sep = ' '
    endif
  endif
  function! s:update_fontsize(increment)
    if !s:is_gui || empty(s:font.type)
      return
    endif

    let size = s:font.size_cur + a:increment
    let s:font.size_cur =
    \ size < s:font.size_min ? s:font.size_min :
    \ size > s:font.size_max ? s:font.size_max :
    \ size

    let &guifont = join(s:font.type + [s:font.size_prefix . s:font.size_cur], s:font.sep)
  endfunction

  " Use on mappings only.
  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction
endif

if has('win32')
  " cmd.exe uses %PROMPT% to set its prompt.
  " Default prompt is not user-friendly.
  " ConEmu's prompt is garbled in winpty.
  let $PROMPT = '$P$_$G$S'

  " fzf default file walker does not work on directory symlinks and junctions
  " https://github.com/junegunn/fzf/pull/1847#issuecomment-628960827
  let $FZF_DEFAULT_COMMAND = 'for /r %P in (*) do @(set "_curfile=%P" & set "_curfile=!_curfile:%__CD__%=!" & echo !_curfile!)'
endif

" {{{tiny
" Moved from small to tiny version since 8.0.1118
if has('windows')
  set splitbelow
  set showtabline=2

  " maktaba#buffer#Substitute()
  " https://github.com/google/vim-maktaba/blob/master/autoload/maktaba/buffer.vim
  function! s:strip_whitespace(start, end)
    let cur_view = winsaveview()
    let [gdefault, ignorecase, smartcase] = [&gdefault, &ignorecase, &smartcase]
    set nogdefault noignorecase nosmartcase
    execute (has('patch-7.4-0155') ? 'keeppatterns' : '') a:start.','.a:end.'substitute/\s\+$//ge'
    let [&gdefault, &ignorecase, &smartcase] = [gdefault, ignorecase, smartcase]
    call winrestview(cur_view)
  endfunction
endif

" Moved from normal to tiny version since 8.0.1118
if has('vertsplit')
  set splitright
endif

" Moved from normal to tiny version since 8.1.1979
if has('modify_fname')
  let s:base_dir = expand('<sfile>:p:h')

  " Unescape 'shell' option in case that the user escaped it.
  function! UnescapeShell(shell)
    if (has('nvim') || has('win32')) && a:shell =~# '^".\+"$'
      " de-quote
      return a:shell[1:-2]
    endif
    if !has('nvim') && has('unix') && a:shell =~# '\'
      " strip backslashes
      return substitute(a:shell, '\', '', 'g')
    endif
    return a:shell
  endfunction

  " Escape 'shell' option depending on the editor.
  function! EscapeShell(shell)
    if a:shell =~# ' '
      if has('nvim') || (has('win32') && has('patch-8.1.2115'))
        " quote
        return '"' . a:shell . '"'
      endif
      " TODO: Investigate the patch that added support for escaped 'shell'.
      if !has('nvim') && has('unix') && has('patch-8.0.1176')
        " add backslashes
        return escape(a:shell, ' ')
      endif
    endif
    return a:shell
  endfunction

  " If shell is supported, return 1. Else, return 0.
  function! SetShell(shell)
    let shell = UnescapeShell(a:shell)
    let tail = fnamemodify(shell, ':t')

    if tail =~# '^cmd\.exe'
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
    elseif tail =~# '^powershell\.exe' || tail =~# '^pwsh'
      let &shellcmdflag = '-NoProfile -NoLogo -ExecutionPolicy RemoteSigned -Command'
      if has('win32') || has('win32unix')
        let &shellcmdflag = ' ' . &shellcmdflag
      endif
      set shellxescape= shellquote= noshellslash
      let &shellredir = '| Out-File -Encoding UTF8'
      if has('quickfix')
        let &shellpipe = '|'
      endif

      if has('nvim')
        set shellxquote=
      else
        let &shellxquote = has('win32') ? '"' : ''
      endif
    elseif (tail =~# '^sh' || tail =~# '^bash')
    \ && (!has('win32') || tail =~# '\.exe$')
      let &shellcmdflag = '-c'
      set shellquote= shellslash shellxescape=
      let &shellredir = '>%s 2>&1'
      if has('quickfix')
        let &shellpipe = '2>&1 | tee'
      endif

      let &shellxquote = (!has('nvim') && has('win32')) ? '"' : ''
    else
      echoerr a:shell 'is not supported in Vim' v:version
      return 0
    endif
    let &shell = EscapeShell(shell)
    return 1
  endfunction

  let s:shells = filter(
  \ has('win32') ? [escape($COMSPEC, '\'), 'cmd.exe'] :
  \ [$SHELL, 'sh'],
  \ 'executable(v:val)')
  for s:shell in s:shells
    if SetShell(s:shell)
      break
    endif
  endfor
  unlet s:shell s:shells
endif

" Moved from normal to tiny version since 8.1.1901
if has('insert_expand')
  set completeopt=menuone,preview
  if has('patch-7.4.0784')
    set completeopt+=noselect
  endif
  if has('patch-8.0.0043')
    set completeopt+=noinsert
  endif
endif

" Moved from normal to tiny since 8.1.2096
if has('comments')
  set comments=
endif
" }}}tiny
" {{{normal
if has('path_extra')
  set path=.,,
endif

if has('find_in_path')
  set define= include= includeexpr=
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

  function! Statusline()
    let lhs = ['%8.8{"'.get(s:modes, mode(), 'MODE').'"}']
    if &buftype ==# 'terminal'
      return join(add(lhs, '%5f'), ' | ')
    endif
    let rhs = ['%3l:%-3c']
    if &columns > 40
      call add(lhs, '%5.'.(&columns * 2 / 5).'f %r%m')
      if strlen(&filetype)
        call insert(rhs, &filetype, 0)
      endif
    endif
    if &columns > 60
      if strlen(&fileencoding)
        call insert(rhs, &fileencoding, -1)
      endif
      call insert(rhs, &fileformat, -1)
    endif
    return join(lhs, ' | ').'%='.join(rhs, ' | ')
  endfunction

  set statusline=%!Statusline()
endif

if has('extra_search') && has('reltime')
  " Q defaults to Ex mode but I don't use it.
  " $VIMRUNTIME/defaults.vim remaps Q to gq but I don't format comments.
  " Remap it to redraw the screen.
  nnoremap <silent> Q :nohlsearch <Bar> redraw!<CR>
endif

if has('wildmenu')
  set wildmode=longest:full,full
endif

if has('mksession')
  set sessionoptions=buffers,curdir,tabpages,winsize
  set viewoptions=options
  if !has('nvim-0.5')
    set sessionoptions+=slash sessionoptions+=unix
    set viewoptions+=slash viewoptions+=unix
  endif
  if has('patch-8.0.1289')
    set viewoptions+=curdir
  endif
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

  " spellfile#WritableSpellDir() requires that ~/.vim/spell exists.
  if has('modify_fname') && !has('nvim-0.4')
    let s:spelldir = expand(s:base_dir . '/spell')
    if !isdirectory(s:spelldir)
      call mkdir(s:spelldir)
    endif
    unlet s:spelldir
  endif

  function! s:set_color()
    if has('termguicolors')
    \ && (has('nvim')
          \ || !has('win32')
          \ || !has('patch-8.0.1531')
          \ || has('vcon'))
      let &termguicolors = &t_Co == 256 && empty($TMUX) && !has('mac')
      \ && (has('nvim')
            \ || (has('win32')
                  \ ? (has('vcon') && has('patch-8.1.0839'))
                  \ : has('patch-8.0.0146')))
    endif

    " Last color should always work
    let colors = &background ==# 'light'
    \ ? ['gruvbox8_soft', 'morning']
    \ : ['gruvbox8_hard', 'iceberg', 'torte']
    if has('patch-7.4.1036')
    \ && (s:is_gui || has('nvim') || !(has('win32') || has('win32unix')))
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
  function! s:set_color_post(color)
    if has('win32') || has('win32unix')
      unlet! g:fzf_colors
    endif
  endfunction

  function! s:synname()
    return synIDattr(synID(line('.'), col('.'), 1), 'name')
  endfunction
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
if has('signs') && has('patch-7.4.2201')
  set signcolumn=yes
endif
" }}}big

" Moved from normal to tiny version since 8.1.1210
if has('user_commands')
  command! SpaceToTab setlocal noexpandtab | retab!
  command! TabToSpace setlocal expandtab | retab

  " https://github.com/axelf4/vim-strip-trailing-whitespace/blob/master/plugin/strip_trailing_whitespace.vim
  if has('windows')
    command! -bar -range=% StripWhitespace call s:strip_whitespace(<line1>, <line2>)
  endif

  if has('modify_fname')
    command! -nargs=1 -complete=shellcmd SetShell call SetShell(<f-args>)
  endif

  if has('syntax')
    command! SetColor call s:set_color()
    command! SynName echo s:synname()
    command! ToggleSpell call <SID>toggle_spell()
  endif
endif

" Moved from normal to tiny version since 8.0.1564
if has('autocmd') && has('modify_fname')
  " Vim
  let g:no_plugin_maps = 1
  let g:no_vim_maps = 1
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
  let g:html_no_rendering = 1

  " Tex
  let g:tex_flavor = 'latex'

  " C
  let g:c_no_bsd = 1
  let g:c_no_if0 = 1
  let g:c_syntax_for_h = 1

  " Python
  let g:python_recommended_style = 0
  let g:pyindent_disable_parentheses_indenting = 1

  function! s:vim_enter()
    if exists('g:loaded_plug')
    \ && has('patch-7.4.1347')
    \ && empty(glob(g:plug_home . '/*'))
    \ && empty($CI)
      PlugInstall --sync
      q
    endif
    if has('nvim')
      " Detect nvim-qt
      let s:is_gui = s:is_gui || (exists('g:GuiLoaded') && has('nvim-0.3'))
    endif
    if s:is_gui
      set mouse=a
      set linespace=1

      let $TERM = ''
      if $ConEmuANSI ==# 'ON'
        let $ConEmuANSI = 'OFF'
      endif

      call s:update_fontsize(0)
      nnoremap <silent> <A-=> :call <SID>update_fontsize(1)<CR>
      nnoremap <silent> <A--> :call <SID>update_fontsize(-1)<CR>
      if has('nvim') || (has('unix') && !has('win32unix'))
        nnoremap <silent> <C-ScrollWheelUp>   :call <SID>update_fontsize(1)<CR>
        nnoremap <silent> <C-ScrollWheelDown> :call <SID>update_fontsize(-1)<CR>
      endif
    else
      if has('mouse')
        let &mouse = (has('win32') || &term =~# '^xterm') ? 'a' : 'nvi'
      endif
    endif
    if has('syntax')
      let hour = exists('*strftime') ? strftime('%H') : 9
      let &background = (s:is_gui && hour >= 7 && hour < 17)
      \ ? 'light'
      \ : 'dark'
      call s:set_color()
    endif

    if get(g:, 'did_coc_loaded', 0)
      imap <silent> <TAB>   <Plug>CocTab
      imap <silent> <S-TAB> <Plug>CocShiftTab
      imap <silent> <CR>    <Plug>CocCR
    endif
    if get(g:, 'loaded_endwise', 0)
      execute 'imap <silent> <CR> '.(
      \ maparg('<CR>', 'i') !=# '' ? maparg('<CR>', 'i') : '<CR>'
      \ ).'<Plug>DiscretionaryEnd'
    endif
  endfunction
  augroup vimrc
    autocmd!
    if has('nvim') ? has('nvim-0.4') : has('patch-8.1.1113')
      autocmd VimEnter * ++nested ++once call s:vim_enter()
    else
      autocmd VimEnter * nested call s:vim_enter()
    endif
    autocmd ColorScheme * call s:set_color_post(expand('<amatch>'))
  augroup END

  " {{{vim-plug
  let g:plug_home = expand(s:base_dir . '/bundle')
  let g:plug_threads = 4
  let g:plug_window = 'tabnew'
  silent! call plug#begin()
  if exists('g:loaded_plug')
    let s:plug_disable = {'for': [], 'on': []}
    let s:base_cond = 1
    let s:base_config = {}

    " {{{plug-core
    let s:base_cond = v:version >= 800 && has('syntax') && has('reltime')
    call plug#('andymass/vim-matchup', s:base_cond ? {} : s:plug_disable)
    if s:base_cond
      let g:loaded_matchit = 1
      let g:matchup_matchparen_offscreen = {
      \ 'method': (has('nvim')
        \ ? has('nvim-0.4')
        \ : has('textprop') && has('patch-8.1.1410')
        \ ) ? 'popup' : '',
      \ 'scrolloff': 1
      \ }
      let g:matchup_matchparen_deferred =
      \ has('nvim') || has('timers')
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
    Plug 'tpope/tpope-vim-abolish'
    Plug 'tpope/vim-repeat'
    Plug 'tyru/caw.vim'
    Plug 'Shougo/context_filetype.vim'
      let g:context_filetype#filetypes = {
      \ 'pandoc': [{
      \    'start': '^\s*```\s*\(\h\w*\)',
      \    'end': '^\s*```$',
      \    'filetype' : '\1',
      \   }],
      \ }
      let g:context_filetype#same_filetypes = {
      \ 'postcss': 'css',
      \ }
    Plug 'justinmk/vim-dirvish'
    Plug 'AndrewRadev/splitjoin.vim'
    Plug 'tommcdo/vim-lion'
    Plug 'airblade/vim-rooter'
      let g:rooter_cd_cmd = 'lcd'
      let g:rooter_silent_chdir = 1
      let g:rooter_targets = '*'
      let g:rooter_change_directory_for_non_project_files = 'current'
      let g:rooter_patterns = [
      \ 'package.json', 'composer.json', 'Gemfile', 'pyproject.toml',
      \ 'go.mod', 'Cargo.toml', 'Podfile', 'pom.xml', 'build.gradle',
      \ 'CMakeLists.txt', 'Makefile',
      \ '.git/', '.hg/'
      \ ]

    let s:base_config = {
    \ 'dir': expand('~/.fzf'),
    \ }
    let s:base_cond = isdirectory(s:base_config.dir) || executable('fzf') || executable('bash')
    if executable('bash') && !executable('fzf') && !has('win32')
      let s:base_config.do = 'bash ./install --bin'
    endif
    call plug#(
    \ isdirectory(s:base_config.dir) ? s:base_config.dir : 'junegunn/fzf',
    \ s:base_cond ? s:base_config : s:plug_disable
    \ )
    if s:base_cond
      if has('unix') && executable('x-terminal-emulator')
        let g:fzf_launcher = 'x-terminal-emulator -e bash -ic %s'
      endif
      let g:fzf_history_dir = s:base_dir . '/.fzf_history'
    endif
    call plug#('junegunn/fzf.vim', s:base_cond ? {
    \ 'commit': '23dda8602f138a9d75dd03803a79733ee783e356'
    \ } : s:plug_disable)
    if s:base_cond
      let g:fzf_command_prefix = 'Fzf'
      if has('nvim')
      \ ? has('nvim-0.4.0')
      \ : has('popupwin') && has('patch-8.2.0191')
        let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.8 } }
      endif
    endif
    call plug#('tpope/vim-fugitive')

    let s:base_cond = v:version >= 800
    call plug#('editorconfig/editorconfig-vim', s:base_cond ? {} : s:plug_disable)
    if s:base_cond
      let g:EditorConfig_preserve_formatoptions = 1
      let g:EditorConfig_max_line_indicator = 'none'
      let g:EditorConfig_exclude_patterns = ['scp://.*', 'fugitive://.*']
    endif
    " }}}plug-core

    " {{{plug-ft
    " Vim
    Plug 'junegunn/vader.vim'

    " Shell
    Plug 'ericpruitt/tmux.vim', {'rtp': 'vim'}
    Plug 'tpope/vim-git'

    " Document/Template
    Plug 'lervag/vimtex'
    Plug 'tpope/vim-markdown'
    Plug 'vim-pandoc/vim-pandoc-syntax'
    Plug 'aklt/plantuml-syntax'
    Plug 'othree/html5.vim'
    Plug 'digitaltoad/vim-pug'

    " Data
    Plug 'cespare/vim-toml'
    Plug 'elzr/vim-json'
      let g:vim_json_syntax_conceal = 0

    " Programming
    Plug 'PProvost/vim-ps1'
    Plug 'JulesWang/css.vim'
    Plug 'cakebaker/scss-syntax.vim'
    Plug 'tpope/vim-haml'
    Plug 'othree/yajs.vim'
    Plug 'othree/es.next.syntax.vim'
    Plug 'kchmck/vim-coffee-script'
    Plug 'HerringtonDarkholme/yats.vim'
    Plug 'MaxMEllon/vim-jsx-pretty'
    let s:base_cond = has('patch-7.4.2071')
    call plug#('posva/vim-vue', s:base_cond ? {} : s:plug_disable)
    if s:base_cond
      let g:vue_pre_processors = ['sass', 'scss']
      let g:no_vue_maps = 1
    endif
    Plug 'lifepillar/pgsql.vim'
      let g:sql_type_default = 'pgsql'
    Plug 'TysonAndre/php-vim-syntax'
    Plug 'OrangeT/vim-csharp'
    Plug 'bumaociyuan/vim-swift'
    Plug 'rust-lang/rust.vim'
    Plug 'tbastos/vim-lua'
    Plug 'vim-jp/vim-cpp'
    Plug 'udalov/kotlin-vim'
    " }}}plug-ft

    " {{{plug-autocomplete
    call plug#('tpope/vim-endwise', has('insert_expand') ? {} : s:plug_disable)
    if has('insert_expand')
      let g:endwise_no_mappings = 1
    endif

    " coc.nvim
    let s:base_cond = (has('nvim')
    \ ? has('nvim-0.4.0')
    \ : has('patch-8.1.1522')
    \   && has('insert_expand') && has('textprop')
    \   && has('job') && has('channel') && has('terminal')
    \ ) && executable('node') && executable('npm')
    let s:base_config = {
    \ 'branch': 'release',
    \ 'tag': 'v0.0.78',
    \ }
    call plug#('neoclide/coc.nvim', s:base_cond ? s:base_config : s:plug_disable)
    if s:base_cond
      let g:coc_data_home = s:base_dir . '/.coc'
      let g:coc_global_extensions = [
      \ 'coc-vimlsp', 'coc-tag', 'coc-vimtex',
      \ 'coc-json@1.2.6', 'coc-yaml', 'coc-markdownlint',
      \ 'coc-css', 'coc-html', 'coc-svg',
      \ 'coc-tsserver'
      \ ]
      if executable('clangd')
        call add(g:coc_global_extensions, 'coc-clangd')
      endif
      if executable('python3')
        call add(g:coc_global_extensions, 'coc-python')
      endif
      if executable('ruby') && executable('solargraph')
        call add(g:coc_global_extensions, 'coc-solargraph')
      endif
      if executable('java')
        call add(g:coc_global_extensions, 'coc-java')
        if isdirectory($JAVA_HOME)
          call add(g:coc_global_extensions, 'coc-xml')
        endif
      endif
      if executable('dotnet')
        call add(g:coc_global_extensions, 'coc-omnisharp')
      endif
      if executable('rustup')
        call add(g:coc_global_extensions, 'coc-rls')
      endif

      inoremap <expr> <Plug>CocTab
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
      inoremap <expr> <Plug>CocShiftTab
      \ pumvisible() ? "\<C-p>" : "\<C-h>"
      inoremap <expr> <Plug>CocCR
      \ pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
    endif
    " }}}plug-autocomplete

    " {{{plug-color
    Plug 'lifepillar/vim8-colorschemes'
    Plug 'cocopon/iceberg.vim'
    let s:base_cond = has('nvim')
    \ || has('patch-8.0.0616')
    \ || has('gui_running')
    call plug#('lifepillar/vim-gruvbox8', s:base_cond ? {} : s:plug_disable)
    " }}}plug-color

    unlet s:plug_disable s:base_cond s:base_config
    silent! call plug#end()
  endif
  " }}}vim-plug
endif
