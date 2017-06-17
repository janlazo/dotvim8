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
if exists('g:loaded_plugin_conemu') ||
    \ has('gui_running') ||
    \ has('nvim') ||
    \ !has('win32') ||
    \ $ConEmuANSI !=# 'ON'
  finish
endif
let g:loaded_plugin_conemu = 1

set term=xterm
set t_Co=256
let &t_AB="\e[48;5;%dm"
let &t_AF="\e[38;5;%dm"

inoremap <Char-0x07F> <BS>
nnoremap <Char-0x07F> <BS>
vnoremap <Char-0x07F> <BS>
