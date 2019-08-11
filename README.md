# dotvim8

[![Build Status][Travis-Status]][Travis]

Vim 8+ / Neovim 0.2+ config folder for Windows support and async jobs.

- `shared.vim` for shared code between Vim and Neovim
    - backward compatibility up to Vim 7.2 (tiny) and Neovim 0.1.6
    - self-contained vimrc, independent of the entire repo
    - [vim-plug] as package manager for bundles in Github
- `autoload/dotvim8.vim` resolves idiosyncrasies in Vim and Neovim, based on fzf's Vim plugin
    - `dotvim8#shellescape` is based on `fzf#shellescape`
    - `dotvim8#bang` is based on the fzf's `s:execute` functions
- `bin/install_deps.sh` to install external dependencies such as language providers for Neovim and [LSP](https://microsoft.github.io/language-server-protocol/) servers for coc.nvim
- `bin/nvim-qt.cmd` is a batchfile shim to workaround issues with `nvim-qt.exe` on Windows
    - HiDPI scaling (https://github.com/equalsraf/neovim-qt/commit/06967e0ce4da23ca0d973f8e313d3cb9149ff3f1)
    - window size (https://github.com/equalsraf/neovim-qt/issues/251#issuecomment-378936575)

Vimscript files in this repo use folds which slows down terminal Vim.
For performance, use GUIs when navigating or editing inside folds.

## Editor Support

- Vim 7.3+ to be compatible with most plugins in Github
- Neovim 0.2+ to use fzf and async jobs in Windows

## OS Support

- Linux
    - os: Ubuntu Xenial 16.04, Debian 7
    - terminal: sakura, tilda
    - gui: gvim
- Windows
    - os: 7, 8.1, 10
    - terminal: ConEmu for truecolor (Neovim only)
    - gui: gvim, [neovim-qt]

## LICENSE

Apache License Version 2.0 (ALv2)

## TODO
- terminal config for Vim 8 and Neovim
- make an async `:Grep`
    - `:grep` is blocking and `shellescape` for cmd.exe is insufficient for arbitrary text

[Travis]: https://travis-ci.org/janlazo/dotvim8
[Travis-Status]: https://travis-ci.org/janlazo/dotvim8.svg?branch=master
[vim-plug]: https://github.com/junegunn/vim-plug
[neovim-qt]: https://github.com/equalsraf/neovim-qt
[janlazo/dotvim]: https://github.com/janlazo/dotvim
[fzf]: https://github.com/junegunn/fzf
