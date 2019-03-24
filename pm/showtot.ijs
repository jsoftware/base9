NB. show total

detailoption=: 3 : '2 {. y , (#y) }. 0 0'
totaloption=: 3 : '3 {. y , (#y) }. 0 0 90'

NB. =========================================================
NB. showtotal
NB.
NB. form: [opt] showtotal names
NB.
NB.  opt may be 1-3 numbers:
NB.        0 time 1 space  (default 0)
NB.        0=distinguish name+locale 1=total names
NB.        percentage of values to show (default 90)
NB.
NB.  names = list of names to include
NB.          ~list of names to exclude
NB.          '' = all names (except jpm locale)
NB.
NB.        where "names" is a list of names of the form:
NB.           abc        matches "abc" in any locale
NB.           abc_loc_   matches "abc" in locale "loc"
NB.           _loc_      matches all names in locale "loc"
showtotal=: 3 : 0
0 showtotal y
:
if. 0=read '' do. i. 0 0 return. end.
opt=. totaloption x
'x s p'=. opt
if. -. x e. 0 1 do.
  r=. 'first number in left argument should be either 0 (time)'
  r,' or 1 (space)' return.
end.
if. -. s e. 0 1 do.
  r=. 'second number in left argument should be either 0 (distinguish'
  r,' names by locale) or 1 (total names over locales)' return.
end.
if. s do.
  tit=. 'name (all locales)';'all';'here';'here%';'cum%';'rep'
else.
  tit=. 'name';'locale';'all';'here';'here%';'cum%';'rep'
end.
dat=. x showtotalfmt opt showtotal1 y
if. s do. dat=. (<<<1) { dat end.
dat=. > each dat
txt=. tit ,: dat
t=. x pick TIMETEXT;SPACETEXT
t, ,LF ,. ": txt
)

NB. =========================================================
showtotal1=: 4 : 0
't s p'=. x

'nam loc all her rep'=. x gettotal y
if. 0 = #nam do. a: return. end.

j=. her % +/her
pct=. 0.1 * <. 0.5 + 1000 * j
cpt=. <. 0.5 + 100 * +/\ j
if. t do. f=. spaceformat else. f=. timeformat end.

nam=. nam, <'[total]'
loc=. loc, <''
all=. all
her=. her, +/her
pct=. pct,100
cpt=. cpt,100
rep=. rep

nam; loc; all; her; pct; cpt; rep
)

NB. =========================================================
NB. format total data
showtotalfmt=: 4 : 0
'nam loc all her pct cpt rep'=. y

if. x do. f=. spaceformat else. f=. timeformat end.

all=. f all
her=. f her
pct=. 1 ffmt pct
cpt=. ":,.cpt
rep=. ":,.rep

nam; loc; all; her; pct; cpt; rep
)
