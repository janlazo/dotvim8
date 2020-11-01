#!/bin/sh
# Install language providers for Neovim 0.3+.
# Install LSP servers for coc.nvim.
set -eu

# Javascript (https://github.com/neovim/node-client)
# Need 3.5.2+ on Windows
if (command -v node && command -v npm) > /dev/null 2>&1; then
  npm install -g \
    neovim@4.5.0 dockerfile-language-server-nodejs
fi

# Python (https://github.com/neovim/python-client)
for py in python3 python; do
  if (command -v $py && $py -m pip --version) >/dev/null 2>&1; then
    $py -m pip install --user \
      pynvim flake8
    break
  fi
done

# Ruby (https://github.com/neovim/neovim-ruby)
# Need 0.9.0+ for rubyeval()
if (command -v ruby && command -v gem) > /dev/null 2>&1; then
  GEM_INSTALL="gem install --user-install --conservative --minimal-deps --no-document --no-suggestions"
  eval "$GEM_INSTALL solargraph"
  eval "$GEM_INSTALL --prerelease --version '> 0.8.1' neovim"
fi
