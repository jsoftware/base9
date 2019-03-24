NB. global definitions

NB. =========================================================
NB. control words:
NB. have to special case: for_abc. (include in CONTROLS)

j=. 'assert. break. case. catch. catchd. catcht. continue. do. else. elseif. end.'
CONTROLS=: ;: j,' fcase. for. if. return. select. try. while. whilst.'
CONTROLX=: 0 0 0 0 0 0 0 0 0 0 _1, 0 1 1 0 1 1 1 1
CONTROLN=: ;: 'case. catch. catchd. catcht. do. else. elseif. end. fcase.'

NB. begin, middle control words:
CONTROLB=: ;: 'for. if. select. try. while. whilst.'
CONTROLM=: CONTROLN -. <'end.'

FORMEND=: 'rem form end;';,')'
CONTS=: ';xywh';';cc';';cn'
