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
if has('win32')
  behave mswin
  set guifont=Consolas:h12:cANSI:qANTIALIASED

  if has('directx')
    set renderoptions=
  endif
elseif has('unix') && !has('win32unix')
  behave xterm
  set guifont=Monospace\ 12
endif

set guioptions=cegLRv     " guioption default: egmrLtT

if has('eval')
  let &columns = 81 + &numberwidth
endif
