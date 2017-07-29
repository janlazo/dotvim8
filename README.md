# dotvim8

[Travis] ![Build Status][Travis-Status]

Vim 8+ / Neovim 0.2+ config folder for Windows support and async jobs.

- `tiny.vim` to handle shared options and mappings
  - validate in vim 7+, mainly `vim-tiny`, in Ubuntu 16.04 and Windows 7
  - check features and options to avoid vimscript errors
  - acts as a self-contained vimrc, independent of the entire repo
- vimrc and init.vim are hooks to bootstrap the editor
  - neovim: language providers, inccommand
  - vim: `set nocompatible`, matchit plugin
- gvimrc and ginit.vim for GUI-specific configs (e.g. fonts, columns)
- [vim-plug] as package manager for bundles in Github
  - added my fork as subtree to resolve Windows issues

## Editor Support

- Vim 7.4+ to be compatible with most plugins in Github
  - prioritize Vim 8 builds that support true color in ConEmu
- Neovim 0.2.0 to use fzf and async jobs in Windows

## OS Support

- Ubuntu 14.04 for Vim 7.4+ but Ubuntu 16.04 takes priority
  - terminal: sakura
  - gui: gvim
- Windows 7, 8.1
  - terminal: ConEmu for truecolor via `set term=xterm`
  - gui: gvim, [neovim-qt]

## LICENSE

Apache License Version 2.0 (ALv2)

## TODO
- port core and filetype configs from [janlazo/dotvim]

[Travis]: https://travis-ci.org/janlazo/dotvim8
[Travis-Status]: https://travis-ci.org/janlazo/dotvim8.svg?branch=master
[vim-plug]: https://github.com/junegunn/vim-plug
[neovim-qt]: https://github.com/equalsraf/neovim-qt
[janlazo/dotvim]: https://github.com/janlazo/dotvim
