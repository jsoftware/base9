NB. pplint

NB. =========================================================
NB. pplint
NB.
NB. pretty print + lint text argument
NB.
NB. Format_j_ is a numeric list:
NB.   0   0=no format, 1=do format, 2=do format and allow errors
NB.   1   soft tab width (0=hard tab)
NB.   2   if remove multiple spaces in code
NB.   3   if indent explicit definition
NB.   4   if indent select
NB.
NB. returns:
NB.      new text
NB. or   line number;error message

pplint=: 3 : 0
dat=. ucp y

'fmt wid rms exp sel'=. Format_j_
if. wid=0 do. spc=. TAB else. spc=. wid#' ' end.

NB. ---------------------------------------------------------
NB. remove any EOF
dat=. dat -. 26{a.
if. 0 = #dat do. return. end.

NB. ---------------------------------------------------------
NB. box lines:
dat=. toJ dat
iftermLF=. LF = {:dat
dat=. <;._2 dat, iftermLF }. LF

NB. ---------------------------------------------------------
NB. delete trailing blanks and tabs:
dat=. deltb each dat

NB. ---------------------------------------------------------
NB. check matched multiline definitions:
res=. checkmulti dat
if. L.res do. return. end.

NB. ---------------------------------------------------------
NB. ignore nouns from now on:
nounx=. I. masknouns dat
nouns=. nounx { dat
dat=. a: nounx} dat

NB. ---------------------------------------------------------
NB. delete leading blanks and tabs:
dat=. dellb each dat

NB. ---------------------------------------------------------
NB. remove multiple spaces (except in strings)
if. rms do.
  dat=. remspaces each dat
end.

NB. ---------------------------------------------------------
NB. calculate spacing:
indat=. spacing each dat
if. (<0) e. indat do.
  lin=. indat i. <0
  txt=. lin pick dat
  cnt=. +/'''' = txt {.~ ('NB.' E. txt) i. 1
  if. 2 | cnt do.
    msg=. 'Mismatched quotes'
  else.
    msg=. 'Could not parse line'
  end.
  if. 2>fmt do.
    lin;msg return.
  else.
    txt=. dat{~ g=. I.indat=<0
    indat=. ((0;0)&,@<@<@]&.> txt) g} indat
    echo lin;msg
  end.
end.

'in begin dat'=. |: > indat

NB. ---------------------------------------------------------
NB. check for mismatches
if. 0 ~: +/ in do.
  ins=. +/\ in
  if. _1 e. ins do.
    lin=. ins i. _1
    msg=. 'Unmatched end of control block'
  else.
    msk=. (dat = <,')') *. ins > 0
    if. 1 e. msk do.
      lin=. msk i. 1
      msg=. 'Unmatched start of control block'
    else.
      lin=. 0
      msg=. 'Mismatched control words'
    end.
  end.
  if. 2>fmt do.
    lin;msg return.
  else.
    echo lin;msg
  end.
end.

NB. ---------------------------------------------------------
NB. validate control structures
res=. ppval dat
if. -. res -: 0 do. if. 2>fmt do. return. else. echo res end. end.

NB. ---------------------------------------------------------
if. 0=fmt do. '' return. end.

NB. ---------------------------------------------------------
NB. format result:
in=. +/\ in
ins=. _1 |. in
ins=. 0 >. ins - begin
cmt=. 'NB.'&-: @ (3&{.)
ins=. ins * -. cmt &> dat
dat=. ins (([ # spc"_),]) each dat

NB. ---------------------------------------------------------
NB. indent select statements (where select begins line)
if. sel do.
  msk=. (<'select.') = {. @ words &> dat
  msk=. msk maskselect in
  dat=. msk (([ # spc"_),]) each dat
end.

NB. ---------------------------------------------------------
NB. indent explicit definitions
if. exp do.
  msk=. (dat=<,')') < maskexps dat
  dat=. msk (([ # spc"_),]) each dat
end.

NB. ---------------------------------------------------------
NB. adjust NB. == and -- to width 61
dat=. commentline each dat

NB. ---------------------------------------------------------
NB. add back nouns:
dat=. nouns nounx } dat

NB. ---------------------------------------------------------
dat=. ; dat ,each LF
dat=. (- -.iftermLF) }. dat

utf8 dat
)
