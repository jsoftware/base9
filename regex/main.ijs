NB. main methods

rxfrom=: ,."1@[ <;.0 ]
rxeq=: {.@rxmatch -: 0 , #@]
rxin=: _1 ~: {.@{.@rxmatch
rxindex=: #@] [^:(<&0@]) {.@{.@rxmatch
rxE=: i.@#@] e. {.@{."2 @ rxmatches
rxfirst=: {.@rxmatch >@rxfrom ]
rxall=: {."2@rxmatches rxfrom ]

NB. =========================================================
rxapply=: 1 : 0
:
if. L. x do. 'pat ndx'=. x else. pat=. x [ ndx=. ,0 end.
if. 1 ~: #$ ndx do. 13!:8[3 end.
mat=. ({.ndx) {"2 pat rxmatches y
r=. u&.> mat rxfrom y
r mat rxmerge y
)

NB. =========================================================
rxcut=: 4 : 0
if. 0 e. #x do. <y return. end.
'beg len'=. |: ,. x
if. 1<#beg do.
  whilst. 0 e. d do.
    d=. 1,<:/\ (}:len) <: 2 -~/\ beg
    beg=. d#beg
    len=. d#len
  end.
end.
a=. 0, , beg ,. beg+len
b=. 2 -~/\ a, #y
f=. < @ (({. + i.@{:)@[ { ] )
(}: , {: -. a:"_) (a,.b) f"1 y
)

NB. =========================================================
rxerror=: 3 : 'lasterror'

NB. =========================================================
rxmatch=: 4 : 0
'p n'=. 2 {. boxopen x
regcomp p
r=. regmatch1 y
if. #n do. n{r end.
)

NB. =========================================================
rxmatches=: 4 : 0
'p n'=. 2 {. boxopen x
regcomp p
m=. regmatch1 y
if. _1 = {.{.m do. i.0 1 2 return. end.
s=. 1 >. +/{.m
r=. ,: m
while. s <#y do.
  if. _1 = {.{.m=. regmatch2 y;s do. break. end.
  s=. (s+1) >. +/ {.m
  r=. r, m
end.
if. #n do. n{"2 r end.
)

NB. =========================================================
rxmerge=: 1 : 0
:
p=. _2 ]\ m rxcut y
;, ({."1 p),.(#p){.(#m)$x
)

NB. =========================================================
rxrplc=: 4 : 0
pat=. >{.x
new=. {:x
if. L. pat do. 'pat ndx'=. pat else. ndx=. ,0 end.
if. 1 ~: #$ ndx do. 13!:8[3 end.
mat=. ({.ndx) {"2 pat rxmatches y
new mat rxmerge y
)

NB. =========================================================
rxutf8=: 3 : '(RX_OPTIONS_UTF8=: y) ] RX_OPTIONS_UTF8'
