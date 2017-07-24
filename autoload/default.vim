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
if exists('g:loaded_autoload_default')
  finish
endif
let g:loaded_autoload_default = 1
let s:cpoptions = &cpoptions
set cpoptions&vim
let s:base_dir = expand('<sfile>:p:h:h')


" Reset settings mangled by ftplugin, syntax files
function! s:reset_opts() abort
  set formatoptions=rl

  if v:version > 703
    set formatoptions+=j
  endif
endfunction


" Call this function after sourcing tiny.vim
" Assume vim 7.2+ (normal/huge version) or nvim 0.1+
" For Windows, assume vim 7.4+ or nvim 0.2+
function! default#init() abort
  if !has('syntax') || !has('autocmd')
    finish
  endif

  " Filetype
  let g:tex_flavor = 'latex'

  runtime vim-plug/plug.vim
  silent! call plug#begin(expand(s:base_dir . '/bundles'))
  Plug 'tpope/vim-unimpaired'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-endwise'
  Plug 'tpope/tpope-vim-abolish'
  Plug 'tpope/vim-speeddating'
  Plug 'tpope/vim-repeat'

  let fzf_path = expand('~/.fzf')

  if isdirectory(fzf_path)
    Plug fzf_path
  endif

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

  Plug 'nanotech/jellybeans.vim'
    " some shells/terminals don't use ANSI in 8-16 color terminals
    " ex. cmd.exe and powershell.exe in Windows
    let g:jellybeans_use_lowcolor_black = 0
    let g:jellybeans_use_term_italics = 0
    let g:jellybeans_use_gui_italics = 0
    let g:jellybeans_override = {
    \ 'Todo': {},
    \ 'Comment': {},
    \ 'background': {'ctermbg': 'none', '256ctermbg': 'none'}
    \ }
  Plug 'junegunn/seoul256.vim'
    let g:seoul256_background = 233
    let g:seoul256_light_background = 255

    if has('unix')
      let g:seoul256_srgb = 1
    endif
  call plug#end()

  if has('termguicolors')
    let patches = filter(map([
    \ '7.4.1799', '8.0.0142', '8.0.0147'
    \ ], '"patch-" . v:val'), 'has(v:val)')

    if (has('nvim-0.1.6') || !empty(patches)) &&
        \ &t_Co == 256 && empty($TMUX)
      set termguicolors
    else
      set notermguicolors
    endif
  endif

  let cur_color = get(g:, 'colors_name', 'default')

  if (has('gui_running') || (has('termguicolors') && &termguicolors)) &&
      \ cur_color !=# 'jellybeans'
    silent! colorscheme jellybeans
  elseif &t_Co == 256 && cur_color !=# 'seoul256'
    silent! colorscheme seoul256
  endif

  let cur_color = get(g:, 'colors_name', 'default')

  if cur_color ==# 'default'
    colorscheme torte
  endif

  augroup default_config
    autocmd!
    autocmd BufWinEnter,BufNewFile * call s:reset_opts()
  augroup END
endfunction

let &cpoptions = s:cpoptions
unlet s:cpoptions
