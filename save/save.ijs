NB. main save
NB.
NB. ~install should be writable by the current user

cocurrent 'jpsave'
rmdir_j_ jpath '~Main/release'
mkdir_j_ jpath '~Main/release/install/system/main'

f=. 3 : 0
load '~Main/',y,'/build.ijs'
)

Source=: <;._2 (0 : 0)
compare
config
defs
jade
main
pacman
pm
pp
project
regex
socket
tar
task
)

f each Source

F=. cutopen 0 : 0
main
jade
compare
)

dat=. ; freads each (<jpath '~Main/release/') ,each F , each <'.ijs'
dat=. dat, 'cocurrent <''base'''

dat fwritenew jpath '~Main/release/install/system/main/stdlib.ijs'

'~Main/release/install/breaker.ijs' fcopynew '~Main/main/breaker.ijs'
'~install/breaker.ijs' fcopynew '~Main/main/breaker.ijs'

3 : 0''
if. IFWIN do.
  require 'pacman'
  dircopy_jpacman_ (jpath '~Main/release/install/system');jpath '~install/system'
else.
  (2!:0 ::0:) 'cp -r "',(jpath '~Main/release/install/system'),'" "',(jpath '~install'),'/."'
end.
)
