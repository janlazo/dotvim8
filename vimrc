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

if 1
  " Disable defaults.vim
  let g:skip_defaults_vim = 1

  " unset 'compatible' in normal/huge versions
  if &compatible
    set nocompatible
  endif
endif

if has('win32')
  " Fix inconsistent slashes in each filepath
  let &runtimepath = join(map(split(&runtimepath, ','), 'expand(v:val)'), ',')

  " Force xterm rendering in ConEmu for truecolor
  if $ConEmuANSI ==# 'ON'
    if has('gui_running')
      " Vim (winpty) terminal inherits ConEmu env vars
      " This breaks terminal Vim in GVim
      let $ConEmuANSI = ''
    else
      if has('builtin_terms') && $ConEmuTask !~# 'Shells::cmd'
        set term=xterm
        set t_Co=256
        let &t_AB = "\e[48;5;%dm"
        let &t_AF = "\e[38;5;%dm"
      endif

      inoremap <Char-0x07F> <BS>
      nnoremap <Char-0x07F> <BS>
      vnoremap <Char-0x07F> <BS>

      if exists(':tnoremap') == 2
        tnoremap <Char-0x07F> <BS>
      endif
    endif
  endif

  if !empty($SHELL)
    set shell=cmd.exe shellcmdflag=/c shellredir=>%s\ 2>&1
    set shellxquote=( shellxescape&vim shellquote=
  endif
endif

if has('win32unix')
  if !empty($SHELL)
    set shell=sh shellredir=>%s\ 2>&1
  endif
endif

runtime shared.vim

if has('syntax')
  if v:version < 800
    " '%' jumps to begin/end pairs
    runtime! macros/matchit.vim
  endif
endif

if has('autocmd')
  call bundle#init()
endif
