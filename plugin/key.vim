if exists('g:loaded_plugin_key')
	finish
endif
let g:loaded_plugin_key = 1

nnoremap <silent> <Space>st :call util#space_to_tab()<CR>
nnoremap <silent> <Space>ts :call util#tab_to_space()<CR>

" Clear trailing whitespace
nnoremap <silent> <Space>rs :%s/\s\+$//g<CR>

" open vimrc or init.vim in new tab
nnoremap <silent> <Space>v :tabedit $MYVIMRC<CR>

" open directory via netrw
nnoremap <silent> - :Explore<CR>
nnoremap <silent> <Space>o :exec ':Explore' getcwd()<CR>

" use <Space>[hjkl] to move across buffers in same tab
nnoremap <Space>j <C-W><C-J>
nnoremap <Space>k <C-W><C-K>
nnoremap <Space>l <C-W><C-L>
nnoremap <Space>h <C-W><C-H>

" Escape Insert/Visual Mode via Alt/Meta + [hjkl]
" Neovim - use normal keybinds
" Vim    - use utf-8 characters via scriptencoding
if has('nvim')
  inoremap <silent> <M-h> <Esc>hl
  vnoremap <silent> <M-h> <Esc>hl

  inoremap <silent> <M-j> <Esc>jl
  vnoremap <silent> <M-j> <Esc>jl

  inoremap <silent> <M-k> <Esc>kl
  vnoremap <silent> <M-k> <Esc>kl

  inoremap <silent> <M-l> <Esc>ll
  vnoremap <silent> <M-l> <Esc>ll
elseif has('multi_byte') &&
        \ has('multi_byte_encoding') &&
        \ (has('win32') || has('gui_running'))
  scriptencoding utf-8
  inoremap <silent> è <Esc>hl
  vnoremap <silent> è <Esc>hl

  inoremap <silent> ê <Esc>jl
  vnoremap <silent> ê <Esc>jl

  inoremap <silent> ë <Esc>kl
  vnoremap <silent> ë <Esc>kl

  inoremap <silent> ì <Esc>ll
  vnoremap <silent> ì <Esc>ll
  scriptencoding
endif
