
getscripts_j_ '~Main/jade/init.ijs'
getscripts_j_ 'numeric'
getscripts_j_ 'not_numeric'

hostcmd 'rm -rf format'
mkdir_j_ 'format/printf/moo'
'hello' fwrite 'format/hoo'
getscripts_j_ 'format/printf'
getscripts_j_ 'format/hoo'
getscripts_j_ 'format/printf/moo'

getscripts_j_ 'abc/'
getscripts_j_ '/abc'
getscripts_j_ 'a'
getscripts_j_ 'a/'
