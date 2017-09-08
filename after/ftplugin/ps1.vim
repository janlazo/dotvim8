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
let s:cpoptions = &cpoptions
set cpoptions&vim
setlocal keywordprg=

if !exists('*s:help')
  " Assume default values for all shell-related options
  " TODO - convert to an autoload function
  function <SID>help()
    if !executable('powershell')
      echom 'powershell is unavailable in PATH'
      return
    endif

    if has('win32')
      let clear = 'cls'
    else
      let clear = 'clear'
    endif

    let ps1_fmt = 'powershell -NoProfile -NoLogo -Command %s'
    let help_fmt = 'Get-Help %s | more'
    let help_cmd = printf(help_fmt, expand('<cword>'))
    " TODO - use fzf#shellescape and tempname
    let cmd = printf(ps1_fmt, shellescape(help_cmd))

    if has('nvim')
      execute ':terminal' cmd
      startinsert
    else
      if !has('gui_running')
        let cmd = clear . ' && ' . cmd
      endif

      execute ':silent !' cmd
      redraw!
    endif
  endfunction
endif

nnoremap <buffer> K :call <SID>help()<CR>
let &cpoptions = s:cpoptions
unlet s:cpoptions
