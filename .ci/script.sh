#!/bin/sh
set -eu
cd "$(dirname "$0")/.."

if command -v shellcheck > /dev/null 2>&1; then
  shellcheck -e SC2046 $(git ls-files '*.sh')
fi

vimlparser vimrc gvimrc $(git ls-files '*.vim' | grep -v plug.vim) > /dev/null

VIM_ARGS="-V2 -Es --cmd 'set rtp=$PWD,\$VIMRUNTIME,$PWD/after'"
if command -v vim.tiny > /dev/null 2>&1; then
  vim.tiny --version
  eval "vim.tiny $VIM_ARGS -u vimrc -c q"
fi
vim --version
eval "vim $VIM_ARGS -u vimrc -c 'autocmd VimEnter * quit'"
if command -v nvim > /dev/null 2>&1; then
  nvim --version
  eval "nvim $VIM_ARGS -u init.vim --cmd 'let &packpath = &rtp' -c 'autocmd VimEnter * quit'"
fi
