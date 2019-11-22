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
setlocal commentstring=//%s
setlocal suffixesadd+=.php suffixesadd+=.json

if has('patch-8.0.60')
  setlocal keywordprg=:BrowsePHP
endif

if get(g:, 'coc_enabled', 0) && filereadable('vendor/phan/phan/phan')
  call coc#config('languageserver', {
    \ 'phan': {
      \ 'command': 'php',
      \ 'args': [
        \ 'vendor/phan/phan/phan',
        \ '--allow-polyfill-parser',
        \ '--require-config-exists',
        \ '--language-server-on-stdin',
        \ '--language-server-hide-category'
      \ ],
      \ 'cwd': getcwd(),
      \ 'filetypes': ['php']
    \ }
  \ })
endif
