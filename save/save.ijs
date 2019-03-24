NB. main save

cocurrent 'jpsave'
hostcmd_j_ 'rm -rf ',jpath '~Main/release'
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

(jpath '~Main/release/install/breaker.ijs') fcopynew jpath '~Main/main/breaker.ijs'

NB. copy may fail if ~install is not writable by the current user
(2!:0 ::0:) 'cp -r "',(jpath '~Main/release/install/system'),'" "',(jpath '~install'),'/."'
(2!:0 ::0:) 'cp "',(jpath '~Main/release/install/breaker.ijs'),'" "',(jpath '~install'),'/."'
