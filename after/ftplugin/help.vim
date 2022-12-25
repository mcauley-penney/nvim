setlocal nolist
setlocal colorcolumn=
setlocal concealcursor=nc

if expand('%') =~# '^'.$VIMRUNTIME || &readonly
	autocmd BufWinEnter <buffer> wincmd J | resize 30
endif
