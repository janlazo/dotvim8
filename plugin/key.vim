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
if exists('g:loaded_plugin_key')
  finish
endif
let g:loaded_plugin_key = 1
let s:cpoptions = &cpoptions
set cpoptions&vim

nnoremap <silent> <Space>st :call util#space_to_tab()<CR>
nnoremap <silent> <Space>ts :call util#tab_to_space()<CR>

" Nobody uses 'Ex' mode and it is remapped to 'gq' in defaults.vim
" Spell check should never be enabled by default because of false positives
" Remap 'Ex' mode to toggling spell check
nnoremap <silent> Q :call util#toggle_spell()<CR>

" Clear trailing whitespace
nnoremap <silent> <Space>rs :%s/\s\+$//g<CR>

" open vimrc or init.vim in new tab
nnoremap <silent> <Space>v :tabedit $MYVIMRC<CR>
nnoremap <silent> <Space>gv :tabedit $MYGVIMRC<CR>

" use <Space>[hjkl] to move across buffers in same tab
nnoremap <Space>j <C-W><C-J>
nnoremap <Space>k <C-W><C-K>
nnoremap <Space>l <C-W><C-L>
nnoremap <Space>h <C-W><C-H>

let &cpoptions = s:cpoptions
unlet s:cpoptions
