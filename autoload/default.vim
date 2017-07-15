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

function! s:fzf() abort
  let fzf_dirs = split(glob('~/.fzf', 1), "\n")

  if empty(fzf_dirs)
    return
  endif

  let &rtp .= ',' . fzf_dirs[0]
  let fzf_docs = split(glob(fzf_dirs[0] . '/doc', 1), "\n")

  if !empty(fzf_docs)
    execute 'helptags' fzf_docs[0]
  endif
endfunction


function! s:format_opts() abort
  set formatoptions=rl

  if v:version > 703
    set formatoptions+=j
  endif
endfunction


function! s:vim_enter() abort
  let patches = map(['7.4.1799', '8.0.0142', '8.0.0147'], '"patch-" . v:val')

  if has('termguicolors') && &t_Co == 256 &&
    \ (has('nvim-0.1.6') || !empty(filter(patches, 'has(v:val)')))
    set termguicolors
  endif

  if has('syntax')
    colorscheme torte
  endif
endfunction


" Call this function after sourcing options.vim
function! default#init() abort
  " Filetype
  let g:tex_flavor = 'latex'

  " External Plugins
  runtime! macros/matchit.vim   " '%' jumps to begin/end pairs
  call s:fzf()

  " Initialize plugins
  filetype plugin indent on

  if has('syntax') && !exists('g:syntax_on')
    syntax enable
  endif

  if has('autocmd')
    augroup default_config
      autocmd!
      autocmd VimEnter * call s:vim_enter()

      " Reset settings mangled by ftplugin, syntax files
      autocmd BufWinEnter,BufNewFile * call s:format_opts()
    augroup END
  endif
endfunction

let &cpoptions = s:cpoptions
unlet s:cpoptions
