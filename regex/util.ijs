NB. util

Rxnna=: '(^|[^[:alnum:]_])'
Rxnnz=: '($|[^[:alnum:]_.:])'
Rxass=: '[[:space:]]*=[.:]'

ischar=: 2=3!:0

NB. =========================================================
NB. user compilation flags (0=off, 1=on)
RX_OPTIONS_MULTILINE=: 1  NB. enable newline support, default on
RX_OPTIONS_UTF8=: 1  NB. enable UTF-8 support, default on

NB. =========================================================
NB. clear last values, not saved compiles
regclear=: 3 : 0
lastcomp=: lasthandle=: lastmatch=: lastnsub=: 0
lastpattern=: ''
EMPTY
)

NB. =========================================================
regcomp=: 3 : 0
if. -.ischar y do. reghandle y return. end.
if. (0<#y) *. y-:lastpattern do. return. end.
regfree''
lastpattern=: y
msg=. ,2
off=. ,2
flg=. PCRE2_MULTILINE*RX_OPTIONS_MULTILINE
lastcomp=: 0 pick jpcre2_compile (,y);(#y);flg;msg;off;<<0
if. 0=lastcomp do. regerror msg,off end.
lasthandle=: 0
lastmatch=: 0 pick jpcre2_match_data_create_from_pattern (<lastcomp);<<0
lastnsub=: 0 pick jpcre2_get_ovector_count <<lastmatch
EMPTY
)

NB. =========================================================
NB. regerror
regerror=: 3 : 0
m=. regerrormsg y
lasterror=: m
regfree''
m 13!:8[12
)

NB. =========================================================
regerrormsg=: 3 : 0
'msg off'=. 2 {. y,_1
m=. ({.~ i.&(0{a.)) 2 pick jpcre2_get_error_message msg;(256#' ');256
if. off >: 0 do.
  m=. m,' at offset ',(":off),LF
  m=. m,lastpattern,LF,(off#' '),'^',LF
end.
)

NB. =========================================================
regfree=: 3 : 0
if. lasthandle=0 do.
  if. lastmatch do.
    jpcre2_match_data_free <<lastmatch
  end.
  if. lastcomp do.
    jpcre2_code_free <<lastcomp
  end.
end.
regclear''
)

NB. =========================================================
NB. set handle
reghandle=: 3 : 0
reghandlecheck y
ndx=. cmhandles i. y
'lastcomp lastmatch lastnsub'=: ndx{cmtable
lastpattern=: ndx pick cmpatterns
lasthandle=: ndx{cmhandles
EMPTY
)

NB. =========================================================
reghandlecheck=: 3 : 0
if. y e. cmhandles do. y return. end.
m=. 'handle not found: ',":y
m 13!:8[12
)

NB. =========================================================
regmatch1=: 3 : 0
regmatchtab 0 pick jpcre2_match (<lastcomp);(,y);(#y);0;0;(<lastmatch);<<0
)

NB. =========================================================
regmatch2=: 3 : 0
's p'=. y
regmatchtab 0 pick jpcre2_match (<lastcomp);(,s);(#s);p;PCRE2_NOTBOL;(<lastmatch);<<0
)

NB. =========================================================
NB. get match table
regmatchtab=: 3 : 0
if. y >: 0 do.
  p=. 0 pick jpcre2_get_ovector_pointer <<lastmatch
  'b e'=. |:_2 [\ memr p,0,(2*lastnsub),4
  _1 0 (I.b=_1) } b,.e-b
elseif. y=_1 do.
  ,:_1 0
elseif. do.
  regerror y
end.
)

NB. =========================================================
NB. show all matches
regshow=: 4 : 0
m=. x rxmatches y
r=. ,:y
if. 0 = # m do. return. end.
for_i. i. 1 { $ m do.
  a=. i {"2 m
  x=. ;({."1 a) (+i.) each {:"1 a
  r=. r, '^' x } (#y) # ' '
end.
)

NB. =========================================================
NB. for now just check if comp is a valid compiled pattern
regvalid=: 3 : 0
len=. 0 pick jpcre2_pattern_info (<y);PCRE2_INFO_SIZE;<<0
rc=. 0 pick jpcre2_pattern_info (<y);PCRE2_INFO_SIZE;<len$' '
if. rc>:0 do. 1 else. 0[echo (regerrormsg rc),': ',":y end.
)

NB. =========================================================
showhandles=: 3 : 0
cls=. ;:'pattern handle comp match nsub valid'
if. #cmpatterns do.
  val=. regvalid &> {."1 cmtable
  dat=. (>cmpatterns);<@,."1 |: cmhandles,.cmtable,.val
else.
  dat=. (#cls)#<EMPTY
end.
cls,:dat
)

NB. =========================================================
NB. utility to show rxmatches at top level
showmatches=: 4 : 0
m=. x rxmatches y
r=. ,:y
if. 0 = # m do. return. end.
'b e'=. |:{."2 m
p=. ;b (+ i.) each e
r, '^' p } (#y) # ' '
)
