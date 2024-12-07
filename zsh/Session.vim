let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
let Bufferline__session_restore = "lua require('barbar.state').restore_buffers { { name = \"TODO.md\", pinned = true }, { name = \".zshrc\", pinned = true }, { name = \"src/tab_completion.zsh\" }, { name = \"functions/fn_find_vim_sessions\" }, { name = \"src/vi_bindings.zsh\" }, { name = \"src/auto_cmds.zsh\" } }"
let NvimTreeSetup =  1 
let NvimTreeRequired =  1 
silent only
silent tabonly
cd ~/.config/zsh
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +19 ~/.config/zsh/.zshrc
badd +570 src/vi_bindings.zsh
badd +12 TODO.md
badd +53 ~/.config/zsh/src/tab_completion.zsh
badd +14 ~/.config/zsh/src/auto_cmds.zsh
badd +8 functions/fn_find_vim_sessions
argglobal
%argdel
edit TODO.md
argglobal
balt ~/.config/zsh/.zshrc
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let &fdl = &fdl
let s:l = 19 - ((18 * winheight(0) + 43) / 87)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 19
normal! 0
tabnext 1
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0 && getbufvar(s:wipebuf, '&buftype') isnot# 'terminal'
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20
let &shortmess = s:shortmess_save
let s:sx = expand("<sfile>:p:r")."x.vim"
if filereadable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &g:so = s:so_save | let &g:siso = s:siso_save
set hlsearch
nohlsearch
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
