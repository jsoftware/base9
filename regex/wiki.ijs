NB. regex examples in wiki docs

NB. ---------------------------------------------------------
pat=. '(x+)([[:digit:]]+)'
str=. 'just one xxx1234 match here'

pat rxmatch str

NB. just the 'x's and digits
(pat;1 2) rxmatches str

NB. reverse the whole match
pat |. rxapply str

NB. reverse just the digits
(pat;,2) |. rxapply str

NB. ---------------------------------------------------------
pat=. '[[:alpha:]][[:alnum:]_]*'  NB. pattern for J name
str=. '3,foo3=.23,j42=.123,123'   NB. a sample string

pat rxmatch str                   NB. find at index 2, length 4

pat=. '([[:alpha:]][[:alnum:]_]*) *=[.;]'   NB. subexp is name in assign

pat rxmatch str            NB. pattern at 2/6; name at 2/4
pat rxmatches str          NB. find all matches

pat=. rxcomp pat           NB. compile

rxhandles ''               NB. handles defined

rxinfo pat

pat rxmatches str          NB. use phandle like pattern

pat rxfirst str            NB. first matching substring

pat rxall str              NB. all matching substrings

pat rxindex &> '  foo=.10';'nothing at all'  NB. index of match

pat rxE str                NB. mask over matches

'[[:digit:]]*' rxeq '2342342'   NB. test for exact match

'[[:digit:]]*' rxeq '2342 342'  NB. test for exact match

pat rxmatch str             NB. entire and subexpression match

pat rxmatches str           NB.  all matches

NB. rxfrom selects substrings using index/length pairs
(pat rxmatches str) rxfrom str

]m=. (pat;,0) rxmatches str NB.  entire matches only

m rxcut str NB.  return alternating non-match/match boxes

('first';'second') m rxmerge str NB.  replace matches

pat |. rxapply str          NB.  reverse each match

(pat;,1) |. rxapply str     NB.   reverse just name part of match

NB. =========================================================
NB. compiled patterns
[pat1=. rxcomp '(x+)([[:digit:]]+)'
[pat2=. rxcomp '[[:alpha:]][[:alnum:]_]*'

pat1 rxmatch '10 one xxx1234 match'
(pat2;0) rxmatches '10 one xxx1234 match'

rxhandles''
rxinfo pat1
rxfree pat1, pat2

NB. =========================================================
NB. a bad pattern
Note''
rxcomp '[wrong'
rxerror''
)
