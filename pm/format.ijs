NB. format utils for perfmon

NB. =========================================================
NB. ifmt comma integer format:
ifmt=: 3 : 0
w=. 20
dat=. , y
neg=. 0 > dat
dat=. ": &.> <. | dat
msk=. (-w){.(|. w$1j1 1 1),3$1
exp=. #!.','~ ({.&msk)@-@#
dat=. exp &.> dat
dat=. (neg{'';'-'),&.>,dat
p=. - >./ # &> dat
p {. &> dat
)

NB. =========================================================
NB. float format:
ffmt=: 4 : 0
n=. ifmt 0 | y
if. x do.
  n ,. }."1 (j. x) ": ,. 1 || y
end.
)

NB. =========================================================
NB. SCALE=: 1000 1   NB. time/space
NB. timeformat=: 3 & ffmt
NB. TIMETEXT=: ' Time (milliseconds)'

SCALE=: 1 1   NB. time/space

timeformat=: 6 & ffmt
TIMETEXT=: ' Time (seconds)'

spaceformat=: ifmt
SPACETEXT=: ' Space (bytes)'
