NB. files

NB. =========================================================
fwritenew=: 4 : 0
dat=. ,x
if. dat -: fread y do. 0 return. end.
dat fwrite y
)

NB. =========================================================
isdir=: 3 : 0
d=. 1!:0 y
if. 1 ~: #d do. 0 return. end.
'd' = 4 { 4 pick ,d
)

NB. =========================================================
projread=: 3 : 0
projclear''
if. 0=#Project do. return. end.
projread1 Project
)

NB. =========================================================
projread1_jp_=: 3 : 0
projclear''
Build=: 'build.ijs'
Run=: 'run.ijs'
Source=: ''
dat=. 'b' freads y
if. dat-:_1 do.
  Build=: projfname Build
  Run=: projfname Run return.
end.
dat=. dat #~ (<'NB.') ~: 3 {.each dat
if. 1 e. '=:' E. ;dat do.
  0!:100 ; dat ,each LF
  Source=: cutLF Source
else.
  Source=: dat
end.
Build=: projfname Build
Run=: projfname Run
Source=: projfname each extsrc each deb each Source -. a:
EMPTY
)

NB. =========================================================
ProjHdr=: fixNB_jp_ 0 : 0
nb.
nb. defines list of source files.
nb. path defaults to project directory.
)

NB. =========================================================
NB. project write new
NB. y is new project filename
projwritenew=: 3 : 0
r=. 'NB. project: ',(getprojname''),LF,ProjHdr,LF
r fwrites y
)
