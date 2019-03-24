NB. standard breaker script
NB.
NB. run as a console app to signal break to a J process.
NB.
NB. copy and customize this for specific J applications.
NB.
NB. examples:
NB.
NB. default class:
NB.   ~bin/jconsole.exe -jprofile breaker.ijs
NB.
NB. genie class:
NB.   ~bin/jconsole.exe -jprofile breaker.ijs genie

NB. =========================================================
NB. break is signalled to all J processes in a class.
NB. the class default is 'default', but may be set as the last
NB. parameter of the command line.
CLASS=: 3 : 0 ''
cls=. > {: 4 {. ARGV
if. 0 = #cls do. 'default' end.
)

NB. =========================================================
NB. get break path:
PATH=: 3 : 0 ''
NB. unix:
if. 5 = 9!:12'' do.
  '/',~'/tmp/j-',":2!:5 'USER'
NB. windows:
else.
  fn=. >2{'kernel32 GetTempPathW i i *w' (15!:0) 256;256$' '
  fn=. >2{'kernel32 GetLongPathNameW i *w *w i' (15!:0) fn;(256$u:' ');256
  8&u: 'j\',~(fn i: {.a.){.fn
end.
)

NB. =========================================================
NB. all files to break
FILES=: (<PATH),&.> {."1[1!:0<PATH,'*.',CLASS

NB. =========================================================
NB. do break
3 : 0 ''
for_f. FILES do.
  v=. 2<.>:a.i.1!:11 f,<0 1
  (v{a.) 1!:12 f,<0
  if. 6=9!:12'' do. try. 1!:55 f catch. end. end. NB. delete windows orphans
end.
)

2!:55''
