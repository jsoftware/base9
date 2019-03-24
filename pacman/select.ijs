NB. data selections

NB. =========================================================
masklib=: 3 : 0
(1 {"1 y) = <BASELIB
)

NB. =========================================================
NB. return mask of later versions
pkglater=: 3 : 0
dat=. (s=. isjpkgout y){:: PKGDATA;<y
if. 0=#dat do. $0 return. end.
loc=. fixvers > (2-s) {"1 dat
srv=. fixvers > (3-s) {"1 dat
{."1 /:"2 srv ,:"1 loc
)

NB. =========================================================
pkgnew=: 3 : 0
dat=. (s=. isjpkgout y){:: PKGDATA;<y
if. 0=#dat do. $0 return. end.
0 = # &> (2-s) {"1 dat
)

NB. =========================================================
pkgups=: pkgnew < pkglater

NB. =========================================================
NB. pkgsearch v Searches package names in PKGDATA for matches to terms in y
NB. result: boolean mask of matching rows of PKGDATA
NB. y is: list of boxed search terms
pkgsearch=: 3 : 0
+./"1 +./ y E."1&>"(0 _) 1{"1 PKGDATA
)

NB. =========================================================
NB. pkgshow v Searches package names in PKGDATA for package names in y
NB. result: boolean mask of matching rows of PKGDATA
NB. y is: list of boxed package names
pkgshow=: 3 : 0
y e.~ 1{"1 PKGDATA
)

NB. =========================================================
setshowall=: 3 : 0
PKGDATA=: (<y) (<(I.DATAMASK);0) } PKGDATA
)

NB. =========================================================
setshownew=: 3 : 0
ndx=. I. DATAMASK *. pkgnew''
PKGDATA=: (<y) (<ndx;0) } PKGDATA
)

NB. =========================================================
setshowups=: 3 : 0
ndx=. I. DATAMASK *. pkgups''
PKGDATA=: (<y) (<ndx;0) } PKGDATA
)

NB. =========================================================
NB. returns lib;rest
splitlib=: 3 : 0
if. 0=#y do.
  2 $ <y return.
end.
msk=. masklib y
(msk#y) ; <(-.msk)#y
)

