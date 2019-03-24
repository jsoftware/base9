NB. usage

NB. =========================================================
NB. getused
NB. return 2-column table:
NB.    names that have been used
NB.    corresponding locales
getused=: 3 : 0
if. 0=read '' do. i. 0 0 return. end.
'nms lcs j'=. |: PMDECODE #: ~. PMNDX
xjp=. lcs ~: PMLOCALES i. <'jpm'         NB. not jpm locale
sort xjp # (nms { PMNAMES) ,. lcs { PMLOCALES
)

NB. =========================================================
NB. getnotused
NB. return 2-column table:
NB.    list of names that have not been used
NB.    locale
getnotused=: 3 : 0
loc=. 18!:1 [ 0 1
r=. i.0 2
for_lc. loc do.
  r=. r, (nl__lc 1 2 3) ,. lc
end.
sort r -. getused''
)
