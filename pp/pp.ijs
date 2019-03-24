NB. pretty printer
NB.
NB. pp       - pretty print scripts
NB.
NB. utils:
NB. pp1      - pp single file
NB. pprun    - pp text
NB. pplint   - main verb for pp and lint
NB.
NB. uses Format_j_ defined in configure

NB. =========================================================
NB. pp
NB. pretty print script files
NB. form: pp file
NB. stops on first error
NB. returns if changed flag for each file or _1 if error
pp=: 3 : 0
files=. boxxopen y
res=. (#files) $ 0
for_f. files do.
  s=. pp1 f
  if. s = _1 do. return. end.
  res=. s f_index } res
end.
res
)

NB. =========================================================
NB. pp1
NB. return _1 error, 0 = no change, 1 = change
pp1=: 3 : 0
old=. freads y
dat=. pplint old
if. 0 = #dat do. 0 return. end.
if. L. dat do.
  'lin msg'=. dat
  msg=. msg, ' in file:',LF,LF, > y
  (0 >. lin - 10) flopen >y
  if. lin do.
    pos=. 1 0 + (+/\LF = toJ old) i. lin + 0 1
    smsetselect pos
  end.
  info msg
  _1 return.
end.
if. dat -: old do.
  0
else.
  1 [ dat fwrites y
end.
)
