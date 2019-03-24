NB. git

NB. =========================================================
gitcheck=: 3 : 0
0 < # 0 pick gitreadstatus''
)

NB. =========================================================
gitgui=: 3 : 0
if. 0 = #ProjectPath do. 0 return. end.
0 0$gitshell 'git gui &'
)

NB. =========================================================
gitreadstatus=: 3 : 0
if. IFUNIX *: 0 < #ProjectName do. '';'' return. end.
gitshell 'git status'
)

NB. =========================================================
gitshell=: 3 : 0
p=. dquote remsep ProjectPath
if. IFWIN do.
  shell_jtask_ 'cd "',p,'"',LF,y
else.
  unixshell 'cd "',p,'"',LF,y
end.
)

NB. =========================================================
gitstatus=: 3 : 0
if. 3=nc <'textview_z_' do.
  textview 0 pick gitreadstatus ''
end.
EMPTY
)

