NB. nouns for applying regular expressions to J code
NB.
NB.   Jname        name
NB.   Jnumitem     numeric item
NB.   Jnum         number or blank
NB.   Jcharitem    character item
NB.   Jchar        character
NB.   Jconst       constant
NB.
NB.   Jlassign     local assign
NB.   Jgassign     global assign
NB.   Jassign      any assign
NB.
NB.   Jlpar        left paren
NB.   Jrpar        right paren
NB.
NB.   Jsol         start of line
NB.   Jeol         end of line

Jname=: '[[:alpha:]][[:alnum:]_]*|x\.|y\.|m\.|n\.|u\.|v\.'
Jnumitem=: '[[:digit:]_][[:alnum:]_.]*'
Jnum=: '([[:digit:]_][[:alnum:]_.]*|[[:blank:]])?'
Jcharitem=: '''(''''|[^''])'''
Jchar=: '''(''''|[^''])*'''
Jconst=: '([[:digit:]_][[:alnum:]_.]*|[[:blank:]])?|''(''''|[^''])*''|a:|a\.'
Jlassign=: '=\.'
Jgassign=: '=:'
Jassign=: '=[.:]'
Jlpar=: '\('
Jrpar=: '\)'
Jsol=: '^[[:blank:]]*'
Jeol=: '[[:blank:]]*(NB\..*)?$'
