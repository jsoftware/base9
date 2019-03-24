NB. util

NB. =========================================================
defaultvalue=: 4 : 'if. _1 = 4!:0 <x do. (x)=: y end.'
index=: #@[ (| - =) i.
intersect=: e. # [
matchhead=: [ -: #@[ {. ]
towords=: ;:^:(_1 * 1 = L.)

termLF=: , (0 < #) # LF -. {:

NB. =========================================================
NB. decomment
NB. argument and result are text vectors
NB. ignores any comments beginning NB.!
decomment=: 3 : 0
dat=. <;._2 termLF toJ y
if. 2 > #dat do. y return. end.

com=. (('NB.'-:3{.])>'NB.!'-:4{.])&> dat
ncm=. com < (1|.0,}.com) +. (0,}._1|.com)
msk=. com +: ncm *. dat=a:
dat=. msk # dat

d=. #~ ([: +./\. -.@e.&(' ',TAB))
f=. *./\ @ (('NB.'&E.>'NB.!'&E.) <: ~:/\@(e.&''''))
g=. f d@#^:(0 e. [) ]
; (g each dat) ,each LF
)

NB. =========================================================
NB. analogous to fpathname
NB. splits into folder;balance if under a folder
ffoldername=: 3 : 0
p=. tofoldername_j_ y
if. '~' ~: {.p do. '';p return. end.
x=. ('/' e. p) + p i. '/'
(x{.p);x}.p
)

NB. =========================================================
NB. replace nb. by NB.
fixNB=: 3 : 0
x=. I. 'nb.' E. y
'NB' (<"0 (0 1) +/~ x) } y
)

NB. =========================================================
NB. get project file
getprojfile=: 3 : 0
if. 0=#y do. '' return. end.
p=. remsep projname2path y
if. -. ProjExt -: (-#ProjExt) {. p do.
  p=. remsep p
  'f n'=. fpathname p
  p,'/',n,ProjExt
end.
)

NB. =========================================================
getprojname=: 3 : 0
ProjectName,(0=#ProjectName)#ProjectPath
)

NB. =========================================================
NB. projname2path v get path from pathname
projname2path=: 3 : 0
y=. jpathsep y
if. '~'={. y do.
  jpath y
elseif. ('./'-:y) +. '.' -:&, y do.
  1!:43''
elseif. ('./'e.~{.y) +: </ y i. ':/' do.
  jpath '~',y
elseif. do.
  y
end.
)

NB. =========================================================
NB. project full name (for names read in)
projfname=: 3 : 0
if. 0=#y do. '' return. end.
s=. jpathsep y
if. -. '/' e. s do.
  ProjectPath,'/',s
else.
  jpath s
end.
)

NB. =========================================================
NB. project short name (for names written out)
projsname=: 3 : 0
if. 0=#ProjectPath do. y return. end.
if. ProjectPath matchhead y do.
  (1+#ProjectPath) }. y
else.
  toprojectfolder y
end.
)

NB. =========================================================
projssource=: 3 : 0
projread''
Source;<projsname each Source
)

NB. =========================================================
NB. source files relative to project folder
fixdot=: 4 : 0
if. IFUNIX do.
  if. '/'~:{.y do. x,'/',y else. y end.
else.
  if. '.'={.y do. x,'/',y else. y end.
end.
)
