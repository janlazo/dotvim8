#!/bin/sh
# Install all Neovim providers for remote plugins in rplugin/
# Required to intergrate other languages in Neovim
# ie. deoplete

# Python - https://github.com/neovim/python-client
pip2 install neovim
pip3 install neovim

# Ruby - https://github.com/alexgenco/neovim-ruby
# Require 0.6.2+ for Windows
gem install --conservative neovim

# Node - https://github.com/neovim/node-client
# Require 3.5.2+ for Windows
npm install -g neovim
