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
editor=. (Editor_j_;Editor_nox_j_){::~ nox=. (UNAME-:'Linux') *. (0;'') e.~ <2!:5 'DISPLAY'
if. 0=#editor do. EMPTY return. end.
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
      2!:1 cmd, (0=nox+.(1 -.@e. 'term' E. editor)*.(1 e. '/vi' E. editor)+.'vi'-:2{.editor)#' &'
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

