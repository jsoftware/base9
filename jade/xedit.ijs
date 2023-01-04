NB. xedit - external editor

NB. =========================================================
NB. xedit
NB.
NB.*xedit v load file in external editor
NB. syntax:
NB.   [x] xedit file [ ; row ]   (row is optional and is 0-based)
NB.   x (default 0) 1: wait
xedit=: 0&$: : (4 : 0)
'file row'=. 2{.(boxopen y),<0
file=. dltb file
if. -.fexist file do. EMPTY return. end.
if. IFJHS do.         NB. open on client side
  xmr ::0: file
  EMPTY return.
end.
if. UNAME-:'Android' do.
  if. IFJA do.
    android_exec_host 'android.intent.action.VIEW';(utf8 ('file://'&,)@abspath^:(-.@isURL) file);'text/plain';0
  elseif. 1=ftype '/system/bin/vi' do.
    2!:1 '/system/bin/vi', ' ', (dquote >@fboxname file)
  elseif. 1=ftype '/system/xbin/vi' do.
    2!:1 '/system/xbin/vi', ' ', (dquote >@fboxname file)
  elseif. #Editor_j_ do.
    2!:1 Editor_j_, ' ', (dquote >@fboxname file)
  end.
  EMPTY return.
end.
editor=. (Editor_j_;Editor_nox_j_){::~ nox=. ((<UNAME)e.'Linux';'OpenBSD';'FreeBSD') *. (0;'') e.~ <2!:5 'DISPLAY'
if. 0=#editor do. EMPTY return. end.
nox=. ((<UNAME)e.'Linux';'OpenBSD';'FreeBSD') *. (0;'') e.~ <2!:5 'DISPLAY'
if. ((<UNAME)e.'Linux';'OpenBSD';'FreeBSD')>nox do.
  if. 1 e. r=. 'term' E. editor do.
    if. '-e ' -: 3{. editor=. dlb (}.~ i.&' ') ({.I.r)}.editor do.
      editor=. TermEmu, (('gnome-terminal'-:TermEmu){::' -e ';' -- '), dlb 3}.editor
    else.
      editor=. TermEmu, ' ', editor
    end.
  else.
    editor=. TermEmu, (('gnome-terminal'-:TermEmu){::' -e ';' -- '), editor
  end.
end.
if. 1 e. '%f' E. editor do.
  cmd=. editor stringreplace~ '%f';(dquote >@fboxname file);'%l';(":>:row)
else.
  cmd=. editor, ' ', (dquote >@fboxname file)
end.
try.
  if. IFUNIX do.
    if. x do.
      2!:1 cmd
    else.
NB. vi needs terminal for working
NB. ok if terminal is provided as in 'x-terminal-emulator -e vi ... '
      2!:1 cmd, (0=nox)#' 1>/dev/null &'
    end.
  else.
    (x{0 _1) fork_jtask_ cmd
  end.
catch.
  msg=. '|Could not run the editor:',cmd,LF
  msg=. msg,'|You can change the Editor definition in Edit|Configure|Base'
  smoutput msg
end.
EMPTY
)

linux_terminal=: <;._2]0 :0
x-terminal-emulator
gnome-terminal
mate-terminal
konsole
urxvt
rxvt
lxterminal
xfce4-terminal
eterm
terminator
terminology
st
xterm
)

NB. =========================================================
NB. dflttermemu ''
NB.     return default TermEmu, or ''
dflttermemu=: verb define
nox=. ((<UNAME)e.'Linux';'OpenBSD';'FreeBSD') *. (0;'') e.~ <2!:5 'DISPLAY'
if. (((<UNAME)e.'Linux';'OpenBSD';'FreeBSD') > nox) *. ''-: te=. nox{::TermEmu_j_;TermEmu_nox_j_ do.
  for_t. linux_terminal do.
    try. 2!:0'which ',(>t),' 2>/dev/null'
      te=. >t
      break.
    catch. end.
  end.
end.
te
)
