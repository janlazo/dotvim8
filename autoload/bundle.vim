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
  runtime vim-plug/plug.vim
  silent! call plug#begin(expand(s:base_dir . '/bundles'))
  let plug_disable = {'on': []}
  " {{{plug-core
  Plug 'tpope/vim-scriptease'
  Plug 'tpope/vim-unimpaired'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-endwise'
  Plug 'tpope/tpope-vim-abolish'
  Plug 'tpope/vim-speeddating'
  Plug 'tpope/vim-repeat'
  Plug 'justinmk/vim-dirvish'
    nnoremap <Space>o :Dirvish<CR>
  Plug 'mhinz/vim-grepper'
    if !exists('g:grepper')
      let g:grepper = {}
    endif

    let g:grepper.tools = filter([
    \ 'rg', 'sift', 'grep', 'findstr', 'git'
    \ ], 'executable(v:val)')

    if !empty(g:grepper.tools)
      let grep_cmd = g:grepper.tools[0]
      let grep_cmd = ':Grepper' . toupper(grep_cmd[0]) . grep_cmd[1:]
      execute 'nnoremap <Space>/' grep_cmd ''
    endif
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
  Plug 'junegunn/vim-easy-align'
    nmap ga <Plug>(EasyAlign)
    xmap ga <Plug>(EasyAlign)

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
  Plug 'tpope/vim-fugitive'
  " }}}plug-core
  " {{{plug-python
  let base_cond = has('python') || has('python3')
  Plug 'editorconfig/editorconfig-vim', base_cond ? {} : plug_disable
    let g:EditorConfig_preserve_formatoptions = 1
    let g:EditorConfig_max_line_indicator = 'none'
    let g:EditorConfig_exclude_patterns = ['scp://.*']
  Plug 'Valloric/MatchTagAlways', base_cond ? {} : plug_disable
    let g:mta_filetypes = {'html': 1, 'xml': 1, 'xhtml': 1, 'php': 1}

  let base_cond = base_cond && has('nvim')
  Plug 'Shougo/deoplete.nvim', base_cond ? {} : plug_disable
    inoremap <silent><expr> <TAB>   pumvisible() ? '<C-n>' : '<TAB>'
    inoremap <silent><expr> <S-TAB> pumvisible() ? '<C-p>' : '<S-TAB>'
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
    let g:tex_flavor = 'latex'
  Plug 'aklt/plantuml-syntax'

  " Web
  Plug 'othree/csscomplete.vim'
  Plug 'kchmck/vim-coffee-script'
  Plug 'leafgarland/typescript-vim'

  " Database
  Plug 'exu/pgsql.vim'
    let g:sql_type_default = 'pgsql'

  " Data
  Plug 'cespare/vim-toml'
  " }}}plug-ft
  call plug#end()

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

  if has('nvim')
    if !empty(glob('bundles/deoplete.nvim'))
      augroup dotvim8_deoplete
        autocmd!
        autocmd InsertEnter * call deoplete#enable() | autocmd! dotvim8_deoplete
      augroup END
    endif
  endif
endfunction

let &cpoptions = s:cpoptions
unlet s:cpoptions
