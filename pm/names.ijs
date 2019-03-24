NB. names.ijs

NB. =========================================================
NB. splitname  - split open name into name;locale
f=. '_'"_ = {:
g=. ;&a:
h=. (i:&'_') ({.;}.@}.) ]
k=. [: h }:
splitname=: g`k @. f f.

NB. =========================================================
NB. fullname name;locale
fullname=: 3 : 0
'name loc'=. 2 {. boxopen y
if. '_' ~: {:name do. name,'_',loc,'_' else. name end.
)

NB. =========================================================
NB. getnames
NB. form: indices getnames selection
NB. get required names:
NB.  y = list of names to include
NB.          ~list of names to exclude
NB.          '' = all names (except jpm locale)
NB.
NB.        where "names" is a list of names of the form:
NB.           abc        matches "abc" in any locale
NB.           abc_loc_   matches "abc" in locale "loc"
NB.           _loc_      matches all names in locale "loc"
NB.
NB. all names after "~" in y are excluded
NB.
NB.  x = list of possible indices
NB.
NB. returns a boolean mask for selected names

getnames=: 4 : 0

'nms lcs j'=. |: PMDECODE #: x
xjp=. lcs ~: PMLOCALES i. <'jpm'         NB. not jpm locale

if. 0=#y do. xjp return. end.

y=. ;: y
sns=. splitname &> y

NB. ---------------------------------------------------------
NB. inclusions and exclusions:
ndx=. y i. <,'~'
rin=. 1 getnames1 x;nms;lcs;<ndx {. sns
rot=. 0 getnames1 x;nms;lcs;<(ndx+1) }. sns

xjp *. rin > rot
)

NB. =========================================================
NB. returns selected
getnames1=: 4 : 0

'ndx nms lcs sel'=. y

if. 0=#sel do. (#ndx)#x return. end.

nmx=. PMNAMES i. {."1 sel
lcx=. PMLOCALES i. {:"1 sel

msk=. (#ndx) # 0

len=. #. (0: < #) &> sel
if. 1 e. b=. len=1 do.
  msk=. msk +. lcs e. b#lcx
end.
if. 1 e. b=. len=2 do.
  msk=. msk +. nms e. b#nmx
end.
if. 1 e. b=. len=3 do.
  msk=. msk +. (lcs e. b#lcx) *. nms e. b#nmx
end.
)


NB. =========================================================
NB. getshortname
getshortname=: 3 : 0
'name loc'=. 2 {. boxopen y
if. #loc=. loc -. ' ' do.
  ((name i.'_') {. name),'_',loc,'_'
else.
  name
end.
)

NB. =========================================================
NB. getnameloc
NB. returns: name;locale;givenname
NB.
NB. Example:
NB.    getnameloc 'abc_def_'
NB. 'abc';'def';'abc_def_'

getnameloc=: 3 : 0

y=. dab y

if. 0 = #y do.
  '';'base';'' return.
end.

if. L. y do.
  select. #y
  case. 1 do.
    name=. dab > y
    loc=. 'base'
    given=. name
  case. 2 do.
    'name loc'=. dab each y
    if. #loc do.
      given=. name,'_',loc,'_'
    else.
      given=. name
      loc=. 'base'
    end.
  case. do.
    'invalid name' assert 0
  end.

else.

  given=. y
  'name loc'=. dab each splitname y
  if. 0=#loc do. loc=. 'base' end.

end.


name;loc;given
)
