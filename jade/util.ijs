NB. util

Alpha=: a. {~ , (a.i.'Aa') +/ i.26
Num=: a. {~ (a.i.'0') + i.10
AlphaNum=: Alpha,Num
Boxes=: ((16+i.11) { a.),:'+++++++++|-'
ScriptExt=: '.ijs'
ProjExt=: '.jproj'

extnone=: {.~ i:&'.'
extproj=: , (ProjExt #~ '.'&e. < 0 < #)
extsrc=: , ('.ijs' #~ '.'&e. < 0 < #)

addfname=: , ('/' ~: {:) # i:&'/' }. ]
boxdraw=: 3 : '9!:7 y { Boxes'
hostcmd=: [: 2!:0 '(' , ,&' || true)'
fpath=: [: }: +./\.@:=&'/' # ]
isURL=: 1 e. '://'&E.
maxrecent=: 3 : '(RecentMax <. #r) {. r=. ~.y'
pack=: [: (,. ".&.>) ;: ::]
pdef=: 3 : '0 0$({."1 y)=: {:"1 y'
seldir=: #~ '-d'&-:"1 @ (1 4&{"1) @ > @ (4&{"1)
spath=: #~ [: *./\. '/'&~:
termLF=: , (0 < #) # LF -. {:
termsep=: , (0 < #) # '/' -. {:
remsep=: }.~ [: - '/' = {:

path2proj=: ,'/',ProjExt ,~ spath

NB. =========================================================
NB. lower case except in case-sensitive drive or folder
win2lower=: 3 : 0
if. 0=#CasePaths_j_ do. tolower y return. end.
p=. jpathsep y
n=. 1 + p i. ':'
d=. n {. p
if. (<d) e. CasePaths_j_ do. y return. end.
b=. n }. p
p=. d,(('/'~:{.b)#'/'), b,'/'
p=. (1 + p i: '/') {. p
p=. (I.p='/') {.each <p
if. 1 e. p e. CasePaths_j_ do. y else. tolower y end.
)

NB. =========================================================
NB. platform-dependant
3 : 0''
if. UNAME-:'Darwin' do.
  filecase=: tolower`]@.IFIOS
  isroot=: '/' = {.
elseif. IFUNIX do.
  filecase=: ]
  isroot=: '/' = {.
elseif. do.
  filecase=: win2lower
  isroot=: ('\\' -: 2&{.) +. ('//' -: 2&{.) +. (':' = {.@}.)
end.
0
)

NB. =========================================================
NB. dirtreex v get full directory trees
NB. directory search is recursive through subdirectories
NB. argument and results have full pathnames
NB. argument is not in result if it ends in a path separator
NB. optional x is a filter string
dirtreex=: 3 : 0
'' dirtreex y
:
y=. jpath y
p=. (+./\. y = '/') # y
d=. 1!:0 y,('/' = {:y) # '*'
if. 0 = #d do. '' return. end.
a=. > 4 {"1 d
m=. 'd' = 4 {"1 a
f=. (<p) ,each {."1 d
if. 1 e. m do.
  f=. f, ; dirtreex each (m#f) ,each <'/','*'
end.
if. #x do.
  f #~ (1 e. x E. ])&> f
end.
)

NB. =========================================================
NB. get folder tree + ids from folder path (full name)
getfolderdefs=: 3 : 0
p=. (, '/' , ProjExt ,~ spath) each subdirtree y
t=. p #~ #@(1!:0)&> p
NB. t;<fsname each (1+#y) }. each (-#ProjExt) }. each t
t;<fpath each (1+#y) }. each (-#ProjExt) }. each t
)

NB. =========================================================
isconfigfile=: 3 : 0
'p f'=. fpathname y
x=. f i: '.'
(p -: jpath '~config/') *. '.cfg'-:x}.f
)

NB. =========================================================
isdir=: 3 : 0
d=. 1!:0 fboxname y
if. 1 ~: #d do. 0 return. end.
'd' = 4 { 4 pick ,d
)

NB. =========================================================
isfile=: 3 : 0
d=. 1!:0 fboxname y
if. 1 ~: #d do. 0 return. end.
'd' ~: 4 { 4 pick ,d
)

NB. =========================================================
istempname=: 3 : 0
x=. y i: '.'
*./ ('.ijs'-:x}.y),(x{.y) e. Num
)

NB. =========================================================
istempscript=: 3 : 0
'p f'=. fpathname y
(p -: jpath '~temp/') *. istempname f
)

NB. =========================================================
NB.*jshowconsole v show/hide console in windows
jshowconsole=: 3 : 0
if. -.IFWIN do. 'only supported in windows' return. end.
t=. {.>'kernel32.dll GetConsoleWindow x'cd''
'user32.dll ShowWindow n x i'cd t;(0-:y){5 0
i.0 0
)

NB. =========================================================
NB. make directory, return success
mkdir=: 3 : 0
a=. termsep jpath y
if. #1!:0 }:a do. 1 return. end.
for_n. I. a='/' do.
  1!:5 :: 0: < n{.a
end.
)

NB. =========================================================
newtempscript=: 3 : 0
x=. ScriptExt
p=. jpath '~temp/'
d=. 1!:0 p,'*',x
a=. (-#x) }. each {."1 d
a=. a #~ (*./ .e.&'0123456789') &> a
a=. 0, {.@:(0&".) &> a
p, x ,~ ": {. (i. >: #a) -. a
)

NB. =========================================================
nounrep=: 2 }. [: ; [: nounrep1 each ;:
nounrep1=: LF2 , ] , '=: ' , [: nounrep2 ".
nounrep2=: 3 : 0
if. 0 = #y do. '''''' return. end.
select. 3!:0 y
fcase. 32 do.
  y=. ; y ,each LF
case. 2 do.
  if. LF e. y do.
    y=. y, LF -. {:y
    '0 : 0', LF, ; <;.2 y,')'
  else.
    quote y
  end.
case. do.
  ": y
end.
)

NB. =========================================================
octal=: 3 : 0
t=. ,y
if. LF e. t do.
  t=. octal each <;._2 t,LF
  }: ; t ,each LF return.
end.
u=. isutf8 t
x=. a. i. t
m=. (x e. 9 13) < x < 32
if. u > 1 e. m do. t return. end.
n=. I. m=. m +. u < x > 126
s=. '\',.}.1 ": 8 (#.^:_1) 255,n{x
s ((n+3*i.#n)+/i.4)} (>:3*m)#t
)

NB. =========================================================
NB. vno;vst;architecture;OS;license;builder;date;compiler;<[otheroptions]
NB. vno is 100 #. major;minor;revision;subrevision
NB. vst is in form: '9.6.0-beta11' or '9.6.1'
revinfo=: 3 : 0
v=. 9!:14''
if. '.' e. (v i. '/') {. v do.
  res=. 8 {. <;._1 '/',v
  a=. 0 pick res
  ndx=. a i. '-'
  beta=. {. 0 ". (ndx+5) }. a
  vno=. 100 #. (0 ".&> <;._1 '.' 0} ndx {. a), beta
  vno;res
else.
  res=. 9 {. <;._1 '/',v
  'a b'=. 0 3 { res
  res=. (<<<0 3) {res
  res=. (('www.jsoftware.com' -: 3 pick res){'na';'GPL3') 2} res
  'm n'=. ": each ver=. 0 100 #: 0 ". }. a
  num=. _97 + a.i. {:b
  if. 'r' = {. b do.
    rev=. (num+1),0
    vst=. 'j',m,'.',n,'.',":num+1
  else.
    rev=. 0,num
    vst=. 'j',m,'.',n,'.0-beta',":num
  end.
  (100 #.ver,rev);vst;res
end.
)

NB. =========================================================
NB. remove single directory
NB. return: rc;msg
NB. rc=0 success, 1=fail
rmdir=: 3 : 0
r=. 1;'not a directory: ',":y
if. 0=#y do. r return. end.
d=. 1!:0 y
if. 1 ~: #d do. r return. end.
if. 'd' ~: 4 { 4 pick {. d do. r return. end.
if. IFWIN do.
  shell_jtask_ 'rmdir "',y,'" /S /Q'
else.
  hostcmd_j_ 'rm -rf ',((UNAME-:'Linux')#'--preserve-root '),y
end.
(#1!:0 y);''
)

NB. =========================================================
runimmx0_j_=: 3 : 0
IMMX_j_=: utf8 y
9!:27 '0!:100 IMMX_j_'
9!:29 [ 1
)

NB. =========================================================
runimmx1_j_=: 3 : 0
IMMX_j_=: utf8 y
9!:27 '0!:101 IMMX_j_'
9!:29 [ 1
)

NB. =========================================================
NB. scripts
scripts=: 3 : 0
NB.   scripts ''       short directory
NB.   scripts 'v'      verbose directory
if. 0=#y do.
  list 0{"1 Public
elseif. 'v'e.y do.
  dir=. Public
  a=. >0{"1 dir
  b=. >1{"1 dir
  a /:~ a,.' ',.b
elseif. 1 do.
  'invalid argument to scripts: ',,":y
end.
)

NB. =========================================================
NB. set project folder and related globals
NB. y must be a userfolder
setfolder=: 3 : 0
if. 0=#y do.
  Folder=: FolderTree=: FolderIds=: '' return.
end.
assert. (<y) e. {."1 UserFolders
Folder=: y
'FolderTree FolderIds'=: getfolderdefs jpath '~',y
if. 3=nc <'snapshot_tree_jp_' do.
  snapshot_tree_jp_ FolderTree
end.
EMPTY
)

NB. =========================================================
NB. subdirtree
NB. return subdirectory tree from top level directory
NB. ignore hidden files
NB. y should not end in term separator
subdirtree=: 3 : 0
if. 0=#1!:0 y do. '' return. end.
r=. ''
dir=. <y,'/'
while. #dir do.
  fpath=. (>{.dir) &,
  dir=. }.dir
  dat=. seldir 1!:0 fpath '*'
  if. #dat do.
    dat=. fpath each {."1 dat
    r=. r,dat
    dir=. (dat ,each '/'),dir
  end.
end.
sort filecase each r
)

NB. =========================================================
NB. unixshell v return result;error msg
unixshell=: 3 : 0
f=. jpath '~temp/shell.sh'
t=. jpath '~temp/shell.txt'
e=. jpath '~temp/shell.err'
('#!/bin/sh',LF,y,LF) fwrite f
'rwx------' 1!:7 <f
hostcmd '"',f,'" > "',t,'" 2> "',e,'"'
r=. (fread t);fread e
ferase f;t;e
r
)

NB. =========================================================
NB. unixshellx v do shell cmd, display any error
unixshellx=: 3 : 0
'res err'=. unixshell y
if. #err do.
  smoutput 'Shell command error: ',LF,LF,err
end.
res
)

NB. =========================================================
NB. browseref v open j dictionary in browser
browseref=: 3 : 0
htmlhelp 'dictionary/',y
)
