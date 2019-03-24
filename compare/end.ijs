NB. compend
NB.
NB. repeats until no change:
NB.   remove same head and tails
NB.   remove different lines

NB. =========================================================
NB. returns 0 if done, else 1
compend=: 3 : 0
old=. 0 0
len=. (#X),#Y

while. -. len -: old do.
  old=. len
  t=. <./len

NB. ---------------------------------------------------------
NB. mask out head and tail matches:
  m=. 0 i.~ (t {. X) = t {. Y
  X=: m }. X
  Y=: m }. Y
  t=. m - t
  n=. - +/ *./\. (t {. X) = t {. Y
  X=: n }. X
  Y=: n }. Y
  NX=: m }. n }. NX
  NY=: m }. n }. NY

NB. ---------------------------------------------------------
NB. extract lines not in both:
  m=. X e. Y
  if. 0 e. m do.
    SX=: SX,(-.m)#NX
    X=: m # X
    NX=: m # NX
  end.
  m=. Y e. X
  if. 0 e. m do.
    SY=: SY,(-.m)#NY
    Y=: m # Y
    NY=: m # NY
  end.

NB. ---------------------------------------------------------
  len=. (#X),#Y
end.

NB. ---------------------------------------------------------
if. -. 0 e. len do. 1 return. end.
SX=: SX,NX
SY=: SY,NY
0
)
