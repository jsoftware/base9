NB.-directory utilities
NB.%dir.ijs - directory utilities
NB.-This script defines directory utilities and is included in the J standard library.
NB.-Definitions are loaded into the z locale.
NB.
NB. main verbs:
NB.  dir            directory
NB.  dircompare     compare directories
NB.  dircompares    compare directories (called by dircompare)
NB.  dirpath        directory paths
NB.  dirfind        find name in directory
NB.  dirs           directory browse
NB.  dirss          directory string search
NB.  dirssrplc      search and replace in directory
NB.  dirtree        files in directory tree
NB.  dirused        file count, space in directory tree
NB.
NB. note: dirtree excludes hidden directories, and other
NB. directories specified in the session configuration.

cocurrent 'z'

NB. =========================================================
NB.*dir v directory listings
NB.-
NB.- y = file specification
NB.-     if empty, defaults to *
NB.-
NB.- x is optional:
NB.-   - if not given, defaults to 'n'
NB.-   - if character, returns a formatted directory,
NB.-       where x is the sort option:
NB.-         d=by date
NB.-         n=by name
NB.-         s=by size
NB.-   - if numeric, there are 1 or 2 elements:
NB.-         0{  0= list short names
NB.-             1= boxed list of full pathnames
NB.-             2= full directory list
NB.-         1{  0= filenames only (default)
NB.-             1= include subdirectories
NB.-
NB.- subdirectories are shown first
NB.- filenames are returned in lower case
NB.-
NB.-example:
NB.+dir ''
NB.+1 dir jpath '~system/main/d*.ijs'

dir=: 3 : 0
'n' dir y
:
ps=. '/'
y=. jpath y,(0=#y)#'*'
y=. y,((':',ps) e.~ {:y)#'*'
if. 0=#dr=. 1!:0 y do. empty'' return. end.
fls=. 'd' ~: 4{"1>4{"1 dr
if. (1=#dr) *. 0={.fls do.
  r=. x dir y,ps,'*'
  if. #r do. r return. end.
end.
if. fmt=. 2=3!:0 x do. opt=. 2 1
else. opt=. 2{.x end.
if. 0={:opt do. fls=. 1#~#dr=. fls#dr end.
if. 0=#dr do. empty'' return. end.
nms=. {."1 dr
nms=. nms ,&.> fls{ps;''
ndx=. /: (":,.fls),.>nms
if. 0=opt do.
  list >ndx{nms
elseif. 1=opt do.
  path=. (+./\.y=ps)#y
  path&,&.>ndx{nms
elseif. fmt<2=opt do.
  ndx{nms,.}."1 dr
elseif. fmt do.
  'nms ts size'=. |:3{."1 dr
  ds=. '   <dir>    ' ((-.fls)#i.#fls) } 12 ":,.size
  mth=. _3[\'   JanFebMarAprMayJunJulAugSepOctNovDec'
  f=. > @ ([: _2&{. [: '0'&, ": )&.>
  'y m d h n s'=. f&> ,<"1 |: 100|ts
  m=. (1{"1 ts){mth
  time=. d,.'-',.m,.'-',.y,.' ',.h,.':',.n,.':',.s
  dat=. (>nms),.ds,.' ',.time
  dat /: fls,. /:/: >(3|'dns'i.x){ts;nms;size
elseif. 1 do.
  'invalid left argument'
end.
)

NB. =========================================================
NB.*dircompare v compare files in directories
NB.
NB.-syntax:
NB.+[opt] dircompare dirs
NB.-
NB.- dirs = directory names
NB.- opt is optional, with up to three elements:
NB.-   0{  =0 short file comparison (default)
NB.-       =1 long file comparison
NB.-   1{  =0 given directory only (default)
NB.-       =1 recurse through subdirectories
NB.-   2{  =0 file contents only (default)
NB.-       =1 also compare timestamps
NB.
NB.-example:
NB.+dircompare 'main /jbak/main'
NB.
NB.-returns text result or error message
dircompare=: 3 : 0
0 dircompare y
:
if. 0=#y do.
  '''long dirtree timestamps'' dircompare dir1;dir2'
  return.
end.

opt=. 3 {. x
res=. opt dircompares y
if. 0 = L. res do. return. end.

ps=. '/'
'a b c'=. res

'x y'=. jpath each cutopen y
x=. x, ps #~ (*#x) *. ps~:_1{.x
y=. y, ps #~ (*#y) *. ps~:_1{.y

r=. 'comparing  ',x,'  and  ',y,LF

if. #a do.
  r=. r,LF,'not in  ',y,':',LF,,(list a),.LF
end.

if. #b do.
  r=. r,LF,'not in  ',x,':',LF,,(list b),.LF
end.

if. +/ # &> c do.
  'cf cd'=. c
  r=. r,LF,'not same in both:',LF,,(list cf),.LF
  if. {.opt do.
    r=. r,LF,;(,&(LF2)) &.> cd
  end.

end.

if. 0=#;res do. r=. r,'no difference',LF end.

}:r
)

NB. =========================================================
NB.*dircompares v compare files in directories
NB.
NB.-syntax:
NB.+[opt] dircompares dirs
NB.
NB.- dirs = directory names
NB.- opt is optional, with up to three elements:
NB.-   0{  =0 short file comparison (default)
NB.-       =1 long file comparison
NB.-   1{  =0 given directory only (default)
NB.-       =1 recurse through subdirectories
NB.-   2{  =0 file contents only (default)
NB.-       =1 also compare timestamps
NB.
NB.-example:
NB.+dircompares 'main /jbak/main'
NB.
NB.-returns error message or 3-element boxed list
dircompares=: 3 : 0
0 dircompares y
:
ps=. '/'
opt=. 3{. x
'x y'=. jpath each cutopen y
x=. x, ps #~ (*#x) *. ps~:_1{.x
y=. y, ps #~ (*#y) *. ps~:_1{.y

if. 1{opt do.
  dx=. dirtree x [ dy=. dirtree y
else.
  dx=. 2 0 dir x [ dy=. 2 0 dir y
end.

if. dx -: dy do. 'no difference' return. end.
if. 0 e. #dx do. 'first directory is empty' return. end.
if. 0 e. #dy do. 'second directory is empty' return. end.

f=. #~ [: +./\. =&ps
sx=. f x
sy=. f y
fx=. {."1 dx
fy=. {."1 dy

if. 1{opt do.
  fx=. (#sx)}.&.>fx
  fy=. (#sy)}.&.>fy
  dx=. fx 0 }"0 1 dx
  dy=. fy 0 }"0 1 dy
end.

r=. <fx -. fy
r=. r , <fy -. fx

dx=. (fx e. fy)#dx
dy=. (fy e. fx)#dy

if. #j=. dx -. dy do.
  j=. {."1 j
  cmp=. <@fcompare"1 (sx&,&.>j),.sy&,&.>j

  if. 0=2{opt do.
    f=. 'no difference'&-: @ (_13&{.)
    msk=. -. f &> cmp
    j=. msk#j
    cmp=. msk#cmp
  end.

  r=. r,< j;<cmp
else.
  r=. r,a:
end.

r
)

NB. =========================================================
NB.*dirfind v find name in directory
NB.-Find name in directory
NB.-
NB.-syntax:
NB.+string dirfind directory
NB.
NB.-returns filenames in directory tree containing string
NB.-
NB.-example:
NB.+'jfile' dirfind 'packages'
dirfind=: 4 : 0
f=. [: 1&e. x&E.
g=. #~ [: -. [: +./\. =&'/'
d=. {."1 dirtree y
m=. f@g &> d
if. 1 e. m do. ; (m # d) ,each LF else. 0 0$'' end.
)

NB. =========================================================
NB.*dirpath v directory paths
NB.-Return directory paths starting from y
NB.-
NB.- Optional x=0  all paths (default)
NB.-            1  non-empty paths (i.e. having files)
NB.-example:
NB.+dirpath 'examples'
dirpath=: 3 : 0
0 dirpath y
:
r=. ''
t=. jpath y
ps=. '/'
if. #t do. t=. t, ps -. {:t end.
dirs=. <t
ifdir=. 'd'&= @ (4&{"1) @ > @ (4&{"1)
subdir=. ifdir # ]
while. #dirs do.
  fpath=. (>{.dirs) &,
  dirs=. }.dirs
  dat=. 1!:0 fpath '*'
  if. #dat do.
    dat=. subdir dat
    if. #dat do.
      r=. r, fpath each /:~ {."1 dat
      dirs=. (fpath @ (,&ps) each {."1 dat),dirs
    end.
  end.
end.
if. x do.
  f=. 1!:0 @ (,&(ps,'*'))
  g=. 0:`(0: e. ifdir)
  h=. g @. (*@#) @ f
  r=. r #~ h &> r
end.
if. #t do. r=. r,<}:t end.
/:~ r
)

NB. =========================================================
NB.*dirss v directory string search
NB.
NB.-syntax:
NB.+string dirss directory
NB.
NB.- searches for files in directory tree containing string,
NB.- returning formatted display where found.
NB.
NB.-example:
NB.+'create' dirss 'main'
NB.
NB.-If x is a 2-element boxed list, calls dirssrplc
dirss=: 4 : 0
if. (2=#x) *. 1=L. x do.
  x dirssrplc y return.
end.
sub=. ' '&(I.@(e.&(TAB,CRLF))@]})
fls=. {."1 dirtree y
if. 0 e. #fls do. 'not found: ',x return. end.
fnd=. ''
while. #fls do.
  dat=. 1!:1 <fl=. >{.fls
  fls=. }.fls
  ndx=. I. x E. dat
  if. rws=. #ndx do.
    dat=. (20$' '),dat,30$' '
    dat=. (rws,50)$sub(,ndx+/i.50){dat
    fnd=. fnd,LF2,fl,' (',(":#ndx),')'
    fnd=. fnd,,LF,.dat
  end.
end.
if. #fnd do. 2}.fnd else. 'not found: ',x end.
)

NB. =========================================================
NB.*dirssrplc v directory string search and replace
NB.-
NB.-syntax:
NB.+(old;new) dirssrplc files
NB.-
NB.-example:
NB.+('old';'new') dirssrplc jpath '~system/main/*.ijs'
dirssrplc=: 4 : 0
fls=. {."1 dirtree y
if. 0 e. #fls do.
  'no files found' return.
end.
r=. (x&fssrplc) each fls
b=. r ~: <'no match found'
j=. >b # fls , each ': '&, each r
}: , j ,. LF
)

NB. =========================================================
NB.*dirtree v get filenames in directory tree
NB.-Return filenames in directory tree as boxed matrix
NB.-
NB.-Optional x is a timestamp to exclude earlier files.
NB.-
NB.-Each row contains:  filename;timestamp;size
NB.-
NB.-Directory search is recursive through subdirectories
NB.-
NB.-Filenames are returned in lower case in OSX or Windows
NB.-
NB.-Ignores hidden directories
NB.-
NB.-Global `DirTreeX_j_` (set in session configuration)
NB.-is a list of directories to exclude from the search.
NB.-e.g. DirTreeX_j_=: 'cvs' to exclude cvs directories.
NB.-
NB.-example:
NB.+dirtree ''
NB.+dirtree 'main'
NB.+dirtree jpath '~system/packages/*.ijs'
NB.+2014 5 23 dirtree ''   - files dated on or after date.
dirtree=: 3 : 0
0 dirtree y
:
if. 0=4!:0 <'DirTreeX_j_' do.
  ex=. cutopen DirTreeX_j_
else.
  ex=. ''
end.
r=. i.0 3
ps=. '/'
y=. jpath y
y=. y #~ (+./\ *. +./\.) y~:' '
y=. y,(0=#y)#'*'
if. ps={:y do. y=. y,'*' end.

NB.----------------------------------------------------------
NB.-if no wildcard, check if directory:
if. -. '*' e. y do.
  if. 1 = #j=. 1!:0 y do.
    select. 'hd' = 1 4 { >4{,j
    case. 0 1 do. x dirtree y,ps,'*' return.
    case. 1 1 do. i.0 3 return.
    end.
  end.
end.

NB.----------------------------------------------------------
ts=. 100"_ #. 6: {. 0: >. <. - # {. 1980"_
'path ext'=. (b#y);(-.b=. +./\.y=ps)#y
NB.-read files in current directory:
if. #dl=. 1!:0 y do.
  att=. > 4{"1 dl
  fl=. (('h' ~: 1{"1 att) *. 'd' ~: 4{"1 att)#dl
  if. #fl do.
    r=. r,(path&,&.>{."1 fl),.1 2{"1 fl
  end.
end.
NB.-read any subdirectories:
if. #dl=. 1!:0 path,'*' do.
  att=. > 4{"1 dl
  dr=. {."1 (('h' ~: 1{"1 att) *. 'd' = 4{"1 att) # dl
  dr=. dr -. ex
  if. #dr do.
    r=. r,;x&dirtree@(path&,@,&(ps,ext)) &.> dr
  end.
end.
r #~ (ts x) <: ts &> 1{"1 r
)

NB. =========================================================
NB.*dirused v get count and space of files in directory tree
dirused=: [: (# , +/ @ ; @ (2: {"1 ])) 0&dirtree
