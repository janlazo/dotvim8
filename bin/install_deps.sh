#!/bin/sh
# Install language providers for Neovim 0.3+.
# Install LSP servers for coc.nvim.
set -eu

# Javascript (https://github.com/neovim/node-client)
# Assume that nvm or nvs are installed to avoid 'sudo'.
if (command -v node && command -v npm) > /dev/null 2>&1; then
  npm install -g \
    neovim dockerfile-language-server-nodejs
fi

# Python (https://github.com/neovim/python-client)
# Assume that pyenv is installed to avoid 'sudo'.
for py in python3 python; do
  if (command -v $py &&
      $py -c 'import sys; assert sys.version_info[0] > 2' &&
      $py -m pip --version) >/dev/null 2>&1; then
    $py -m pip install \
      pynvim flake8
    break
  fi
done

# Ruby (https://github.com/neovim/neovim-ruby)
# Assume that chruby and ruby-install are installed to avoid 'sudo'.
if (command -v ruby && command -v gem) > /dev/null 2>&1; then
  GEM_INSTALL="gem install --conservative --minimal-deps --no-document --no-suggestions"
  eval "$GEM_INSTALL solargraph"
  eval "$GEM_INSTALL --prerelease --version '> 0.8.1' neovim"
fi

# Perl (https://github.com/jacquesg/p5-Neovim-Ext)
# Assume that perl uses local::lib to avoid 'sudo'.
if (command -v perl &&
    command -v cpanm &&
    perl -e 'use v5.22') > /dev/null 2>&1; then
  cpanm -n Neovim::Ext
fi
