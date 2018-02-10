" Copyright 2018 Jan Edmund Doroin Lazo
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
if exists('g:loaded_autoload_gui')
  finish
endif
let g:loaded_autoload_gui = 1
let s:cpoptions = &cpoptions
set cpoptions&vim
let s:has_gui = has('nvim') ? exists('g:GuiLoaded') : has('gui_running')

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
else
  let s:font = {}
endif

function! gui#update_fontsize(increment)
  if !s:has_gui || empty(s:font)
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
    if exists(':GuiFont') == 2
      execute 'GuiFont!' font
    endif
  else
    let &guifont = font
  endif
endfunction

" Assume that vim sourced gvimrc or nvim sourced ginit.vim
function! gui#init()
  if !s:has_gui
    return
  endif

  call gui#update_fontsize(0)
  nnoremap <silent> <A-=> :call gui#update_fontsize(1)<CR>
  nnoremap <silent> <A--> :call gui#update_fontsize(-1)<CR>
endfunction

let &cpoptions = s:cpoptions
unlet s:cpoptions
