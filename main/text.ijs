NB.-text
NB.%text.ijs - text utilities
NB.-This script defines text utilities and is included in the J standard library.
NB.-Definitions are loaded into the z locale.

NB. =========================================================
NB.*cutpara v cut text into boxed list of paragraphs
NB.-syntax:
NB.+cutpara text
NB.-example:
NB.+   cutpara 'one',LF,'two',LF2,'three'
NB.+┌────────┬─────┐
NB.+│one two │three│
NB.+└────────┴─────┘
cutpara=: 3 : 0
txt=. topara y
txt=. txt,LF -. {:txt
b=. (}.b,0) < b=. txt=LF
b <;._2 txt
)

NB. =========================================================
NB.*foldtext v fold text to given width
NB.-syntax:
NB.+width foldtext text
NB.-example:
NB.+   A=: 'In the very middle of the court was a table, with a large dish of tarts upon it.'
NB.+
NB.+   30 foldtext A
NB.+In the very middle of the
NB.+court was a table, with a
NB.+large dish of tarts upon it.
foldtext=: 4 : 0
if. 0 e. $y do. '' return. end.
y=. ; x&foldpara each cutpara y
y }.~ - (LF ~: |.y) i. 1
)

NB. =========================================================
NB.*foldpara v fold single paragraph
NB.-Fold string of text with no LF.
NB.-
NB.-See also [foldtext](#foldtext) which calls this utility
NB.-on each paragraph.
NB.-
NB.-syntax:
NB.+width fold data
foldpara=: 4 : 0
if. 0=#y do. LF return. end.
r=. ''
x1=. >: x
txt=. y
while.
  ind=. ' ' i.~ |. x1{.txt
  s=. txt {.~ ndx=. x1 - >: x1 | ind
  s=. (+./\.s ~: ' ') # s
  r=. r, s, LF
  #txt=. (ndx + ind<x1) }. txt
do. end.
r
)

NB. =========================================================
NB.*topara v convert text to paragraphs
NB.-syntax:
NB.+topara text
NB.-Replaces single LFs not followed by blanks by spaces,
NB.-except for LF's at the beginning
NB.-example:
NB.+   topara 'one',LF,'two',LF2,'three'
NB.+one two
NB.+
NB.+three
topara=: 3 : 0
if. 0=#y do. '' return. end.
b=. y=LF
c=. b +. y=' '
b=. b > (1,}:b) +. }.c,0
' ' (I. b) } y
)
