
cocurrent 'base'
load '~Main/release/install/system/util/pm.ijs'

NB. =========================================================
f=: 3 : 0
a=. +: y
b=. 2 + i.a
y
)

NB. =========================================================
foo=: 3 : 0
start_jpm_''
f &> i.100
smoutput showdetail_jpm_ 'f'
smoutput showtotal_jpm_ ''
)

foo ''

NB. =========================================================
goo=: 3 : 0
y1=: 100$' '
(1 1) 6!:10 y1
6!:12 ]1
f &> i.100
6!:11''
)

smoutput goo''
