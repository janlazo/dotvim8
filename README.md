# dotvim8

[Travis] ![Build Status][Travis-Status]

Vim 8+ / Neovim 0.2+ config folder for Windows support and async jobs.

- `shared.vim` to handle shared options and mappings
    - check features and options to avoid vimscript errors
    - acts as a self-contained vimrc, independent of the entire repo
    - assumes `set nocompatible` is set by Neovim or the user
    - [vim-plug] as package manager for bundles in Github
- vimrc and init.vim are hooks to bootstrap the editor
    - both
        - fix initial runtimepath (pathsep for Vim, revert to defaults for nvim-qt)
    - neovim
        - language providers (0.2 for python, 0.3 for ruby and node.js)
        - inccommand
    - vim
        - `set nocompatible`
            - tiny/small builds are compatible by default and don't support `+eval`
            - maintainers can use system-wide vimrc to include `set compatible`
            - system-wide vimrc cannot be skipped (no `g:loaded_system_vimrc`)
            - cannot alias `vim -Nu vimrc` with cmd.exe on Windows
        - disable defaults.vim
        - `guioptions` for gvim
- gvimrc and ginit.vim for GUIs (see `autoload/gui.vim`)
    - fonts
    - linespace
- [go-vimlparser] for linting Vimscript
- `autoload/dotvim8.vim` resolves idiosyncrasies in Vim and Neovim, based on fzf's Vim plugin
    - `dotvim8#shellescape` is based on `fzf#shellescape`
    - `dotvim8#bang` is based on the fzf's `s:execute` functions
- `bin/install_hosts.sh` to install language providers for neovim
- `bin/nvim-qt.cmd` is a batchfile shim to workaround issues with `nvim-qt.exe` on Windows
    - HiDPI scaling (https://github.com/equalsraf/neovim-qt/commit/06967e0ce4da23ca0d973f8e313d3cb9149ff3f1)
    - window size (https://github.com/equalsraf/neovim-qt/issues/251#issuecomment-378936575)

Vimscript files in this repo use folds which slows down terminal Vim.
For performance, use GUIs when navigating or editing inside folds.

## Editor Support

- Vim 7.3+ to be compatible with most plugins in Github
    - prioritize Vim 8 builds that support true color in ConEmu
- Neovim 0.2+ to use fzf and async jobs in Windows

`v:version` and patches are checked for backward compatibility up to Vim 7.2 and Neovim 0.1.6.

## OS Support

- Linux
    - distro: latest Ubuntu LTS (Xenial, 16.04), Debian Wheezy (7)
    - terminal: sakura
    - gui: gvim
- Windows 7, 8.1
    - terminal: ConEmu for truecolor via `set term=xterm`
    - gui: gvim, [neovim-qt]

## LICENSE

Apache License Version 2.0 (ALv2)

## TODO
- terminal config for Vim 8 and Neovim
- setup linting that works in Windows
    - ale?
    - `makeprg` and `errorformat` are unacceptable so `:compiler` is out
- make an async `:Grep`
    - `:grep` is blocking and `shellescape` for cmd.exe is insufficient for arbitrary text

[Travis]: https://travis-ci.org/janlazo/dotvim8
[Travis-Status]: https://travis-ci.org/janlazo/dotvim8.svg?branch=master
[vim-plug]: https://github.com/junegunn/vim-plug
[go-vimlparser]: https://github.com/haya14busa/go-vimlparser
[neovim-qt]: https://github.com/equalsraf/neovim-qt
[janlazo/dotvim]: https://github.com/janlazo/dotvim
[fzf]: https://github.com/junegunn/fzf
