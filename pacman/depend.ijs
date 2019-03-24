NB. depend

NB. =========================================================
NB. getdepend
NB. add dependencies to gui install
getdepend=: 3 : 0
if. 0 = #y do. y return. end.
dep=. getdepend_console 1{"1 y
PKGDATA #~ (1{"1 PKGDATA) e. dep
)

NB. =========================================================
NB. getdepend_console
NB. add dependencies to console install
getdepend_console=: 0&$: : (4 : 0)
if. 0 = #y do. y return. end.
old=. ''
if. 0=#PKGDATA do. init_console'' end.
ids=. 1{"1 PKGDATA
dep=. 6{"1 PKGDATA
res=. ~. <;._1 ; ',' ,each (ids e. y) # dep
whilst. -. res-:old do.
  old=. res
  res=. ~. res, <;._1 ; ',' ,each (ids e. res) # dep
end.
/:~ ~. y, res -. a:, (0=x)# {."1 ADDINS
)
