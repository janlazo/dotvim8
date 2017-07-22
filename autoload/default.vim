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


function! s:format_opts() abort
  set formatoptions=rl

  if v:version > 703
    set formatoptions+=j
  endif
endfunction


function! s:vim_enter() abort
  if has('termguicolors')
    let patches = map(['7.4.1799', '8.0.0142', '8.0.0147'], '"patch-" . v:val')

    if (has('nvim-0.1.6') || !empty(filter(patches, 'has(v:val)'))) &&
        \ &t_Co == 256 && empty($TMUX)
      set termguicolors
    else
      set notermguicolors
    endif
  endif

  colorscheme torte
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
  call plug#begin(expand(s:base_dir . '/bundles'))

  let fzf_path = expand('~/.fzf')

  if isdirectory(fzf_path)
    Plug fzf_path
  endif

  Plug 'justinmk/dirvish'
  nnoremap <Space>o :Dirvish<CR>

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

  Plug 'mhinz/vim-grepper'
  call plug#end()

  augroup default_config
    autocmd!
    autocmd VimEnter * call s:vim_enter()

    " Reset settings mangled by ftplugin, syntax files
    autocmd BufWinEnter,BufNewFile * call s:format_opts()
  augroup END
endfunction

let &cpoptions = s:cpoptions
unlet s:cpoptions
