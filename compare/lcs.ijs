NB. lcs

NB. =========================================================
NB. do lcs on prefix
complcs=: 3 : 0
lx=. #X
ly=. #Y
if. MAXLCS < lx * ly do.
  select. MAXPFX < lx,ly
  case. 0 1 do.
    ly=. <. MAXLCS % lx
  case. 1 0 do.
    lx=. <. MAXLCS % ly
  case. do.
    lx=. ly=. MAXPFX
  end.
end.

NB. ---------------------------------------------------------
a=. lx {. X
b=. ly {. Y
m=. ((b =/ a),.0),0
cm=. lcs ^:_ m
len=. >./ ,cm
rc=. 1 + mindx ($cm) #: I. len = ,cm
cm=. , rc {. cm
msk=. (1+i.len) =/ cm

NB. ---------------------------------------------------------
ndx=. <@I."1 msk
pos=. ; (<rc) #: each ndx
pos=. (+/"1 pos),.pos
pos=. ((# &> ndx) # i.len),.pos
pos=. /:~ pos
'ib ia'=. |: 2 }."1 (~:{."1 pos)#pos

NB. ---------------------------------------------------------
n=. 1 + {: ia
SX=: SX,(<<<ia) { n {. NX
X=: n }. X
NX=: n }. NX

NB. ---------------------------------------------------------
n=. 1 + {: ib
SY=: SY,(<<<ib) { n {. NY
Y=: n }. Y
NY=: n }. NY

NB. ---------------------------------------------------------
0
)
