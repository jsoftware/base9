
require 'jpm'
toss=: ?@(# #) { ]
commasep=: ([: }.@; ',' ,each ])

'a b c d e f g'=. <each ;: 'alan ben cindy david elmo fred genie'
n=. <''

AS=: 'a,b,c,d,e,f'
BS=: 'a,b,d,e,g'
BS=: 'b,c,f,e,a'

AS=: 'a,b,n,c,d,e'
BS=: 'a,b,n,c,d,n,n,c,d,e'

NB. AS=: commasep 20 toss ;: 'a b c d e f n'
NB. BS=: commasep 25 toss ;: 'a b c d g n'

A=: tolist ". AS
B=: tolist ". BS

P=: '/home/chris/dev/apps/qt/compare'
A fwrites P,'/t1.txt'
B fwrites P,'/t2.txt'

NB. =========================================================
dbg 1
dbstops''

NB. start_jpm_''
NB. C=: A compare B
NB. smoutput showtotal_jpm_''
NB. smoutput C

a=. AS,LF,BS,LF,A compare B
clipwrite a
smoutput a

