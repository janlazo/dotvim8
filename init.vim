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
if has('nvim-0.2')
  set inccommand=nosplit

  let s:hosts = {
  \ 'python':  'python2.exe',
  \ 'python3': 'python3.exe'
  \ }
  for [s:key, s:val] in items(s:hosts)
    let s:val = exepath(s:val)
    if !empty(s:val)
      let g:[s:key . '_host_prog'] = s:val
    endif
  endfor
  unlet s:hosts s:key s:val
else
  let g:loaded_python_provider = 1
  let g:loaded_python3_provider = 1
endif

if has('nvim-0.3')
  if has('win32') && $TERM =~# 'cygwin' && executable('cygpath.exe')
    let s:msys_root = get(split(system('cygpath.exe -w /'), "\n"), 0, '')
    if isdirectory(s:msys_root)
      let s:terminfo = s:msys_root.'usr\share\terminfo'
      if empty($TERMINFO) && isdirectory(s:terminfo)
        let $TERMINFO = s:terminfo
      endif
      unlet s:terminfo
    endif
    unlet s:msys_root
  endif

  " Required for remote plugins (ie. deoplete) in rplugin/
  function! s:install_hosts()
    let cmds = []

    " https://github.com/neovim/python-client
    for pip in ['pip2', 'pip3']
      if executable(pip)
        call add(cmds, pip . ' install --user neovim')
      endif
    endfor

    " https://github.com/alexgenco/neovim-ruby
    " Need 0.6.2+ on Windows
    if executable('gem')
      call add(cmds, (has('win32') ? 'cmd.exe /c ' : '').'gem install --conservative neovim')
    endif

    " https://github.com/neovim/node-client
    " Need 3.5.2+ on Windows
    if executable('npm')
      call add(cmds, (has('win32') ? 'cmd.exe /c ' : '').'npm install -g neovim')
    endif

    if empty(cmds)
      echoerr 'No hosts to update'
      return
    endif

    " Write all commands in a temporary script and run it on the terminal
    let term_opts = {'script': tempname()}
    if has('win32')
      let term_opts.script .= '.bat'
    endif
    call writefile(cmds, term_opts.script)
    function! term_opts.on_exit(id, data, event) dict
      call delete(self.script)
    endfunction
    enew
    call termopen(term_opts.script, term_opts)
    startinsert
  endfunction
  command! InstallRemoteHosts call s:install_hosts()
else
  let g:loaded_node_provider = 1
  let g:loaded_ruby_provider = 1

  if has('win32')
    set runtimepath&vim
  endif
endif

runtime shared.vim
