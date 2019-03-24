NB. pretty print utils
NB.
NB. EXPDEFINE
NB. NOUNDEFINE
NB.
NB. indent1
NB. notquotes
NB. notcomments
NB. notqc
NB. commentline
NB. maskexps
NB. maskexp1
NB. masknouns
NB. masknoun1
NB. spacing

NB. =========================================================
NB. multiline explicit definitions
EXPDEFINE=: <@;: ;._2 (0 : 0)
1 : 0
2 : 0
3 : 0
4 : 0
1 define
2 define
3 define
4 define
adverb : 0
conjunction : 0
verb : 0
monad : 0
dyad : 0
adverb define
conjunction define
verb define
monad define
dyad define
)

NB. =========================================================
NB. multiline noun definitions
NOUNDEFINE=: <@;: ;._2 '\' -.~ (0 : 0)
0 \: 0
noun \: 0
0 \define
noun \define
)

NB. =========================================================
findfor=: 'for_'&-: @ (4&{.) *. ('.'&=) @ {:
info=: sminfo @ ('Lint'&;)
lastones=: > (}. , 0:)  NB. last ones in partition
findcontrols=: (1: e. (CONTS"_ (1: e. E.) &> <)) &>
firstones=: > (0 , }:)
maskselectside=: +./\ *. +./\.

NB. =========================================================
NB. notquotes - return 1 where text is not in quotes
notquotes=: (+: ~:/\)@(''''&=)

NB. =========================================================
NB. notcomments - return 1 where text is not in commments
notcomments=: ([: +./\. (=&' ') +: [: +./\ 'NB.'&E. > ~:/\@(''''&=))

NB. =========================================================
NB. notquotes or comments
notqc=: (notquotes *. notcomments) f.

NB. =========================================================
NB. debq  - delete blanks in unquoted text:
debq=: #~ (+. 1: |. (> </\))@(notquotes <: ' '&~:)

NB. =========================================================
checkmulti=: 3 : 0
tok=. words @ (#~ notqc) each y
bgn=. masknoun1 &> tok
end=. tok=<;:')'
end=. 2 }. ; (1 0,bgn) < @ (</\) ;. 1 [ 0 1,end
if. (+/bgn) = +/end do.
  nounmask=. (+.~:/\) bgn +. end
  bgn=. nounmask < maskexp1 &> tok
  end=. nounmask < tok=<;:')'
  if. bgn pairup end do. 0 return. end.
end.
lvl=. (+/\bgn) - +/\end
if. 2 e. lvl do.
  lin=. (<:(bgn#lvl) i. 2) { I. bgn
  msg=. lin pick y
elseif. 1 = {:lvl do.
  lin=. 1 i.~ *./\.1 = lvl
  msg=. 'Definition not completed'
elseif. 1 do.
  lin=. lvl i. _1
  msg=. 'Unmatched closing paren'
end.
msg=. 'Could not match begin and end of multi-line definition:',LF,LF,msg
lin;msg
)

NB. =========================================================
commentline=: 3 : 0
line=. y
ndx=. (y e. ' ',TAB) i. 0
if. -. 'NB. ' -: 4 {. ndx }. line do.
  line return.
end.
pre=. ndx {. line
len=. 57 - +/ 1 + 3 * pre = TAB
if. (,'=') -: ~. (4+ndx) }. line do.
  line=. pre,'NB. ',len#'='
elseif. (,'-') -: ~. (4+ndx) }. line do.
  line=. pre,'NB. ',len#'-'
end.
line
)

NB. =========================================================
NB. delete leading/trailing tabs and blanks
dellb=: #~ +./\ @: -. @ e.&(' ',TAB)
deltb=: #~ +./\.@: -. @ e.&(' ',TAB)

NB. =========================================================
NB. indent1
indent1=: 3 : 0
if. 0=L.y do. 0 return. end.
tok=. y
x=. I. findfor &> tok
tok=. (<'for.') x} tok
+/ (CONTROLX,0) {~ CONTROLS i. tok
)

NB. =========================================================
NB. maskexps
NB. argument is boxed list of lines
NB. result is 1 where lines are part of an explicit definition
NB. 0 is failure
maskexps=: 3 : 0
tok=. words @ (#~ notqc) each y
bgn=. maskexp1 &> tok
end=. tok=<;:')'
end=. 2 }. ; (1 0,bgn) < @ (</\) ;. 1 [ 0 1,end
~: /\. bgn +. end
)

NB. =========================================================
maskexp1=: 3 : 0
1 e. EXPDEFINE 1&e.@E. &> <y
)

NB. =========================================================
NB. masknouns
NB. argument is boxed list of lines
NB. result is 1 where lines are part of a noun definition
masknouns=: 3 : 0
tok=. words @ (#~ notqc) each y
bgn=. masknoun1 &> tok
if. -. 1 e. bgn do. return. end.
end=. tok = <;:')'
end=. 2 }. ; (1 0,bgn) < @ (</\) ;. 1 [ 0 1,end
~: /\. bgn +. end
)

NB. =========================================================
masknoun1=: 3 : 0
if. 0=#y do. 0 return. end.
if. 1 e. NOUNDEFINE 1&e.@E. &> <,y do. 1 return. end.
if. (<'Note') ~: {.y do. 0 return. end.
if. (,<'Note') -: y do. 1 return. end.
if. -. (#y) e. 2 3 do. 0 return. end.
('NB.'-:3{.2 pick y,<'NB.') > (1{y) e. SystemDefs
)

NB. =========================================================
NB. mask maskselect in
maskselect=: 4 : 0
msk=. x
in=. y
ndx=. msk i. 1
if. ndx=#msk do. msk return. end.
in=. msk <;.1 in
(ndx#0) ,; maskselect1 each in
)

maskselect1=: 0 , [: *./\ }. >: {.

NB. =========================================================
NB. check if begin pairup with end
pairup=: 4 : 0
r=. +/\x - y
*./ (0={:r), r e. 0 1
)

NB. =========================================================
NB. remspaces v remove multiple spaces
remspaces=: 3 : 0
msk=. notcomments y
(debq msk#y), (-.msk)#y
)

NB. =========================================================
NB. spacing
NB. returns: indent;begin;newline
NB. or 0 on tokenizer error
NB. begin=1 if control word begins line
spacing=: 3 : 0
in=. 0
bgn=. 0
msk=. notcomments y
txt=. msk#y
com=. (-.msk)#y

if. #txt do.
  tok=. words1 txt
  if. tok -: 0 do. return. end.
  if. #tok do.
    in=. indent1 tok
    bgn=. ({.tok) e. CONTROLN
    if. 1=#tok do.
      txt=. ;tok
    else.
      txt=. spacing1 dlb txt
    end.
  else.
    txt=. ''
  end.
else.
  com=. dlb com
end.

in;bgn;<<txt,com
)

NB. =========================================================
NB. is the first or second def needed anywhere?
words=: 7&u:&.>@:;:@(8&u:) :: ]
words1=: 7&u:&.>@:;:@(8&u:) :: 0:

NB. =========================================================
f=. #~ (=&' ') *: 1: |. notquotes *. '=:'&E. +. '=.'&E.
noblankbefore=: f f. ^: _

f=. #~ 1: + [: j. (1: |. =&' ') < _1: |. notquotes *. '=:'&E. +. '=.'&E.
blankafter=: f f. ^: _

NB. =========================================================
NB. alternative definition for special cases only:
spacing1=: blankafter @ noblankbefore
