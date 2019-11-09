NB. break
NB.%break.ijs - break utilities
NB.-This script defines break utilities and is included in the J standard library.
NB.-Definitions are loaded into the z locale.
NB.-
NB.-`setbreak 'default'` is done by profile for Jqt. JHS and jconsole can use ctrl+c. 
NB.-
NB.-setbreak creates file `~break/Pid.Class` and writes 0 to the first byte.
NB.-
NB.-Pid is the process id and Class is normally 'default'.
NB.-
NB.-setbreak calls 9!:47 with this file.
NB.-
NB.-9!:47 maps the first byte of file, and JE tests this byte for break requests.
NB.-
NB.-Another task writes 1 or 2 to the file for attention/break.
NB.-
NB.-9!:46 returns the filename.
NB.-
NB.-`break 'abc'` sets break for JEs with class abc.
NB.-
NB.-JEs with the same class all get the break. A non-default class protects JE from the default break.
NB.-
NB.- A new setbreak replaces the old.
NB.-
NB.-`break 0'` shows breakhelp

cocurrent'z'

NB. =========================================================
NB.*break v break J execution
NB. y is class to signal - '' treated as 'default'
break=: 3 : 0
if. y-:0 do. breakhelp_j_ return. end.
breakclean_j_''
p=. jpath'~break/'
fs=. ((<p),each{."1[1!:0 p,'*')-.<9!:46''
pc=. (>:;fs i:each'/')}.each fs
i=. ;pc i.each'.'
pids=. _1".each i{.each pc
classes=. (>:i)}.each pc
if. y-:1 do. /:~(>":each pids),.>' ',each classes return. end.
'no task to break'assert #fs
if. (0=#y)+.2=3!:0 y do.
  b=. classes= (0=#y){y;'default'
  'bad class'assert +/b
  fs=. (<p),each (":each b#pids),each '.',each b#classes
else.
  i=. pids i.<y
  'bad pid'assert i~:#pids
  fs=. <p,(":;i{pids),'.',;i{classes
end.
for_f. fs do.
  v=. 2<.>:a.i.1!:11 f,<0 1
  (v{a.) 1!:12 f,<0
end.
i.0 0
)

NB. =========================================================
NB.*setbreak v set break file
NB.-Set break
NB. y is class
NB. Creates unique file ~break/Pid.Class
setbreak=: 3 : 0
if. (-.IFQT)*.y-:'default' do. i.0 0 return. end. NB. only for qt and not default
try.
  assert #y
  q=. jpath '~break/'
  1!:5 ::] <q
  f=. q,(":2!:6''),'.',y
  ({.a.) 1!:12 f;0
  9!:47 f
  breakclean_j_''
  f
catch. 13!:12'' end.
)

NB. =========================================================
NB.*breakclean v erase orphan break files
breakclean_j_=: 3 : 0
q=. jpath '~break/'
fs=. ((<q),each{."1[1!:0 q,'*')-.9!:46''
if. UNAME-:'Win' do.
  ferase fs NB. windows erase has not effect while file is in use
else.
  d=. dltb each}.<;._2 spawn_jtask_'ps -e'
  allpids=. ;0".each (d i.each ' '){.each d
  pc=. (>:;fs i:each'/')}.each fs
  pids=. ;_1".each (;pc i.each'.'){.each pc
  ferase (-.pids e. allpids)#fs
end.
)

NB. =========================================================
NB.*breakhelp n break help
breakhelp_j_=: 0 : 0
   break 0     NB. help
   break 1     NB. list other ~break pids and classes
   break ''    NB. break to all default class tasks
   break '...' NB. break to all ... class tasks
   break pid   NB. break to that pid

1st break stops execution at line start
2nd break stops execution mid-line, 6!:3 , socket select

profile does setbreak'default' for Jqt
profile does not do it for jconsole or JHS (use ctrl+c)

   setbreak'abc' NB. set break file for this pid and class abc

https://code.jsoftware.com/wiki/Standard_Library/break
)
