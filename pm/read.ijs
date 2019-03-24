NB. read

NB. =========================================================
NB. read PM and turn PM off
NB.
NB. defines:
NB.     PMSTATS     - PM statistics
NB.     PMNDX       - encoded indices: name, locale, valence
NB.     PMLINES     - line numbers
NB.     PMSPACE     - space
NB.     PMTIME      - time
NB.     PMNAMES     - boxed list of verb names (no locale)
NB.     PMLOCALES   - boxed list of locales
NB.     PMENCODE    - encode vector for PMTIME
NB.     PMDECODE    - decode vector for PMTIME
NB.
NB. return success flag

read=: 3 : 0

NB. don't re-read:
if. PMREAD do. 1 return. end.

if. 0 = +/ 6!:13'' do.
  smoutput 'There are no PM records'
  0 return.
end.

NB. ---------------------------------------------------------
NB. initially, use PMTIME for all data:
PMTIME=: 6!:11 ''
PMSTATS=: 6!:13 ''
6!:10 ''

NB. ---------------------------------------------------------
a=. 'recorded ',(0{PMSTATS) pick 'entry and exit only';'all lines'
a=. a,LF,'used and max record count:',;' ' ,each 'c' (8!:0) 3 2 { PMSTATS
if. 4 { PMSTATS do.
  a=. a,LF,'the PM data area has overflowed and records have been lost'
end.
smoutput a,LF

NB. ---------------------------------------------------------
NB. read and rework PMTIME to separate object and locale names
'namx locx all'=. 0 1 6 { PMTIME
PMNAMES=: (~.namx){all
namx=. PMNAMES i. namx{all
locndx=. #namx
PMLOCALES=: (~.locx){all
locx=. locndx + PMLOCALES i. locx{all
PMTIME=: (namx;locx;<PMNAMES,PMLOCALES) 0 1 6} PMTIME
PMNDX=: > 3 {. PMTIME

NB. store a copy in PM
PM=: PMTIME

NB. ---------------------------------------------------------
NB. drop __obj off name, and total with calls in same locale
ndx=. I. (1: e. '__'&E.) &> PMNAMES

if. #ndx do.
  nms=. (('__'&E. i. 1:) {. ]) each ndx { PMNAMES
  ndx merge nms
end.

NB. ---------------------------------------------------------
NB. merge foo with foo_loc_ if in the same locale
ndx=. I. ('_'"_ = {:) &> PMNAMES

if. #ndx do.
  namx=. 0 { PMNDX
  locx=. 1 { PMNDX
  nms=. }: each ndx { PMNAMES
  ind=. i:&'_' &> nms
  loc=. (>: ind) }.each nms
  loc=. (<'base') (I. 0=# &> loc) } loc
  nms=. ind {.each nms

NB. ensure locales match:
  lcs=. (namx i. ndx) { locx
  assert loc -: (lcs-locndx) { PMLOCALES

  ndx merge nms
end.

NB. ---------------------------------------------------------
PMLINES=: 3 pick PMTIME
PMSPACE=: 0, +/\ }: 4 pick PMTIME
PMTIME=: 5 pick PMTIME
PMDECODE=: 0,(#PMLOCALES),2
PMENCODE=: (2 * #PMLOCALES),2 1
PMNDX=: +/ PMENCODE * PMNDX - 0,locndx,1

PMREAD=: 1
)

NB. =========================================================
NB. merge
NB. change name index if already present and locales match
NB. updates PMNAMES, PMNDX
merge=: 4 : 0
ndx=. x
nms=. y
namx=. 0 { PMNDX
locx=. 1 { PMNDX
nmx=. PMNAMES i. nms
msk=. nmx < #PMNAMES

if. 1 e. msk do.
  plc=. (namx i. msk#nmx) { locx
  rlc=. (namx i. msk#ndx) { locx
  b=. plc=rlc
  if. 1 e. b do.
    inx=. b # I. msk
    nwx=. ((inx{ndx), namx) i. namx
    new=. nwx { (inx{nmx), namx
    PMNDX=: new 0 } PMNDX
  end.
end.

PMNAMES=: nms ndx} PMNAMES
)
