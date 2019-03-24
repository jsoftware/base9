NB. standalone.ijs
NB. functions for construction of standalone applications

coclass <'jp'

STANDALONE=: 0 : 0
load_z_=: require_z_=: script_z_=: ]
)

getstdenv=: 3 : 0
r=. freads jpath'~system/main/stdlib.ijs'
r=. r,freads jpath'~system/main/task.ijs'
r=. r,STANDALONE
hd=. 1 dir'~system/defs/hostdefs*.ijs'
for_h. hd do.
  hn=. '.ijs' taketo >{: fpathname >h
  r=. r,hn,'_j_=: 0 : 0',LF
  r=. r,freads h
  r=. r,')',LF
end.
qt=. freads jpath'~addons/ide/qt/qt.ijs'
r=. r, 'coclass ''jbaselibtag''' taketo qt
)

getlibs=: 3 : 0
libs=. jpath each getscripts_j_ cutnames y
r=. ''
if. 0=#libs do. return. end.
for_i. libs do.
  r=. r,freads i
end.
r
)

