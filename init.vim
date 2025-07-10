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
set cpoptions-=_
set inccommand=nosplit
set pumblend=30

if has('nvim-0.7')
  set laststatus=3
endif

if has('nvim-0.10')
  set complete+=f
endif

runtime shared.vim

augroup init_vim
  autocmd!
  if has('nvim-0.5')
    autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=500, on_visual=true}
  endif
augroup END
