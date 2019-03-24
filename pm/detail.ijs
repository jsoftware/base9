NB. detail

NB. =========================================================
NB. detail
NB. get detail for one verb
NB.
NB. x = 2 elements:
NB.      0 - time, 1 - space
NB.      0 - monad, 1 - dyad
NB. y = name;locale;given
NB.
NB. returns 2 element list:
NB.    (line numbers,. total,. here,. reps ) ; line text

getdetail=: 4 : 0

'type val'=. x
'name loc gvn'=. y

rep=. (val+1) linerep <name,'_',loc,'_'
if. 0 e. #rep do. ;~i.0 0 return. end.

NB. name indices:
ndx=. val + +/ PMENCODE * (PMNAMES i. <name),(PMLOCALES i. <loc),0
if. -. ndx e. PMNDX do. ;~i.0 0 return. end.

typename=. val pick 'monad';'dyad'
type getdetail1 typename;rep;ndx
)

NB. =========================================================
NB. getdetail1
NB. returns (line numbers,. total,. here,. reps) ; line text
getdetail1=: 4 : 0

'vid rep ind'=. y

if. -. ind e. PMNDX do.
  (i.0 4) ; '' return.
end.

dat=. x getdetail2 ind
lno=. > {."1 rep

NB. ---------------------------------------------------------
NB. tacit definition:
if. lno -: _1 do.
  dat ; vid, ' ', 2 pick , rep return.
end.

NB. ---------------------------------------------------------
replno=. _1 , > {."1 rep
repsno=. _1 ; 1 {"1 rep
reptxt=. 2 {"1 rep

NB. ---------------------------------------------------------
NB. convert statement lines into actual lines:

len=. # &> repsno
stm=. {."1 dat
lns=. sort (len # replno) {~ (; repsno) i. stm

NB. rep is non-zero only if first statement on a line:
rep=. 3 {"1 dat
rep=. rep * stm e. {.&> repsno

val=. (1 2 {"1 dat),. rep
key=. ~. lns
val=. key ,. lns +/ /. val

val=. replno ,. }."1 (replno e. {."1 val) expand val
val=. val , 1e8, (1 2{+/val), (<0 3){ val

txt=. (bracket }.replno) ,each reptxt
txt=. vid ; txt , <'total ',vid

val ; <txt
)

NB. =========================================================
NB. getdetail2
NB. returns statement numbers,. total,. here ,. reps
getdetail2=: 4 : 0

ind=. y

NB. ---------------------------------------------------------
NB. subset usage data:
msk=. PMNDX = ind

mbgn=. msk *. PMLINES = _1
mend=. msk *. PMLINES = _2

NB. ---------------------------------------------------------
NB. try to match begins and ends:

nbgn=. +/ mbgn
nend=. +/ mend

select. * nbgn - nend
case. 0 do.
  bnx=. mbgn i. 1
  enx=. >: mend i: 1
case. _1 do.
  bnx=. mbgn i. 1
  enx=. >: (+/\mend) i. nbgn
case. 1 do.
  bnx=. (+/\mbgn) i. nbgn - nend
  enx=. >: mend i: 1
end.

ndx=. PMNDX
lns=. PMLINES
val=. (x pick 'PMTIME';'PMSPACE')~

NB. ---------------------------------------------------------
NB. subset data for usage:
if. enx ~: #ndx do.
  ndx=. enx {. ndx
  lns=. enx {. lns
  val=. enx {. val
  mbgn=. enx {. mbgn
  mend=. enx {. mend
end.

if. bnx do.
  ndx=. bnx }. ndx
  lns=. bnx }. lns
  val=. bnx }. val
  mbgn=. bnx }. mbgn
  mend=. bnx }. mend
end.

if. 0 e. (#mbgn),#mend do. i.0 4 return. end.

msk=. 0 < mbgn usage mend

if. 0 e. msk do.
  ndx=. msk # ndx
  lns=. msk # lns
  val=. msk # val
  mbgn=. msk # mbgn
  mend=. msk # mend
end.

lvl=. mbgn usage mend

NB. ---------------------------------------------------------
NB. recursive code:

if. 1 +. 2 e. lvl do.
NB. here and total details:
NB. these are kept separate for development purposes,
NB. they should be in the same definition. This would avoid the
NB. nasty code below:

  rep=. getreps ind;ndx;lns;val
  her=. gethdetail ind;ndx;lns;val
  tot=. gettdetail ind;ndx;lns;val

  lns=. {."1 rep
  assert lns -: {."1 her
  assert lns -: {."1 tot
  res=. lns ,. ({:"1 tot) ,. ({:"1 her) ,. {:"1 rep

NB. ---------------------------------------------------------
NB. non-recursive code:
else.
  res=. getdetail3 ind;ndx;lns;val
end.

NB. ---------------------------------------------------------
NB. scale if need be:
if. 1 ~: scale=. x { SCALE do.
  res=. res *"1 [ 1,scale,scale,1
end.

)

NB. =========================================================
NB. getdetail3
NB. returns: lines, reps, all, here
getdetail3=: 3 : 0
'ind ndx lns val'=. y

NB. get total info:
tmsk=. ndx = ind

tlns=. tmsk # lns
tval=. tmsk # val

msk=. tlns ~: _2
tall=. msk # (}.tval,0) - tval
tlns=. msk # tlns

NB. ---------------------------------------------------------
NB. get here info:
f=. 0:`({: - {.) @. (0: < #)
toff=. msk # tmsk f;._1 val
ther=. tall - toff

0 colsum tlns,. tall,. ther ,. 1
)

NB. =========================================================
NB. gethdetail - "here" detail
NB. returns: lines, here

gethdetail=: 3 : 0

'ind ndx lns val'=. y

all=. (}.val,0) - val

NB. change the _2 lines to match the line before the previous _1,
NB. where the caller is the definition being analysed, ignoring
NB. level 1 lines.
NB. if the level is only 2, the caller must be the original definition.

bgn=. lns = _1
end=. lns = _2
hit=. ind = ndx
msk=. 1 < bgn usage end
her=. 2 >: bgn usage end
bgn=. msk *. bgn
end=. msk *. end

'bdx edx'=. bgn getmatchindex end
clr=. <: bdx

hndx=. ind (I. her) } ndx
hlns=. her } lns ,: (#;.1 hit) # hit # lns
sel=. ind = clr { hndx
clr=. sel # clr
edx=. sel # edx
lns=. (clr{hlns) edx} lns

msk=. 1 edx} ndx = ind
msk=. msk *. lns ~: _2
0 colsum msk # lns ,. all
)

NB. =========================================================
NB. gettdetail - "total" detail

gettdetail=: 3 : 0

'ind ndx lns val'=. y

bgn=. lns = _1
end=. lns = _2
all=. (}.val,0) - val

NB. renumber lines for ndx values:
j=. (ndx=ind) <;.1 lns
lns=. (# &> j) # {. &> j

NB. change the _2 lines to match the line before the previous _1,
NB. where level > 0
lvl=. +/\ bgn - 0, }:end
msk=. 1 < lvl
bnb=. msk *. bgn
enb=. msk *. end
'bdx edx'=. bnb getmatchindex enb
clr=. <: bdx
lns=. (clr{lns) edx} lns

msk=. lns ~: _2
0 colsum msk # lns ,. all
)

NB. =========================================================
getreps=: 3 : 0
'ind ndx lns val'=. y
msk=. (ndx=ind) *. lns ~: _2
0 colsum (msk # lns) ,. 1
)
