NB. additional validations

NB. =========================================================
ppval=: 3 : 0
dat=. words each y
pos=. <: +/\ # &> dat
dat=. ; boxxopen&.> dat
bgn=. (dat e. CONTROLB) +. findfor &> dat
end=. dat = <'end.'
lvl=. +/\bgn-end
if. _1 e. lvl do.
  lin=. pos I. lvl i. _1
  lin;'Unmatched control end' return.
end.
if. -. 0 = {: lvl do.
  lin=. pos I. lvl i: 1
  lin;'Unmatched control begin' return.
end.
if. bgn = #dat do. 0 return. end.
while. max=. >./ lvl do.
  b=. max = lvl
  b1=. _1 |. b
  ndx=. (,1+{:) I. b > +./\ b1 > b
  res=. ppval1 ndx{dat
  if. res -: 0 do.
    dat=. (<'') ndx}dat
    lvl=. (max-1) ndx} lvl
  else.
    'hit msg'=. res
    lin=. pos I. hit + {. ndx
    lin;msg
    return.
  end.
end.
0
)

NB. =========================================================
ppval1=: 3 : 0
dat=. y
select. > {. dat
case. 'if.' do.
  b=. 0 = +/ dat e. CONTROLM -. ;: 'else. elseif. do.'
  e0=. +/ dat = <'else.'
  e1=. +/ dat = <'elseif.'
  b=. b *. (2 > e0) *. 0 = e0 *. e1
  b=. b *. (+/ dat = <'do.') = 1 + e1
  if. e1 do.
    ix=. I. dat = <'elseif.'
    dx=. }. I. dat = <'do.'
    b=. b *. (#ix) = #dx
    if. b do.
      b=. b *. (i.@#-:/:) ,ix,.dx
    end.
  end.
case. 'select.' do.
  b=. 0 = +/ dat e. CONTROLM -. ;: 'case. fcase. do.'
  ix=. I. dat e. ;: 'case. fcase.'
  dx=. I. dat = <'do.'
  b=. b *. (#ix) = #dx
  if. b do.
    b=. b *. (i.@#-:/:) ,ix,.dx
  end.
case. 'try.' do.
  c=. ;: 'catch. catchd. catcht.'
  b=. (1 e. dat e. c) *. 0 = +/ dat e. CONTROLM -. c
case. 'while.';'whilst.' do.
  b=. (1 = +/ dat = <'do.') *. 0 = +/ dat e. CONTROLM -. <'do.'
case. do. NB. for.
  b=. 1 = +/ dat = <'do.'
  b=. b *. 0 = +/ dat e. CONTROLM -. <'do.'
end.
if. b do. 0 return. end.
0;'Unmatched control words'
)
