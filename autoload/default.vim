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


function! s:format_opts() abort
  set formatoptions=crl

  if v:version > 703
    set formatoptions+=j
  endif
endfunction


" Call this function after sourcing options.vim
function! default#init() abort
  " Filetype
  let g:tex_flavor = 'latex'

  " External Plugins
  runtime! macros/matchit.vim   " '%' jumps to begin/end pairs

  if len(glob('~/.fzf')) > 0
    set rtp+=~/.fzf
  endif

  " Initialize plugins
  if !has('nvim')
    filetype plugin indent on
  endif

  if has('syntax') && !exists('g:syntax_on')
    syntax enable
  endif

  if has('autocmd')
    augroup default_config
      autocmd!

      " Reset settings mangled by ftplugin, syntax files
      autocmd BufWinEnter,BufNewFile * call s:format_opts()
    augroup END
  endif
endfunction
