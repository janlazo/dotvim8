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
if has('autocmd')
  let s:globs = {
  \ 'bib': ['*.bibtex', '*.biblatex'],
  \ 'coffee': ['*.cson'],
  \ 'csv': ['*.csv'],
  \ 'dosini': ['.npmrc'],
  \ 'json': ['*.json', '.babelrc', '.bowerrc', 'composer.lock'],
  \ 'ruby': ['Vagrantfile'],
  \ 'pandoc': ['*.pandoc'],
  \ 'perl': ['cpanfile'],
  \ 'vue':   ['*.vue']
  \ }

  for s:list in items(s:globs)
    execute 'autocmd filetypedetect BufNewFile,BufRead' join(s:list[1], ',') 'setfiletype' s:list[0]
  endfor

  unlet s:globs s:list
endif
