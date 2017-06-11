if exists('g:loaded_autoload_util')
  finish
endif
let g:loaded_autoload_util = 1


function! util#tab_to_space() abort
  set expandtab
  retab
endfunction


function! util#space_to_tab() abort
  set noexpandtab
  retab!
endfunction
