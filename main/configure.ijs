NB. dummy configure

18!:4 <'j'

setjdefs=: 4 : 'if. _1=4!:0 y do. (>y)=: x end.'

1 setjdefs"_ 0 <;._2 [ 0 : 0
RGBSEQ
)

(0 2$<'') setjdefs"_ 0 <;._2 [ 0 : 0
SystemFolders
UserFolders
)

3 : 0''
if. (<'bin') -.@e. {."1 SystemFolders do.
  SystemFolders=: SystemFolders, 'bin';BINPATH
end.

if. (<'home') -.@e. {."1 SystemFolders do.
  if. 'Win'-:UNAME do. t=. 2!:5'USERPROFILE'
  elseif. 'Android'-:UNAME do. t=. '/sdcard'
  elseif. 'Darwin'-:UNAME do. t=. (0-:t){::'';~t=. 2!:5'HOME'
  elseif. 'Linux'-:UNAME do. t=. (0-:t){::'';~t=. 2!:5'HOME'
  elseif. do. t=. ''
  end.
  if. (''-:t)+.((,'/')-:t)+.('/root'-:t)+.('/usr/'-:5{.t) do.
    t=. '/tmp/',":2!:6''
    1!:5 ::] <t
  end.
  SystemFolders=: SystemFolders, 'home';t
end.

if. (<'temp') -.@e. {."1 SystemFolders do.
  if. 'Win'-:UNAME do. 1!:5 ::] <t=. (2!:5'USERPROFILE'),'\Temp'
  elseif. 'Android'-:UNAME do. t=. '/sdcard'
  elseif. 'Darwin'-:UNAME do. 1!:5 ::] <t=. '/tmp/',":2!:6''
  elseif. 'Linux'-:UNAME do. 1!:5 ::] <t=. '/tmp/',":2!:6''
  elseif. do. t=. ''
  end.
  SystemFolders=: SystemFolders, 'temp';t
end.
''
)

4!:55 <'setjdefs'

18!:4 <'z'
