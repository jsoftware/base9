NB. test0

OLD=: jpath '~Main\pp\test2.ijs'
NEW=: jpath '~temp\testpp.ijs'

dbg 1
dbstops''

NB. =========================================================
t0=: 3 : 0
(pplint_jpp_ freads OLD) fwrites NEW
wdview (freads NEW),LF,fcompare OLD;NEW
)

dbg 1
dbstops ''
(freads OLD) fwrites NEW
open NEW
