#!/bin/sh
# Install language providers for Neovim 0.3+

# Python (https://github.com/neovim/python-client)
if (command -v python3 && command -v pip3) > /dev/null 2>&1; then
  pip3 install --user pynvim
fi
if (command -v python2 && command -v pip2) > /dev/null 2>&1; then
  pip2 install --user pynvim
fi

# Ruby (https://github.com/neovim/neovim-ruby)
# Need 0.6.2+ on Windows
if (command -v ruby && command -v gem) > /dev/null 2>&1; then
  gem install --user-install --conservative --minimal-deps --no-suggestions neovim
fi

# Javascript (https://github.com/neovim/node-client)
# Need 3.5.2+ on Windows
if (command -v node && command -v npm) > /dev/null 2>&1; then
  npm install -g neovim
fi
