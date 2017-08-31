#!/bin/sh
# Install all Neovim providers for remote plugins in rplugin/
# Required to intergrate other languages in Neovim
# ie. deoplete

# Python - https://github.com/neovim/python-client
pip2 install neovim
pip3 install neovim

# Ruby - https://github.com/alexgenco/neovim-ruby
gem install --conservative neovim
