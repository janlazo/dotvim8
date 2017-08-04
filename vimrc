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
" unset 'compatible' in tiny/small versions (hack copied from defaults.vim)
silent! while 0
  set nocompatible
silent! endwhile

" unset 'compatible' in normal/huge versions
if 1
  if &compatible
    set nocompatible
  endif
endif

runtime tiny.vim

if has('syntax')
  " '%' jumps to begin/end pairs
  runtime! macros/matchit.vim
endif

if has('autocmd')
  call default#init()
endif
