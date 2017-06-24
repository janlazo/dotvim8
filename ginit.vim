let $MYGVIMRC = expand('<sfile>:p')

" neovim-qt
if exists(':GuiFont') == 2
  if has('win32')
    GuiFont Consolas:h12
  endif
endif
