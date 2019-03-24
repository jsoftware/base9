NB. test with jd

cocurrent 'base'

load 'jd'
load '~Main/release/install/system/util/pm.ijs'

jdadminx 'test'

day=: (efs_jd_ '2017-09-30') + 864e11 * ]
jd 'createtable tab'
jd 'createcol tab size int _';3 5 7
jd 'createcol tab text byte 5';>;:'one two three'
jd 'createcol tab now edatetimem _';day 1 2 3
jd 'info schema tab'
jd 'reads * from tab'

NB. =========================================================
len=: 1
start_jpm_ ''
jd 'reads * from tab'
a=. jd each len#<'reads * from tab'
smoutput showtotal_jpm_''
smoutput showdetail_jpm_'getdb_jd_'
