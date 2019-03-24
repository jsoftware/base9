NB. load

Loaded=: ''
Public=: i. 0 2
UserFolders=: i. 0 2

NB. =========================================================
getignore=: 3 : 0
r=. ' colib compare convert coutil dates dir dll files libpath strings text gl2 graphics/gl2'
Ignore=: <;._1 r
)

getignore''

NB. =========================================================
buildpublic=: 3 : 0
dat=. deb toJ y
dat=. a: -.~ <;._2 dat, LF
ndx=. dat i. &> ' '
short=. ndx {.each dat
long=. ndx }. each dat
long=. extsrc@jpathsep@deb each long
msk=. (<'system','/') = 7 {. each long
long=. (msk{'';'~') ,each long
msk=. (i. ~.) {."1 Public=: Public,~ short,.long
Public=: sort msk{Public
empty''
)

NB. =========================================================
NB. cut names on blanks, except in double quotes
NB. if LF given, cut on LF instead
cutnames=: 3 : 0
if. LF e. y do.
  txt=. y, LF
  nms=. (txt = LF) <;._2 txt
else.
  txt=. y, ' '
  msk=. txt = '"'
  com=. (txt = ' ') > ~: /\ msk
  msk=. (msk *. ~:/\msk) < msk <: 1 |. msk
  nms=. (msk # com) <;._2 msk # txt
end.
nms -. a:
)

NB. =========================================================
NB. exist
3 : 0''
if. 0=9!:24'' do.
  exist=: fexist
else.
  exist=: 0:
end.
1
)

NB. =========================================================
NB. convert file/directory name into full fpathname:
fullname=: 3 : 0
p=. '/'
d=. jpath y
NB. do nothing if : occurs before '/'
if. </ d i. ':',p do.
NB. do nothing if // or \\ start
elseif. (2{.d) -: 2#p do.
NB. add dirpath if not starting with '/'
elseif. p ~: 1{.d do.
  jcwdpath d
NB. add drive if WIN32
elseif. IFWIN do.
  (2{.jcwdpath''),d
end.
)

NB. =========================================================
getscripts=: 3 : 0
if. 0=#y do. '' return. end.
if. 0=L.y do.
  if. isfile y do.
    fullname each fboxname y return.
  end.
  y=. cutnames y
end.
y=. y -. Ignore
if. 0=#y do. '' return. end.
ndx=. ({."1 Public) i. y
ind=. I. ndx < # Public
y=. ((ind { ndx) { 1 {"1 Public) ind } y
ind=. (I.-.isroot&>y) -. ind
if. #ind do.
  bal=. jpath each ind { y
  msk=. (isfile &> bal) +. '/'={:&> bal
  y=. (msk#bal) (msk#ind) } y
  ind=. (-.msk)#ind
  if. #ind do.
    bal=. (-.msk)#bal
    msk=. -. '.'&e.@(}.~i:&'/') &> bal      NB. filter path looks like addons by the last folder
    msk=. msk *. *./@:((a.{~, 65 97 +/i.26)e.~])@:({.~i.&'/') &> bal  NB. and by the first folder
    msk=. msk > isroot &> bal                                         NB. and not root folder
    cnt=. ('/' +/ .= ]) &> bal
    ndx=. I. msk *. cnt=1
    bal=. (addfname each ndx { bal) ndx } bal
    ndx=. I. msk *. cnt > 0
    bal=. (<jpath '~addons/') ,each (ndx{bal) ,each <'.ijs'
    y=. bal (ndx{ind) } y
  end.
end.
fullname each y
)

NB. =========================================================
getpath=: ([: +./\. =&'/') # ]
