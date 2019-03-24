NB. fini

NB. =========================================================
3 : 0''
if. _1=nc <'cmhandles' do.
  cmhandles=: cmpatterns=: $0
  cmseq=: 0
  cmtable=: i.0 3
end.
lasterror=: ''
regclear''
)

NB. =========================================================
NB. define z locale names:
nms=. 0 : 0
rxmatch rxmatches rxcomp rxfree rxhandles rxinfo rxeq
rxin rxindex rxE rxfirst rxall rxrplc rxapply rxerror
rxcut rxfrom rxmerge rxutf8
)

nms=. (nms e.' ',LF) <;._2 nms
". > nms ,each (<'_z_=:') ,each nms ,each <'_jregex_'
