NB. tar util

NB. =========================================================
getchk=: 3 : 0
d=. 512{.y
d=. ' ' chksum}d NB. checksum blanks
c=. +/a.i.d         NB. checksum
v=. _6{.(48+(11#8)#:c){a.
v,null,' '
)

NB. =========================================================
ftree=: 3 : 0
r=. ''
d=. 1!:0<'/*',~jpath y
m=. 'd'=>4{each 4{"1 d
t=. m#{."1 d
r=. r,(<y,'/'),each t
for_n. t do.
  r=. r,ftree y,'/',>n
end.
r
)
