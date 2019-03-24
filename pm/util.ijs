NB. utils for perfmon

NB. =========================================================
boxopencols=: ]`(<"1)@.(L. = 0:)
bracket=: ('['"_ , ": , '] '"_) each
dab=: -. & ' '
firstones=: > (0: , }:)
groupndx=: 4 : '<: (#x) }. (+/\r<#x) /: r=. /: x,y'
info=: sminfo @ ('Performance Monitor'&;)
lastones=: > (}. , 0:)
maskdef=: [: * [: +/\ _1&= - 0: , }:@:(_2&=)
nolocale=: (i.&'_') {. ]
sort=: /:~ :/:
takeafter=: [: ] (#@[ + E. i. 1:) }. ]
taketo=: [: ] (E. i. 1:) {. ]
takewid=: ] ` ((WID&{.) , '...'"_) @. (WID"_ < #)
unwords=: ;: inverse
usage=: [: +/\ (- 0: , }:)
join=: ,.&.>/

NB. =========================================================
colsum=: 4 : 0
nub=. ~. key=. x{"1 y
nub /:~ nub x}"_1 1 key +//. y
)

NB. =========================================================
NB. begin getmatchindex end
NB.
NB. begin and end are booleans indicating begins and ends
NB. of processes.
NB.
NB. begins and ends must match.
NB.
NB. 1 = {. begin
NB. 1 = {: end
NB.
NB. returns two items:
NB.    list of begin indices
NB.    list of end indices corresponding to begin indices
NB.
NB.     BGN=. 1 0 0 1 1 0 0 0 0 1 0 0 0 0
NB.     END=. 0 0 0 0 0 1 0 1 0 0 1 0 0 1
NB.
NB.     (i.#BGN) , BGN ,: END
NB.  0 1 2 3 4 5 6 7 8 9 10 11 12 13
NB.  1 0 0 1 1 0 0 0 0 1  0  0  0  0
NB.  0 0 0 0 0 1 0 1 0 0  1  0  0  1
NB.     BGN getmatchindex END
NB.  0 3 4 9 ; 13 7 5 10

getmatchindex=: 4 : 0
bgn=. x
end=. y
level=. +/\ bgn - 0 , }: end
bpos=. I. bgn
blvl=. bpos { level
epos=. I. end
elvl=. epos { level
max=. 1 + #end
bndx=. max #. blvl ,. bpos
endx=. max #. elvl ,. epos
mtch=. bndx groupndx endx
bpos ; (/: mtch { /: bndx) { epos
)

NB. BGN=. 1 0 0 1 1 0 0 0 0 1 0 0 0 0
NB. END=. 0 0 0 0 0 1 0 1 0 0 1 0 0 1
NB. BGN=. 1 1 0 0 1 0
NB. END=. 0 0 1 1 0 1
NB. BGN=. 1 1 0 1 0 0
NB. END=. 0 0 1 0 1 1

NB. =========================================================
NB. getpm1 - get pm for one definition
getpm1=: 3 : 0
'nam loc'=. splitname y
nms=. _1 pick PM
nmx=. nms i. <nam
lcx=. nms i. <loc
msk=. ((0 pick PM) e. nmx) *. ((1 pick PM) e. lcx)
msk&# each }:PM
)

NB. =========================================================
NB. subpm - subset pm for given indices
subpm=: 3 : 0
nms=. _1 pick PM
dat=. y&{ each }:PM
ind=. 0 pick dat
loc=. 1 pick dat
nub=. /:~ ~. ind,loc
nms=. nub { nms
loc=. nub i. loc
ind=. nub i. ind
dat=. (<ind) 0 } dat
dat=. (<loc) 1 } dat
dat , <nms
)

NB. =========================================================
tominus=: 3 : 0
dat=. , y
($y) $ '-' (I. dat='_')} dat
)
