NB. util

cin=: e. ,
fmt0=: 'p<0 [>q<] >' & (8!:0)
fmt1=: 'p<1 [>q<] >' & (8!:0)
lcs=: * * 1 + >./\@:(_1&|.)@:(>./\"1@:(_1&|."1))
mindx=: }.@{.@/:~@(+/"1 ,. ])

NB. =========================================================
remltws=: 3 : 0
y=. y, LF
dat=. <;._2 y
msk=. CR = {: &> dat
dat=. (-msk) }. each dat
fn=. #~ ([: (+./\ *. +./\.) -.@(e.&(' ',TAB)))
dat=. fn each dat
dat=. dat ,each msk{'';CR
}: ; dat ,each LF
)
