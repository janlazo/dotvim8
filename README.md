# dotvim8

[Travis] ![Build Status][Travis-Status]

Vim 8+ / Neovim 0.2+ config folder for Windows support and async jobs.

- `shared.vim` to handle shared options and mappings
    - validate in vim 7+, mainly `vim-tiny`, in Ubuntu 16.04 and Windows 7
    - check features and options to avoid vimscript errors
    - acts as a self-contained vimrc, independent of the entire repo
    - assumes `set nocompatible` is set by Vim/Neovim or the user
- vimrc and init.vim are hooks to bootstrap the editor
    - both:
        - fix initial runtimepath
        - load Vim packages
    - neovim:
        - language providers
        - inccommand
        - fix spell directory
    - vim:
        - `set nocompatible` for vim-tiny
        - set terminal options and fix mappings for ConEmu
        - matchit plugin (neovim loads this by default)
- gvimrc and ginit.vim for GUI-specific configs (e.g. fonts, columns)
- [vim-plug] as package manager for bundles in Github
    - added my fork as subtree to resolve Windows issues
- [go-vimlparser] for linting Vimscript
- [dotvim8.vim] resolves idiosyncrasies in Vim and Neovim

Vimscript files in this repo use folds which slows down terminal Vim.
For performance, use GUIs when navigating or editing inside folds.

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
- terminal config for Vim 8 and Neovim
  - mappings?
  - plugins?
- setup linting that works in Windows
  - ale?
  - makeprg + errorformat is out so compiler is out too
- improve deoplete for other filetypes
  - neco-syntax is too slow

[Travis]: https://travis-ci.org/janlazo/dotvim8
[Travis-Status]: https://travis-ci.org/janlazo/dotvim8.svg?branch=master
[vim-plug]: https://github.com/junegunn/vim-plug
[go-vimlparser]: https://github.com/haya14busa/go-vimlparser
[neovim-qt]: https://github.com/equalsraf/neovim-qt
[janlazo/dotvim]: https://github.com/janlazo/dotvim
[dotvim8.vim]: https://github.com/janlazo/dotvim8/blob/master/autoload/dotvim8.vim
