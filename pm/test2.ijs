
cocurrent 'base'
load '~Main/release/install/system/util/pm.ijs'

NB. =========================================================
coreset''
m=: cocreate''
n=: cocreate''

foo__m=: 3 : 0
a=. +: y
b=. 2 + i.a
y
)

foo__n=: 3 : 0
s=. ^. y
2 + s
)

NB. =========================================================
Note''
start_jpm_''
foo__m 3
foo__n 3
coerase n
smoutput 0 showdetail_jpm_ 'foo';m
smoutput 0 0 100 showtotal_jpm_ ''
smoutput 0 1 showtotal_jpm_ ''
)
