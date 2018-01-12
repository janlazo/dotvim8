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
if exists('g:loaded_autoload_bundle')
  finish
endif
let g:loaded_autoload_bundle = 1
let s:cpoptions = &cpoptions
set cpoptions&vim
let s:base_dir = expand('<sfile>:p:h:h')

" Call this function after sourcing shared.vim
" Assume vim 7.2+ (normal/huge version) or nvim 0.1+
" For Windows, assume vim 7.4+ or nvim 0.2+
function! bundle#init() abort
  let g:plug_window = 'tabnew'
  silent! call plug#begin(expand(s:base_dir . '/bundle'))
  let plug_disable = {'on': []}
  " {{{plug-core
  if v:version >= 800
    Plug 'chrisbra/matchit'
  else
    Plug 'chrisbra/matchit', plug_disable

    if has('syntax') && !has('nvim-0.1.6')
      runtime! macros/matchit.vim
    endif
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
  Plug 'airblade/vim-rooter'
    let g:rooter_use_lcd = 1
    let g:rooter_silent_chdir = 1
    let g:rooter_targets = '*'
    let g:rooter_change_directory_for_non_project_files = 'current'
    " Version Control
    let g:rooter_patterns = ['.git/', '.hg/', '.svn/']
    " Javascript
    call extend(g:rooter_patterns, ['package.json'])
    " PHP
    call extend(g:rooter_patterns, ['composer.json'])
    " Java
    call extend(g:rooter_patterns, ['pom.xml'])
  Plug 'tommcdo/vim-lion'
  Plug 'Shougo/echodoc.vim', has('patch-7.4.774') ? {
  \ 'do': ':call echodoc#enable()'
  \ } : plug_disable

  let fzf_path = expand('~/.fzf')

  if isdirectory(fzf_path)
    Plug fzf_path
  else
    Plug 'junegunn/fzf', {
    \ 'dir': fzf_path,
    \ 'do': 'bash ./install --bin'
    \ }
  endif

  Plug 'janlazo/fzf.vim'
    let g:fzf_command_prefix = 'Fzf'
  Plug 'tpope/vim-fugitive'
  " }}}plug-core
  " {{{plug-python
  let base_cond = has('python') || has('python3')
  Plug 'editorconfig/editorconfig-vim', base_cond ? {} : plug_disable
    let g:EditorConfig_preserve_formatoptions = 1
    let g:EditorConfig_max_line_indicator = 'none'
    let g:EditorConfig_exclude_patterns = ['scp://.*', 'fugitive://.*']
  Plug 'Valloric/MatchTagAlways', base_cond ? {} : plug_disable
    let g:mta_filetypes = {'html': 1, 'xml': 1, 'xhtml': 1, 'php': 1}

  let base_cond = base_cond && has('nvim')
  Plug 'Shougo/deoplete.nvim', base_cond ? {
  \ 'do': ':UpdateRemotePlugins'
  \ } : plug_disable
    let g:deoplete#enable_at_startup = 1
    inoremap <silent><expr> <TAB>   pumvisible() ? '<C-n>' : '<TAB>'
    inoremap <silent><expr> <S-TAB> pumvisible() ? '<C-p>' : '<S-TAB>'

    if base_cond
      function! s:deoplete_cr() abort
        return deoplete#close_popup() . "\<CR>"
      endfunction

      inoremap <silent> <CR> <C-R>=<SID>deoplete_cr()<CR>
    endif
  Plug 'Shougo/neco-vim', base_cond ? {} : plug_disable
  " }}}plug-python
  " {{{plug-color
  Plug 'ap/vim-css-color'
  Plug 'nanotech/jellybeans.vim'
    " some shells/terminals don't use ANSI in 8-16 color terminals
    " ex. cmd.exe and powershell.exe in Windows
    let g:jellybeans_use_lowcolor_black = 0
    let g:jellybeans_use_term_italics = 0
    let g:jellybeans_use_gui_italics = 0
  " }}}plug-color
  " {{{plug-ft
  " Vim
  Plug 'junegunn/vader.vim'

  " Shell
  Plug 'keith/tmux.vim'
  Plug 'PProvost/vim-ps1'

  " Document
  Plug 'tpope/vim-markdown'
  Plug 'vim-pandoc/vim-pandoc-syntax'
  Plug 'lervag/vimtex'
  Plug 'aklt/plantuml-syntax'

  " Web
  Plug 'hail2u/vim-css3-syntax'
  Plug 'othree/csscomplete.vim'
  Plug 'othree/javascript-libraries-syntax.vim'
    let g:used_javascript_libs = 'jquery'
  Plug 'othree/yajs.vim'
  Plug 'kchmck/vim-coffee-script'
  Plug 'leafgarland/typescript-vim'

  " Database
  Plug 'exu/pgsql.vim'
    let g:sql_type_default = 'pgsql'

  " Data
  Plug 'cespare/vim-toml'

  " System
  Plug 'rust-lang/rust.vim'
  Plug 'tbastos/vim-lua'
  " }}}plug-ft
  call plug#end()
  try
    call echodoc#enable()
  catch
  endtry

  " {{{set-color
  if has('termguicolors')
    if (has('nvim-0.1.6') || (has('patch-8.0.142') && has('patch-8.0.146'))) &&
        \ &t_Co == 256 && empty($TMUX)
      set termguicolors
    else
      set notermguicolors
    endif
  endif

  try
    let cur_color = get(g:, 'colors_name', 'default')

    if has('gui_running') || &t_Co == 256
      if cur_color !=# 'jellybeans'
        colorscheme jellybeans
      endif
    endif
  catch
  finally
    let cur_color = get(g:, 'colors_name', 'default')

    if cur_color ==# 'default'
      colorscheme torte
    endif
  endtry
  " }}}set-color
endfunction

let &cpoptions = s:cpoptions
unlet s:cpoptions
