NB. representation
NB.
NB. returns line representation

EXHDR=: '1234' ;&,&> ':'

NB. =========================================================
NB.*linerep v representation of definition
NB.
NB. form: valence linerep name
NB. where: valence = 1 monad,2 dyad
NB.        name is boxed
NB.
NB. representation is a 3-column table:
NB.   line number ; statement numbers; line text
NB.
NB. if definition is tacit, the "line number" is _1

linerep=: 4 : 0
dat=. x (5!:7) y
if. #dat do.
  stm=. ;{."1 dat
  lns=. {: &> 1 {"1 dat
  txt=. {:"1 dat
  lno=. <&> ~. lns
  sno=. lns </. stm
  ltx=. lns <@unwords/. txt
  lno ,. sno ,. ltx
else.
  lrep=. 5!:5 :: 0: y
  if. lrep -: 0 do. '' return. end.
  if. (x=1) *. '4 : 0' -: 5 {. lrep do. '' return. end.
  _1;_1;lrep
end.
)
