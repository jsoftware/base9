NB. J vocabulary

adverbs=: '~ / \ /. \. } b. f. M. t. t:'

arguments=: 'm n u v x y'

t=. '= < <. <: > >. >: _: + +. +: * *. *: - -. -: % %. %: ^ ^.'
t=. t,' $ $. $: ~. ~: | |. |: , ,. ,: ; ;: # #. #: ! /: \: [ [: ]'
t=. t,' { {. {: {:: }. }: ". ": ? ?.'
t=. t,' A. c. C. e. E. i. i: I. j. L. o. p. p: q: r. s: u: x:'
t=. t,' _9: _8: _7: _6: _5: _4: _3: _2: _1:'
t=. t,' 0: 1: 2: 3: 4: 5: 6: 7: 8: 9:'
verbs=: t

t=. '^: . .. .: :  :. :: ;. !. !: " ` `: @ @. @: & &. &: &.:'
t=. t,' d. D. D: H. L: S: T.'
conjunctions=: t

t=. 'assert. break. case. catch. catchd. catcht. continue. do.'
t=. t,' else. elseif. end. fcase. for. goto. if. label.'
t=. t,' return. select. throw. trap. try. while. whilst.'
control_words=: t

nouns=: 'a. a:'

j=. ;: adverbs,' ',verbs,' ',conjunctions,' ',control_words,' ',nouns
SystemDefs=: j,;:'=. =:'
