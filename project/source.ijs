NB. source
NB.
NB. readproject        read project file
NB. readprojectsource  read source filenames from project file
NB. readsource         read source files
NB. writesource        write source files
NB. writesourcex       write decommented source files

NB. =========================================================
readprojectsource=: 3 : 0
pn=. ('~'={.y) }. y
f=. getprojfile y
cocurrent 'jptemp'
coinsert 'jp'
ProjectPath=: fpath f
ProjectName=: ''
projread1 f
r=. Source
cocurrent 'jp'
coerase <'jptemp'
r
)

NB. =========================================================
readsource1=: 4 : 0
s=. (projname2path y)&fixdot&.> readprojectsource y
dat=. freads each s
if. (<_1) e. dat do.
  fls=. ; ' ' ,each toprojectfolder each s #~ (<_1) = dat
  sminfo 'Project Manager';'Unable to read:',fls
  _1 return.
end.
dat=. ;dat
if. x do. decomment_jp_ dat end.
)

NB. =========================================================
writesource1=: 4 : 0
'p t'=. y
dat=. x readsource1 p
if. _1 -: dat do. return. end.
t=. jpath t
mkdir fpath t
dat fwritenew t
EMPTY
)

readsource=: 0&readsource1
readsourcex=: 1&readsource1
writesource=: 0&writesource1
writesourcex=: 1&writesource1
