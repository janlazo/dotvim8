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
runtime tiny.vim

if has('win32')
  let g:loaded_netrw = 1
  let g:loaded_netrwPlugin = 1

  if !has('nvim-0.2')
    let g:loaded_python_provider = 1
    let g:loaded_python3_provider = 1
    let g:loaded_ruby_provider = 1
  endif
endif

if has('nvim-0.2')
  set inccommand=nosplit
endif

if has('gui_running') && exists('g:nyaovim_version')
  set mouse=a
endif

call default#init()
colorscheme torte
