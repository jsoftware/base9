NB. compile
NB.
NB. globals:
NB. cmhandles is a list of handles
NB. cmpatterns is a corresponding list of patterns
NB. cmtable is a corresponding table of compile,match,nsub

NB. =========================================================
NB. compile pattern, return handle
rxcomp=: 3 : 0
if. -.ischar y do. reghandlecheck y return. end.
ndx=. cmpatterns i. <y
if. ndx < #cmpatterns do. ndx{cmhandles return. end.
regcomp y
cmpatterns=: cmpatterns,<y
cmhandles=: cmhandles, cmseq=: cmseq + 1
cmtable=: cmtable,lastcomp,lastmatch,lastnsub
lasthandle=: ndx{cmhandles
)

NB. =========================================================
rxfree1=: 3 : 0
ndx=. cmhandles i. y
if. ndx=#cmhandles do. EMPTY return. end.
if. -. lastpattern -: ndx pick cmpatterns do.
  'comp match nsub'=. ndx{cmtable
  jpcre2_match_data_free <<match
  jpcre2_code_free <<comp
end.
ndx=. <<<ndx
cmtable=: ndx{cmtable
cmhandles=: ndx{cmhandles
cmpatterns=: ndx{cmpatterns
EMPTY
)

rxfree=: EMPTY [ rxfree1 &>

NB. =========================================================
rxinfo=: 3 : 0
ndx=. cmhandles i. y
if. ndx=#cmhandles do. 'handle not found: ',":y return. end.
((<ndx;2){cmtable);ndx{cmpatterns
)

NB. =========================================================
rxhandles=: 3 : 'cmhandles'
