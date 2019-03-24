NB. maskit
NB.
NB. =========================================================
NB. form: bgn maskit end
NB.
NB. bgn marks function call begin
NB. end marks function call end
NB.
NB. Ideally, begins and ends are exactly matched. However,
NB. it is possible that in the timing data as reported, some
NB. functions end without having started, or begin without ending.
NB.
NB. this verb returns a mask that can be applied to the data,
NB. for calls where begins and ends are exactly matched
NB.
NB. Example:
NB.
NB. bgn = 0 1 0 0 1 0 0 0 0 1 0 0 1 0 1 1 0 1 0 1 0 0
NB. end = 1 0 0 0 0 1 1 1 1 0 1 1 0 0 0 0 0 0 1 0 1 1
NB. res = 0 1 1 1 1 1 1 0 0 1 1 0 0 0 0 1 1 1 1 1 1 1

maskit=: 4 : 0

bgn=. x
end=. y

NB. mask from beginning:
sb=. +/\bgn
se=. +/\end
re=. +/\ inverse se + 0 <. <./\sb - se
mskbgn=. 0 < +/\ bgn - 0,}:re

NB. mask from end:
sb=. +/\.bgn
se=. +/\.end
rb=. +/\. inverse sb + 0 <. <./\.se - sb
mskend=. 0 < +/\. end - }.rb,0

mskbgn *. mskend
)
