NB. total

NB. =========================================================
NB. gettotal
NB.
NB. returns: names ; locales; total; her; reps

gettotal=: 4 : 0

if. 0=read'' do. a: return. end.

't s p'=. x

NB. get required data:
ndx=. PMNDX
lns=. PMLINES
if. t do. dat=. PMSPACE else. dat=. PMTIME end.

NB. subset data for totals if necessary:
if. 0 e. lns do.
  msk=. lns < 0
  dat=. msk # dat
  ndx=. msk # ndx
  lns=. msk # lns
end.

NB. ---------------------------------------------------------
NB. mask match begins and ends:
msk=. (lns = _1) maskit lns = _2
if. 0 e. msk do.
  dat=. msk # dat
  ndx=. msk # ndx
  lns=. msk # lns
end.

if. 0 = #ndx do. a: return. end.

NB. merge monadic and dyadic indices:
ndx=. ndx - 2 | ndx

NB. ---------------------------------------------------------
NB. get nub and totals for each index:
nub=. ~. ndx

rms=. nub getnames y  NB. get mask of required indices
req=. rms#nub

NB. ---------------------------------------------------------
'all her rep'=. t gettotals ndx;lns;dat;nub;rms

'nx lx j'=. |: PMDECODE #: req

NB. subtotal if required:
if. s do.
  'all her rep'=. |: nx +//. all,.her,.rep
  nx=. ~. nx
end.

NB. ---------------------------------------------------------
ndx=. \: her ,. all
her=. ndx{her
all=. ndx{all

NB. ---------------------------------------------------------
if. p < 100 do.
  len=. 1 + 1 i.~ (+/\her) >: (+/her) * p % 100
  curtailed=. len < #her
  if. curtailed do.
    curall=. +/ len }. all
    curher=. +/ len }. her
    her=. len {. her
    all=. len {. all
    ndx=. len {. ndx
  end.
else.
  curtailed=. 0
end.

rep=. ndx{rep

NB. ---------------------------------------------------------
NB. get short name and locale:
nam=. (ndx{nx) { PMNAMES

if. s do.
  loc=. (#nx) # a:
else.
  loc=. (ndx{lx) { PMLOCALES
end.

if. curtailed do.
  her=. her, curher
  loc=. loc, a:
  nam=. nam, <'[rest]'
end.

if. 1 ~: scale=. t { SCALE do.
  all=. scale * all
  her=. scale * her
end.

NB. add name and locale:
nam ; loc ; all ; her ; rep
)

NB. =========================================================
gettotals=: 4 : 0

'ndx lns dat nub req'=. y

bgn=. lns = _1
end=. lns = _2

NB. ---------------------------------------------------------
NB. all and reps:

NB. msk is values where level count is 1
NB. (avoids duplicate counts for recursive calls)

f=. 1: = [: +/\ (- (0: , 1: - }:))
msk=. f each ndx < /. bgn

ada=. ndx < /. dat * _1 ^ bgn

all=. msk +/@# &> ada
rep=. <. -: # &> ada

NB. ---------------------------------------------------------
NB. here...

NB. get starters and enders:
sbg=. }:bgn
snd=. sbg < }.end
dff=. (}. - }:) dat
str=. (bgn # ndx) ,. sbg # dff
edr=. ((0,snd) # ndx) ,. snd #dff

NB. ---------------------------------------------------------
NB. get the spacers:

spc=. i.0 2
level=. +/\ bgn - end

NB. non-trivial upticks :
ups=. (1 1 E. bgn) > 1 1 0 0 E. bgn
if. 1 e. ups do.

  ulvl=. ups # level
  upos=. I. ups

NB. get corresponding values for spacers:
  spd=. (0 1 E. bgn) *. level > 0
  slvl=. spd # level
  spos=. I. spd

  if. #spos do.

    lmax=. 1 + ({:upos) >. {:spos

    uelp=. lmax #. ulvl ,. upos
    ind=. /: uelp
    uelp=. ind { uelp
    uvrb=. ind { ups # ndx

    selp=. lmax #. slvl ,. spos
    svrb=. (uelp groupndx selp) { uvrb
    sdff=. spos { dff
    spc=. svrb ,. sdff
  end.

end.

NB. ---------------------------------------------------------
spcr=. i.0 2

NB. non-trivial recursion :
if. +./mrec=. (_2=PMLINES)*.PMNDX=1|.PMNDX do.
  rdat=. >(>{.x){PMTIME;PMSPACE
NB. get spacers after recursive calls:
  mdif=. mrec # rdat-1|.rdat
  spcr=. (mrec # PMNDX) ,.mdif
  spcr=. ((0{"1 spcr)e.ndx) # spcr
  spcr=. i.0 2
end.

NB. ---------------------------------------------------------
sum=. str , edr , spc , spcr
her=. (nub i. {."1 sum) +/ /. {:"1 sum

if. x=0 do.
  assert *./ all >: her
end.

|: req # all ,. her ,. rep
)
