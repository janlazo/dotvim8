#!/bin/sh
set -eu
cd "$(dirname "$0")/.."

if command -v shellcheck > /dev/null 2>&1; then
  shellcheck -e SC1090 -e SC2046 $(git ls-files '*.sh')
fi

VIM_ARGS="-V2 -i NONE -Es --cmd 'version' --cmd 'set rtp=$PWD,\$VIMRUNTIME,$PWD/after'"
if command -v vim.tiny > /dev/null 2>&1; then
  eval "vim.tiny $VIM_ARGS -u vimrc -c q"
fi
eval "vim $VIM_ARGS -u vimrc -c 'autocmd VimEnter * quit'"
if command -v nvim > /dev/null 2>&1; then
  eval "nvim $VIM_ARGS -u init.vim --cmd 'let &packpath = &rtp' -c 'autocmd VimEnter * quit'"
fi
