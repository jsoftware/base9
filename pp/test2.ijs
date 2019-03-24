NB. files
NB.
NB. flexist
NB. flread
NB. flwrite         file write
NB. flwrites        file write string
NB. flwritenew      file write if new

test=: 3 : 0
a=. 123
Note=. a + b
c=.456
  Note * c

NB. =========================================================
flexist=:1:@(1!:4)@< :: 0:
flread=:   1!:1 @ <
flwrite=: (1!:2 <) :: _1:
flwrites=: (toHOST@[ 1!:2 <@]) :: _1:

NB. =========================================================
foo=: 3 : 0
NB. for_s. '' do.
NB.     if. 2 do. 3 end.
NB.   else.
NB. end.
NB. if. a try. b. end.
NB. try. a do. catch. end.
if. (,'=') -: ~. (4+ndx) }. line do.
line=. pre,'NB. ',len#'='
 elseif. (,'-') -: ~. (4+ndx) }. line do.
    line=. pre,'NB. ',len#'-'
end.


NB. =========================================================
NB. writes data to file (if changed)
flwritenew=: 4 : 0
if. -. dat -: flread y do.dat flwrite y end.
EMPTY
)
