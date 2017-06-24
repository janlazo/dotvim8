if has('win32')
  behave mswin
  set guifont=Consolas:h12:cANSI:qANTIALIASED
elseif has('unix') && !has('win32unix')
  behave xterm
endif

set guioptions=cegLRv     " guioption default: egmrLtT

if has('eval')
  let &columns = 81 + &numberwidth
endif
