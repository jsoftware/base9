cocurrent'z'

break=: 3 : 0
breakclean_j_''
if. y-:0 do. breakhelp_j_ return. end.
p=. jpath'~break/'
fs=.  ((<p),each{."1[1!:0 p,'*')-.<9!:46''
pc=. (>:;fs i:each'/')}.each fs
i=. ;pc i.each'.'
pids=. _1".each i{.each pc
classes=. (>:i)}.each pc
if. y-:1 do. /:~(>":each pids),.>' ',each classes  return. end.
'no task to break'assert #fs
if. 2=3!:0 y do.
 b=. classes=    (''-:y){y;'default'
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

NB. set first or new ~break file and delete unused ~break files
setbreak=: 3 : 0
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

breakhelp_j_=: 0 : 0
   break 0     NB. help
   break 1     NB. list other ~break pids and classes
   break ''    NB. break to all default class tasks
   break '...' NB. break to all ... class tasks
   break pid   NB. break to that pid
 
1st break stops execution at line start
2nd break stops execution mid-line, 6!:3 , socket select 

   setbreak'default' NB. task start creates pid.default file in ~break
   setbreak'...'     NB. change break file class
)

breakclean_j_=: 3 : 0
 q=. jpath '~break/'
 fs=. (<q),each{."1[1!:0 q,'*'
 if. UNAME-:'Win' do.
  ferase fs
 else.
  p=. (fs i:each '.'){.each fs
  p=. (>:;p i:each'/')}.each p
  for_i. i.#fs do.
   try. spawn_jtask_ 'lsof -p ',(;i{p) ,' "',(;i{fs),'"'
   catch. ferase i{fs end.
  end.
 end.
)

