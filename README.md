# dotvim8

[![Build Status][Travis-Status]][Travis]

Vim 8+ / Neovim 0.2+ config folder for Windows support and async jobs.

- `shared.vim` for shared code between Vim and Neovim
    - backward compatibility up to Vim 7.2 (tiny) and Neovim 0.1.6
    - self-contained vimrc, independent of the entire repo
    - [vim-plug][gh-vim-plug] as package manager for bundles in Github
- `autoload/dotvim8.vim` resolves idiosyncrasies in Vim and Neovim, based on [fzf][gh-fzf]'s Vim plugin
    - `dotvim8#shellescape` is based on `fzf#shellescape`
    - `dotvim8#bang` is based on the `s:execute` functions
- `bin/install_deps.sh` to install external dependencies such as language providers for Neovim and [LSP](https://microsoft.github.io/language-server-protocol/) servers for coc.nvim
- `bin/nvim-qt.cmd` is a batchfile shim to workaround issues with [nvim-qt.exe][gh-nvim-qt] on Windows
    - HiDPI scaling (https://github.com/equalsraf/neovim-qt/commit/06967e0ce4da23ca0d973f8e313d3cb9149ff3f1)
    - window size (https://github.com/equalsraf/neovim-qt/issues/251#issuecomment-378936575)

Vimscript files in this repo use folds which slows down terminal Vim.
For performance, use GUIs when navigating or editing inside folds.

## Editor Support

- Vim 7.3+ to be compatible with most plugins in Github
- Neovim 0.2+ to use [fzf][gh-fzf] and async jobs in Windows
- gui: gvim, [nvim-qt][gh-nvim-qt]

## OS Support

- Linux
    - os: Ubuntu xenial, Debian stretch
    - terminal: sakura, tilda
- Windows
    - os: 7, 8.1, 10
    - terminal: ConEmu for truecolor (Neovim only)

## LICENSE

Apache License Version 2.0 (ALv2)

[gh-fzf]: https://github.com/junegunn/fzf
[gh-nvim-qt]: https://github.com/equalsraf/neovim-qt
[gh-vim-plug]: https://github.com/junegunn/vim-plug
[Travis]: https://travis-ci.org/janlazo/dotvim8
[Travis-Status]: https://travis-ci.org/janlazo/dotvim8.svg?branch=master
