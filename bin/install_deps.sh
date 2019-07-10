#!/bin/sh
# Install language providers for Neovim 0.3+

# Python (https://github.com/neovim/python-client)
if command -v python3 > /dev/null 2>&1; then
  python3 -m pip install --user --disable-pip-version-check \
    pynvim
fi
if command -v python2 > /dev/null 2>&1; then
  python2 -m pip install --user --disable-pip-version-check \
    pynvim
fi

# Ruby (https://github.com/neovim/neovim-ruby)
# Need 0.6.2+ on Windows
if (command -v ruby && command -v gem) > /dev/null 2>&1; then
  gem install \
    --user-install --conservative --minimal-deps --no-suggestions \
    neovim solargraph
fi

# Javascript (https://github.com/neovim/node-client)
# Need 3.5.2+ on Windows
if (command -v node && command -v npm) > /dev/null 2>&1; then
  npm install -g \
    neovim dockerfile-language-server-nodejs
fi
