if exists('g:loaded_plugin_conemu') ||
    \ has('gui_running') ||
    \ has('nvim') ||
    \ !has('win32') ||
    \ $ConEmuANSI !=# 'ON'
  finish
endif
let g:loaded_plugin_conemu = 1

set term=xterm
set t_Co=256
let &t_AB="\e[48;5;%dm"
let &t_AF="\e[38;5;%dm"

inoremap <Char-0x07F> <BS>
nnoremap <Char-0x07F> <BS>
vnoremap <Char-0x07F> <BS>
