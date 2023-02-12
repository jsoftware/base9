NB. util

CFGFILES=: <;._2 (0 : 0)
addons.txt
library.txt
release.txt
revision.txt
zips.txt
)

NB. =========================================================
LIBDESC=: 0 : 0
This is the base library of scripts and labs included in the J system.

Reinstalling or upgrading this library will overwrite files in the system subdirectory. Restart J afterwards.

Files outside the system subdirectory, such as profile.ijs, are not changed.
)

NB. =========================================================
addsep=: , '/' -. {:
remsep=: }.~ [: - '/' = {:
cutjal=: ([: (* 4 > +/\) ' ' = ]) <;._1 ]
cutjsp=: ([: (* 5 > +/\) ' ' = ]) <;._1 ]
fname=: #~ ([: *./\. ~:&'/')
hostcmd=: [: 2!:0 '(' , ] , ' || true)'"_
intersect=: e. # [
ischar=: 2 = 3!:0
noundef=: (1 e. (,each '0:0')&E.) &>
rnd=: [ * [: <. 0.5 + %~
sep2under=: '/' & (I.@('_' = ])})
termLF=: , (0 < #) # LF -. {:
isjpkgout=: ((4 = {:) *. 2 = #)@$ *. 1 = L.

NB. getintro v Returns maximum of first x characters of literal list y
NB. eg: 19 getintro 'This is too long to fit.'
getintro=: ('...' ,~ -&3@[ {. ])^:(<#)
info=: smoutput

NB. =========================================================
dircopy=: 3 : 0
'fm to'=. y
p=. (#fm) }. each dirpath fm
mkdir_j_ each to&, each p
f=. dtree fm
t=. to&, each (#fm) }. each f
t fcopynew &> f
)

NB. =========================================================
NB. getnames v Parses lists into package names
getnames=: 3 : 0
select. L.y
case. 0 do.                        NB. unboxed string
  if. +/ BASELIB E. y do.          NB. is 'base library' included?
    y=. (<BASELIB), cutnames y rplc BASELIB;''
  else.
    y=. cutnames y
  end.
case. 1 do.
  if. 2 = #$y do.                  NB. boxed table
    y=. {."1 y                     NB. first column is package names
  else.
    y=. ,y
  end.
case. do.
  '' return.
end.
y
)

NB. =========================================================
NB. curtailcaption v used to restrict length of last result column for console
curtailcaption=: 3 : 0
idx=. <_1;~I. 45<#&>{:"1 y
y=. (45&getintro &.> idx{y) idx}y
)

NB. =========================================================
NB. deltree v Delete directory tree
NB. form: deltree DirectoryName
NB. returns: boolean
NB.       (1) if all files and folders in tree are deleted
NB.       (0) on error or if some cannot be deleted
NB. y is: literal filename of directory to delete
NB. from addon 'general/dirutils'
deltree=: 3 : 0
try.
  res=. 0< ferase {."1 dirtree y
  *./ res,0<ferase |.dirpath y
catch. 0 end.
)

NB. =========================================================
NB.*dtree v get filenames in directory tree
NB. return list of filenames in directory tree
NB. y is a folder name (with or without trailing separator)
NB. hidden files and directories are ignored
NB. result has full pathnames
dtree=: 3 : 0
p=. y #~ (+./\ *. +./\.) y~:' '
p=. jpath p,'/' -. {:p
d=. 1!:0 p,'*'
if. 0 = #d do. '' return. end.
d=. d #~ 'h' ~: 1 {"1 > 4 {"1 d
if. 0 = #d do. '' return. end.
m=. 'd' = 4 {"1 > 4 {"1 d
d=. (<p) ,each {."1 d
((-.m) # d), ;dtree each m # d
)

NB. =========================================================
NB. fix jal
NB.
NB. fix text into 5 col table: name,ver,dep,cap,desc
fixjal=: 3 : 0
if. 2 > #y do. i.0 5 return. end.
m=. _2 |. (LF,')',LF) E. y
r=. _2 }. each m <;._2 y
x=. r i.&> LF
d=. (x+1) }.each r
r=. x {.each r
r=. 3 {."1 cutjal &> ' ' ,each r
x=. d i.&> LF
c=. x {.each d
d=. (x+1) }.each d
r,.c,.d
)

NB. =========================================================
NB. fix jal2
NB.
NB. fix text into 2 col table: names,ver
fixjal2=: 3 : 0
if. 2 > #y do. i.0 2 return. end.
cutjal &> ' ' ,each <;._2 y
)

NB. =========================================================
NB. fix jsp
NB.
NB. fix text into 5 col table: name,ver,siz,cap,desc
fixjsp=: 3 : 0
if. 2 > #y do. i.0 5 return. end.
m=. _2 |. (LF,')',LF) E. y
r=. _2 }. each m <;._2 y
x=. r i.&> LF
d=. (x+1) }.each r
r=. x {.each r
r=. ' ' ,each r
(cutjsp &> r),.d
)

NB. =========================================================
NB. returns: version;file name;size
fixlib=: 3 : 0
msk=. (<LIBTREE) = 1 {"1 y
if. -. 1 e. msk do. ($0);'';0 return. end.
'ver fln siz'=. 2 4 5 { (msk i.1) { y
ver=. fixver ver
ver;fln;siz
)

NB. =========================================================
NB. returns table:
NB.    'library';tree;version;shortname;fullname;size
fixlibs=: 3 : 0
if. 2 > #y do.
  i.0 6 return.
end.
fls=. <;._2 y
ndx=. fls i.&> ' '
siz=. <&> 0 ". (ndx+1) }.&> fls
fls=. ndx {.each fls
zps=. <;._2 &> fls ,each '_'
pfm=. 3 {"1 zps
uname=. tolower UNAME
msk=. (uname -: ({.~ i.&'.')) &> pfm
if. 1 ~: +/msk do. msk=. 1,~ }:0*.msk end.
msk # zps,.fls,.siz
)

NB. =========================================================
fixrev=: 3 : 0
{. _1 ". :: _1: y -. CRLF
)

NB. =========================================================
fixupd=: 3 : 0
_1 ". :: _1: y -. CRLF
)

NB. =========================================================
fixver=: 3 : 0
if. ischar y do.
  y=. y -. CRLF
  y=. 0 ". ' ' (I. y='.') } y
end.
3 {. y
)

NB. =========================================================
fixvers=: 3 : 0
s=. $y
y=. ,y
3 {."1 [ 0 ". s $ ' ' (I. y e. './') } y
)

NB. =========================================================
NB. fmtjal
NB.
NB. format jal into text
fmtjal=: 3 : 0
if. 0 = #y do. '' return. end.
r=. (4 {."1 y) ,each "1 '  ',LF2
r=. <@; "1 r
; r ,each ({:"1 y) ,each <')',LF
)

NB. =========================================================
NB. fmt jal2
NB.
NB. format jal into text
fmtjal2=: 3 : 0
if. 0 = #y do. '' return. end.
; (2 {."1 y) ,each "1 ' ',LF
)

NB. =========================================================
fmtdep=: 3 : 0
}. ; ',' ,each a: -.~ <;._2 y
)

NB. =========================================================
NB. fmtjsp
NB.
NB. format jsp into text
fmtjsp=: 3 : 0
if. 0 = #y do. '' return. end.
r=. (4 {."1 y) ,each "1 '   ',LF
r=. <@; "1 r
; r ,each ({:"1 y) ,each <')',LF
)

NB. =========================================================
fmtlib=: 3 : 0
, 'q<.>,q<.>r<0>3.0,r<0>3.0' 8!:2 y
)

NB. =========================================================
fmtver=: 3 : 0
if. 0=#y do. '' return. end.
if. ischar y do. y return. end.
}. ; '.' ,each ": each y
)

NB. =========================================================
fmtverlib=: 3 : 0
fmtver y
)

NB. =========================================================
fixzips=: 3 : 0
if. 2 > #y do. i.0 5 return. end.
fls=. <;._2 y
ndx=. fls i.&> ' '
siz=. 0 ". (ndx+1) }.&> fls
fls=. ndx {.each fls
zps=. <;._2 &> fls ,each '_'
zps=. zps,.fls,.<&>siz

NB. ---------------------------------------------------------
pfm=. 3 {"1 zps
and=. (1 e. 'android'&E.) &> pfm
lnx=. (1 e. 'linux'&E.) &> pfm
mac=. (1 e. 'darwin'&E.) &> pfm
win=. mac < (1 e. 'win'&E.) &> pfm

select. UNAME
case. 'Win' do.
  zps=. win # zps
case. 'Linux';'OpenBSD';'FreeBSD' do.
  zps=. lnx # zps
case. 'Android' do.
  zps=. and # zps
case. 'Darwin' do.
  zps=. mac # zps
  zps=. zps /: 3 {"1 zps
  zps=. (~: 3 {."1 zps) # zps
end.

bit=. IF64 pick '64';'32'
pfm=. 3 {"1 zps
exc=. (1 e. bit&E.) &> pfm
zps=. zps \: exc
zps=. (~: 3 {."1 zps) # zps

NB. ---------------------------------------------------------
fnm=. 0 {"1 zps
lnm=. 1 {"1 zps
ver=. 2 {"1 zps
pfm=. 3 {"1 zps
fls=. 4 {"1 zps
siz=. 5 {"1 zps

NB. ---------------------------------------------------------
nms=. fnm ,each '/' ,each lnm
pfm=. (pfm i.&> '.') {.each pfm
ndx=. \: # &> pfm
sort ndx { nms,.pfm,.ver,.fls,.siz
)

NB. =========================================================
NB. fwritenew v writes file if changed
fwritenew=: 4 : 0
if. x -: fread y do.
  0
else.
  x fwrite y
end.
)

NB. =========================================================
NB. read version from jqt binary
getjqtversion=: 3 : 0
suffix=. (IFUNIX>'/'e.LIBFILE)#'-9.4'  NB. deb install
dat=. fread '~bin/jqt',suffix,IFWIN#'.exe'
if. dat-:_1 do. '' return. end.
ndx=. I. 'jqtversion:' E. dat
if. 0=#ndx do. '' return. end.
dat=. 50 {. (11+{.ndx) }. dat
<;._1 '/',(dat i. ':') {. dat
)

NB. =========================================================
platformparent=: 3 : 0
((< _2 {. y) e. '32';'64') # _2 }. y
)

NB. =========================================================
makedir=: 1!:5 :: 0: @ <

NB. =========================================================
plural=: 4 : 0
y,(1=x)#'s'
)

NB. =========================================================
sizefmt=: 3 : 0
select. +/ y >: 1e3 1e4 1e6 1e7 1e9
case. 0 do.
  (": y), ' byte',(y~:1)#'s'
case. 1 do.
  (": 0.1 rnd y%1e3),' KB'
case. 2 do.
  (": 1 rnd y%1e3),' KB'
case. 3 do.
  (": 0.1 rnd y%1e6),' MB'
case. 4 do.
  (": 1 rnd y%1e6),' MB'
case. do.
  (": 0.1 rnd y%1e9),' GB'
end.
)

NB. =========================================================
shellcmd=: 3 : 0
if. IFUNIX do.
  hostcmd_j_ y
else.
  spawn_jtask_ y
end.
)

NB. =========================================================
splitrep=: 3 : 0
rep=. <;.1 '/',y
(}. ; 2 {. rep);;2 }. rep
)

NB. =========================================================
NB. get visible subdirectories
NB. directory names end in /
subdir=: 3 : 0
if. 0=#y do. '' return. end.
a=. 1!:0 y,'*'
if. 0=#a do. '' return. end.
a=. a #~ '-d' -:"1 [ 1 4 {"1 > 4 {"1 a
(<y) ,each ({."1 a) ,each '/'
)

NB. =========================================================
NB. testaccess
NB. 1 if update access to install folder
NB. 0 if not
NB. works for vista virtual store
NB. jreg.bat is deleted/rewritten if there is access
testaccess=: 3 : 0
f=. <jpath'~install/testaccess.txt'
try.
  '' 1!:2 f
  1!:55 f
  1
catch.
  0
end.
)

NB. =========================================================
toupper1=: 3 : 0
if. 0=#y do. '' return. end.
(toupper {. y),tolower }. y
)

NB. =========================================================
NB. unzip file into given subdirectory
unzip=: 3 : 0
'file dir'=. dquote each y
e=. 'Unexpected unzip error'
if. IFUNIX do.
  notarcmd=. IFIOS        NB. even tar is installed, there is no shell in iOS
  if. UNAME-:'Android' do.
NB. busybox tar is faster than jtar
    notarcmd=. _1-: 2!:0 ::_1: 'which tar 2>/dev/null'
    if. (UNAME-:'Android') > '/mnt/sdcard'-:2!:5'EXTERNAL_STORAGE' do. notarcmd=. 1 end.
  end.
  if. notarcmd do.
    require 'tar'
    'file dir'=. y
    if. (i.0 0) -: tar 'x';file;dir do. e=. '' end.
  else.
    e=. shellcmd 'tar ',((IFIOS+:UNAME-:'Android')#(((<UNAME)e.'Darwin';'OpenBSD';'FreeBSD'){::'--no-same-owner --no-same-permissions';'-o -p')),' -xzf ',file,' -C ',dir
  end.
  if. ('/usr/'-:5{.dir-.'"') *. ('root'-:2!:5'USER') +. (<2!:5'HOME') e. 0;'/var/root';'/root';'';,'/' do.
    shellcmd ::0: 'find ',dir,' -type d -exec chmod a+rx {} \+'
    shellcmd ::0: 'find ',dir,' -type f -exec chmod a+r {} \+'
  end.
else.
  dir=. (_2&}. , '/' -.~ _2&{.) dir
  e=. shellcmd UNZIP,' ',file,' -d ',dir
end.
e
)

NB. =========================================================
NB. add zip extension
zipext=: 3 : 0
y, IFUNIX pick '.zip';'.tar.gz'
)
