# dotvim8

Vim 8+ / Neovim 0.2+ config folder for Windows support and async jobs.

- `tiny.vim` to handle shared options and mappings
  - validate in vim 7+, mainly `vim-tiny`, in Ubuntu 16.04 and Windows 7
  - check features and options to avoid vimscript errors
  - acts as a self-contained vimrc, independent of the entire repo
- `vimrc/init.vim` to handle editor-specific general configs (e.g. language providers in neovim, vim-tiny, `set nocompatible`)
- `gvimrc/ginit.vim` for GUI-specific configs (e.g. fonts, columns)

## Editor Support

- Vim 7.4+ to be compatible with most plugins in Github
  - prioritize Vim 8 builds that support true color in ConEmu
- Neovim 0.2.0 to use fzf and async jobs in Windows

## OS Support

- Ubuntu 14.04 for Vim 7.4+ but Ubuntu 16.04 takes priority
  - terminal: sakura
- Windows 7, 8.1
  - terminal: ConEmu

## LICENSE

Apache License Version 2.0 (ALv2)

## TODO
- `default#init()` for common bundles via vim package manager (e.g. plug, dein)
  - submodules affect the history and require recent versions of Git to be user-friendly
