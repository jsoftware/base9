NB. task util

int=: {.@:(_2&ic)
sint=: 2&ic

i64=: {.@:(_3&ic)
si64=: 3&ic

ptr=: int`i64@.IF64
sptr=: sint`si64@.IF64

NB. =========================================================
NB. METHOD OF NAMED FIELDS
sndx=: i.@#@[ + {.@I.@E.

NB. struct=. 'valu' 'memb' sset structdef struct
sset=: 2 : '(m sndx n)}'

NB. value=. 'memb' sget structdef struct
sget=: 2 : '(m sndx n)&{'

szero=: # # (0{a.)"_

st64=: -.&'.'^:(-.IF64)

t=. 'Cbyt....Resv....Desk....Titl....XposYposXsizYsizXcntYcnt'
STARTUPINFO=:  st64 t,'FillFlagSwRs....Resv....Inph....Outh....Errh....'
PROCESSINFO=:  st64 'Proh....Thrh....PridThid'
SECURITYATTR=: st64 'Cbyt....Secd....Inhe'

'Outh Errh Inph Proh Thrh'=: ,"1&'....'^:IF64>;:'Outh Errh Inph Proh Thrh'

STARTF_USESTDHANDLES=: 16b100
STARTF_USESHOWWINDOW=: 1
WAIT_TIMEOUT=: 258
CREATE_NEW_CONSOLE=: 16b10
DUPLICATE_SAME_ACCESS=: 2

cdk=: 1 : '(''kernel32 '',m)&cd'

WaitForSingleObject=: 'WaitForSingleObject > i x i' cdk
CloseHandle=:         'CloseHandle         > i x' cdk"0
TerminateProcess=:    'TerminateProcess    > i x i' cdk
ReadFile=:            'ReadFile              i x *c i *i x' cdk
WriteFile=:           'WriteFile             i x *c i *i x' cdk
GetCurrentProcess=:   'GetCurrentProcess   > x' cdk

DuplicateHandleF=:    'DuplicateHandle       i  x x  x *x  i i i' cdk
CreatePipeF=:         'CreatePipe            i *x *x *c i' cdk
CreateProcessF=:      'CreateProcessW        i x *w x x i  i x x *c *c' cdk

DuplicateHandle=: 3 : 0
p=. GetCurrentProcess ''
h=. {. 4{:: DuplicateHandleF p;y;p;(,_1);0;0;DUPLICATE_SAME_ACCESS
CloseHandle y
h
)

NB. =========================================================
NB. 'hRead hWrite'=. CreatePipe Inheritable=0
NB.    ... FileRead/FileWrite ...
NB. CloseHandle hRead,hWrite
NB.
NB. Inheritable: 0 none, 1 for read, 2 for write
CreatePipe=: 3 : 0
'inh size'=. 2{.y,0
sa=. szero SECURITYATTR
sa=. (sint #SECURITYATTR) 'Cbyt' sset SECURITYATTR sa
sa=. (sint *inh) 'Inhe' sset SECURITYATTR sa
'hRead hWrite'=. ; 1 2{ CreatePipeF (,_1);(,_1);sa;size
if. 1=inh do. hRead=. DuplicateHandle hRead end.
if. 2=inh do. hWrite=. DuplicateHandle hWrite end.
hRead,hWrite
)

NB. =========================================================
NB. hProcess=. [hWriteOut[,hReadIn]] CreateProcess 'program agr1 agr2 ...'
NB.    ...
NB. CloseHandle hProcess
CreateProcess=: 3 : 0
'' CreateProcess y
:
'ow ir'=. 2{.x,0
si=. szero STARTUPINFO
si=. (sint #STARTUPINFO) 'Cbyt' sset STARTUPINFO si
f=. inh=. 0
if. +/ir,ow do.
  inh=. 1
  f=. CREATE_NEW_CONSOLE
  si=. (sint STARTF_USESTDHANDLES+STARTF_USESHOWWINDOW) 'Flag' sset STARTUPINFO si
  if. ow do.
    si=. (sptr ow) Outh sset STARTUPINFO si
    si=. (sptr ow) Errh sset STARTUPINFO si
  end.
  if. ir do. si=. (sptr ir) Inph sset STARTUPINFO si end.
end.
pi=. szero PROCESSINFO
'r pi'=. 0 _1{ CreateProcessF 0;(uucp y);0;0;inh; f;0;0;si;pi
if. 0=r do. 0 return. end.
ph=. ptr Proh sget PROCESSINFO pi
th=. ptr Thrh sget PROCESSINFO pi
CloseHandle th
ph
)

NB. =========================================================
NB. ph=. h CreateProcess 'program agr1 agr2 ...'
NB.    ...
NB. Wait ph;5000
NB. CloseHandle ph
Wait=: 3 : 0
r=. WaitForSingleObject y
if. WAIT_TIMEOUT=r do. TerminateProcess (0 pick y);_1 end.
)

NB. =========================================================
NB. ph=. h CreateProcess 'program agr1 agr2 ...'
NB.    ...
NB. r=. ReadAll h
NB. CloseHandle h,ph
ReadAll=: 3 : 0
ret=. ''
str=. 4096#'z'
while. 1 do.
  'r str len'=. 0 2 4{ ReadFile y;str;(#str);(,_1);0
  len=. {.len
  if. (0=r)+.0=len do.
    'ec es'=: cderx''
    if. -.ec e.0 109 do. ret=. _1 end.
    break.
  end.
  ret=. ret,len{.str
end.
ret
)

NB. =========================================================
NB. ph=. hr,hw CreateProcess 'program agr1 agr2 ...'
NB. r=. WriteAll hw
NB. CloseHandle hw
NB. r=. ReadAll hr
NB. CloseHandle hr,ph
WriteAll=: 3 : 0
:
while. #x do.
  'r x len'=. 0 2 4{ WriteFile y;x;(#x);(,_1);0
  len=. {.len
  if. (0=r)+.0=len do.
    'ec es'=: cderx''
    if. -.ec e.0 109 do. ret=. _1 end.
    break.
  end.
  x=. len}.x
end.
1
)
