NB. comparison utilities
NB.%compare.ijs - comparison utilities
NB.-This script defines comparison utilities and is included in the J standard library.
NB.-Definitions are loaded into the jcompare locale with cover functions in z.

NB. =========================================================
NB.*compare v compare character data
NB.-syntax:
NB.+text1 compare text2
NB.-
NB.-Arguments may be character strings or character matrices
NB.-with trailing blanks ignored.
NB.-
NB.-Result shows lines not matched, in form:
NB.-
NB.+n [l] text
NB.-where:
NB.-   n    =  0=left argument, 1=right argument
NB.-  [l]   =  line number
NB.-  text  =  text on line
compare=: 4 : 0
if. x -: y do. 'no difference' return. end.
if. 0=#x do. 'empty left argument' return. end.
if. 0=#y do. 'empty right argument' return. end.
a=. conew 'jcompare'
r=. x comp__a y
coerase a
r
)

NB. =========================================================
NB.*fcompare v compare two text files
NB.-syntax:
NB.+opt fcompare files
NB.-where:
NB.-  opt is optional suffix
NB.-  files is 2 file names or prefixes, given
NB.-  either as character string cut on blanks
NB.-  or as 2-element boxed list
NB.-
NB.-example:
NB.+fcompare '~mywork/myutil.ijs ~/jbak/mywork/myutil.ijs'
NB.+'/myutil.ijs' fcompare jpath '~mywork';'/jbak/mywork'
fcompare=: 3 : 0
('';0) fcomp y
:
(x;0) fcomp y
)

NB. =========================================================
NB.*fcompares v compare two text files
NB.-as fcompare but ignoring different line separators
fcompares=: 3 : 0
('';1) fcomp y
:
(x;1) fcomp y
)
