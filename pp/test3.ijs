NB. test script for pp
NB.
NB. don't pp this file - use a copy

NB. ==============
foo=: 3 : 0
if. x do.
y
else.
z
end.
)

NB. ==============
foo  =: 3 : 0
select. a
NB. weqwe  '123
case. 1 do.
if. x do. y else. z end.
case. 2 do.
NB. ---
if. x do. y
NB. ---
elseif. z do. s
elseif. 1 do. t
end.
case. 3 do.
for_i. i.10 do.
'loop'
end.
   end.
)

NB. =============================================
commentline=: 3 : 0
line=. y
if. 'NB. '-:   4{.line do.
if. (,'=') -: ~. 4}.line do.
		line=. 'NB. ',57#'='
    			      elseif. (,'-') -: ~. 4}.line do.
line=. 'NB. ',57#'-'
	end.
end.
line
)

Note 2
lines have trailing blanks:
a   =:
if.
)

0 : 0
a   =:
  if.
)


runtest=: 3 :  0
load'~system/util/pp.ijs'
OLD=:jpath'~Source/main/pp/test.ijs'
TMP=:  jpath  '~temp/t1.ijs'
)
