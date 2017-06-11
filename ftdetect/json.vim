autocmd BufNewFile,BufRead *.json setfiletype json

" Javascript Linter Configs
autocmd BufNewFile,BufRead \.\=js[hl]intrc,\.\=eslintrc setfiletype json
autocmd BufNewFile,BufRead \.\=\(style\|css\)lintrc setfiletype json

" Package Management
autocmd BufNewFile,BufRead composer.lock setfiletype json
