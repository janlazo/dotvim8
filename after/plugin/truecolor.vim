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
if exists('g:loaded_after_plugin_truecolor') || !has('termguicolors')
  finish
endif
let g:loaded_after_plugin_truecolor = 1

" Neovim has reliable true color support since 0.1.x
" Vim 8.0.147+ is required for truecolor in Windows builds
let s:patches = [
  \ '7.4.1770', '7.4.1799', '7.4.1854', '7.4.1942',
  \ '8.0.0142', '8.0.0147'
  \ ]
call map(s:patches, '"patch-" . v:val')
let s:tc_vim = has('nvim') ||
              \ (v:version >= 800 &&
                \ !empty(filter(copy(s:patches), 'has(v:val)')))

" Don't use truecolor in terminals with 8-16 colors only
let s:tc_term = has('gui_running') || &t_Co > 16

" Tmux 2.2+ supports truecolor if terminal-overrides has 'screen-256color:Tc'
let s:tmux_cmd = 'tmux show-options -sq terminal-overrides'
let s:tc_tmux = len($TMUX) == 0 ||
                \ (executable('tmux') &&
                  \ system(s:tmux_cmd) =~# 'screen-256color:Tc')

if s:tc_vim && s:tc_term && s:tc_tmux
  " Terminal escape codes for printf() to use on Tmux
  " Requires double-quoted string values
  " N/A for Neovim
  if &term =~# '^screen' && !has('nvim')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  endif

  set termguicolors
else
  set notermguicolors
endif
