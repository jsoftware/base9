NB. show detail

NB. =========================================================
NB. showdetail
NB.
NB. form: [opt] showdetail name [;locale]
NB.
NB.  opt may be 1-2 numbers:
NB.        0 time 1 space  (default 0)
NB.        1 expand control sentences
NB.
showdetail=: 3 : 0
0 showdetail y
:
if. 0=#y do. return. end.
if. 0=read '' do. i.0 0 return. end.
if. 0={.PMSTATS do.
  'No detail PM records were recorded' return.
end.
y=. getnameloc y
}. ; LF ,&.> showdetail1&y each x
)

NB. =========================================================
showdetail1=: 4 : 0
tit=. 'all';'here';'rep';{:y
top=. x pick TIMETEXT;SPACETEXT
'name loc given'=. y
res=. x showdetail2 y
if. 0 = L. res do. return. end.

'mdat mtxt ddat dtxt tdat ttxt'=. res

if. (#mdat) *. #ddat do.
  txt=. mtxt ,each ' ' ,each dtxt ,each ' ' ,each ttxt
else.
  txt=. mtxt ,each dtxt
end.

top, , LF ,. ": tit ,: txt
)

NB. =========================================================
showdetail2=: 4 : 0
'name loc given'=. y

'mdat mrep'=. (x,0) getdetail y
'ddat drep'=. (x,1) getdetail y

if. 0 = (#mdat) + (#ddat) do.
  'not found: ',getshortname given return.
end.

if. 0 e. (#mdat), (#ddat) do.
  tdat=. 0, (1 2 { -: +/ mdat,ddat), {: +/ (1 {. mdat) , 1 {. ddat
else.
  tdat=. 0 ; 2 }. x gettotal fullname y
end.

trep=. <'total definition'
mtxt=. x showdetailfmt mdat;<mrep
dtxt=. x showdetailfmt ddat;<drep
ttxt=. x showdetailfmt tdat;<trep

mdat;mtxt;ddat;dtxt;tdat;<ttxt
)

NB. =========================================================
showdetailfmt=: 4 : 0
'dat lns'=. y
if. 0 e. #dat do. 4 # <i.0 0 return. end.
if. x do. f=. spaceformat else. f=. timeformat end.
'all here rep'=. }. |: dat
lns=. > (#rep) {. boxxopen lns
(f all);(f here);(":,.rep); lns
)
