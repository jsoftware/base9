
cocurrent 'base'
load '~Main/release/install/system/util/pm.ijs'

NB. =========================================================
foo=: 3 : 0
if. 0 = y=. {. 1 {. y,4 do.
  'line 1'
  return.
end.

'line 6'
goo ''
)

NB. =========================================================
goo=: 3 : 0
'line 0'
moo 4
'line 2'
moo 5
)

NB. =========================================================
moo=: 3 : 0
'line 0'
foo 0
)

start_jpm_''
foo''
smoutput showdetail_jpm_ 'foo'
smoutput showdetail_jpm_ 'goo'
smoutput showdetail_jpm_ 'moo'
smoutput 0 0 100 showtotal_jpm_ ''
smoutput 1 0 100 showtotal_jpm_ ''
