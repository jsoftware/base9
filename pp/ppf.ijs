NB. prettyprint form definitions in file
NB.
NB. example:
NB.    ppf  jpath '~temp\t1.ijs'
NB.
NB. not used in scripts

NB. =========================================================
NB.*ppf v pretty print form in script file
NB. ppf filename
ppf=: 3 : 0
y=. boxopen y
if. 1<#y do. ppf &> y return. end.

old=. 'b' freads y
if. old -: _1 do. sminfo 'Unable to read form' return. end.

new=. ppform old
if. 0 = new -: old do.
  new=. tolist new
  <new fwrites y
else.
  a:
end.
)

NB. =========================================================
NB.*ppform v pretty print form in file
NB. ppform boxed list
ppform=: 3 : 0

NB. partition on 0 : 0:
hit=. 1, }. (1: e. '0 : 0'&E.) &> y
dat=. hit <;.1 y

forms=. I. (1: e. FORMEND&E.) &> dat
if. 0 e. #forms do. y return. end.

; (ppform1 each forms { dat) forms} dat
)


NB. =========================================================
NB.*ppform1 v pretty print one block
ppform1=: 3 : 0

dat=. deb each y
dat=. dat -. a:

end=. dat {.~ (FORMEND E. dat) i. 1

NB. only want to look at lines with xywh, cc or cn statements:
msk=. maskselectside findcontrols ';',each end

head=. (msk i. 1) {. dat
tail=. (1 + msk i: 1) }. dat
form=. msk # end

head, a:, (ppcc form), a:, tail
)

NB. =========================================================
NB.*ppcc v pretty print controls block
ppcc=: 3 : 0

NB. remove empty lines:
NB. dat=. y -. a:

NB. ensure ; terminated, then list:
dat=. (, ';'"_ -. {:) each y

NB. chop on xywh:
blk=. ';', ; dat
msk=. ';xywh' E. blk

NB. if first element is not xywh, this is nonstandard:
if. 0 = {.msk do.
  sminfo 'Child controls do not start with xywh command.'
  dat return.
end.

blk=. (}:msk) <@(5&}.);.1 }.blk

ndx=. blk i.&> ';'
pos=. <@('xywh '&,) "1 ": 0 ". ndx {.&> blk
def=. (1+ndx) }.each blk

if. 0 e. 'cc'&-: @ (2&{.) &> def do.
  sminfo 'xywh command not followed by cc command'
  dat return.
end.

def=. 3 }. each def
ind=. def i.&> ' '
max=. 1 + >./ ind
nam=. ind max&{. @ {. each def
def=. (1+ind) }. each def
ind=. (def i.&> ' ') <. def i.&> ';'
max=. 1 + >./ ind
typ=. ind {. each def
grp=. 0, }. typ = <'groupbox'
f=. (max&{. @ {.) , }.
def=. nam ,each ind f each def
new=. pos ,each ';cc '&, each def
dat=. (grp{'';LF) ,each new
)
