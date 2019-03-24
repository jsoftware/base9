smspace_z_=: smoutput bind (60#'-')

total_z_=: 3 : 0
smoutput 0 0 100 showtotal_jpm_ ''
)

detail_z_=: 3 : 0
smoutput 0 showdetail_jpm_ y
)

loadtest_z_=: 3 : 0
load PATH,'test',(":y),'.ijs'
)

DOTEST_z_=: 0 : 0
reset_jpm_''
1 0 (6!:10) 1e6$' '
6!:12 [ 1
foo''
pmdata=: 6!:11''
6!:10 ''
dat=. > join _3 }. ,.each pmdata
dat=. dat ,. 10001 + +/\ 10000 + i.#dat
dat=. dat ,. +/\ i.#dat
txt=. 6 pick pmdata
PMTESTDATA_jpm_=: (<"1 |: dat) , <txt
read_jpm_ ''
)
