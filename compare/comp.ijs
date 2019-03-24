NB. comp

NB. =========================================================
NB. comp
comp=: 4 : 0

sep=. ((LF cin x) +. LF cin y) { CRLF
if. 2=#$x do. x=. <@dtb"1 x
else. x=. <;._2 x,sep -. {:x end.
if. 2=#$y do. y=. <@dtb"1 y
else. y=. <;._2 y,sep -. {:y end.
if. x -: y do. 'no difference' return. end.

NB. ---------------------------------------------------------
XY=: x,y
AX=: X=: XY i. x
AY=: Y=: XY i. y
NX=: i.#x
NY=: i.#y
SX=: SY=: ''

NB. ---------------------------------------------------------
while. compend'' do. complcs'' end.

NB. ---------------------------------------------------------
NB. sort and format result:
sx=. /:~ SX
sy=. /:~ SY
x=. (fmt0 sx) ,each (sx { AX) { XY
y=. (fmt1 sy) ,each (sy { AY) { XY
r=. (x,y) /: (sx,.0),sy,.1
}: ; r ,each LF
)

NB. =========================================================
NB. x is suffix;options;displaynames
NB. options are additive:
NB.    1 = ignore different line separators (LF vs CRLF)
NB.    2 = ignore leading/trailing whitespace
NB.    3 = display filenames
fcomp=: 4 : 0
'p j n'=. 3 {. x
'ifws ifsep'=. 2 2 #: j
'x y'=. _2 {. ,&p each cutopen y
if. L. n do.
  'nx ny'=. n
else.
  nx=. x [ ny=. y
end.
f=. 1!:1 :: _1:
tx=. f x=. fboxname x
if. tx -: _1 do. 'unable to read ',nx return. end.
ty=. f y=. fboxname y
if. ty -: _1 do. 'unable to read ',ny return. end.
tx=. f2utf8 tx
ty=. f2utf8 ty
if. ifsep do.
  tx=. toJ tx
  ty=. toJ ty
end.
if. ifws do.
  tx=. remltws tx
  ty=. remltws ty
end.
f=. _3&{.@('0'&,@(":@]))
mth=. _3[\'   JanFebMarAprMayJunJulAugSepOctNovDec'
'a m d h n s'=. 6{.1 pick dx=. ,1!:0 x
fx=. (4":d),' ',(m{mth),'  ::' 0 3 6 9};f &.> 100|a,h,n,s
'a m d h n s'=. 6{.1 pick dy=. ,1!:0 y
fy=. (4":d),' ',(m{mth),'  ::' 0 3 6 9};f &.> 100|a,h,n,s
'nx ny'=. <"1>nx;ny
r=. 'comparing:',LF
r=. r,nx,fx,'  ',(":2 pick dx),LF
r=. r,ny,fy,'  ',(":2 pick dy),LF
r,tx compare ty
)
