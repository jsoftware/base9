NB. migrate
NB. main function: migrate

cocurrent 'temp'
coinsert 'jp j'

F=. cutopen 0 : 0
util
nouns
files
methods
)

0!:0 (<jpath '~Main/project/') ,each F ,each <'.ijs'

NB. =========================================================
NB. exttree
NB.
NB. return files with given extension
NB.
NB. x is file extension
NB. y is starting path
exttree=: 4 : 0
r=. ''
t=. termsep y
selext=. (#~ (<x) = (-#x)&{.each) @: ({."1)
dirs=. ,<t
while. #dirs do.
  fpath=. (>{.dirs) &,
  dirs=. }. dirs
  dat=. 1!:0 fpath '*'
  if. #dat do.
    drs=. seldir dat
    if. #drs do.
      dirs=. (fpath @ (,&'/') each {."1 drs),dirs
    end.
    r=. r, fpath each selext dat
  end.
end.
sort r
)

NB. =========================================================
migrate=: 3 : 0
a=. '.ijp' exttree jpath y
migrate1 &> a
)

NB. =========================================================
projwrite=: 3 : 0
if. 0=#ProjectName do. return. end.
projwritenew Project
if. #Source do.
  (;LF,~each projsname each Source) fappends Project
end.
)

NB. =========================================================
migrate1=: 3 : 0
smoutput y
t=. 'b' freads y
t=. (1 + (7 {.each t) i. <'coclass')}. t
0!:100 tolist 'coclass ''jprojectm''';t
coinsert 'temp'
s=. a: -.~ <;._2 PRIMARYFILES_jprojectm_,LF
s=. jpath each s
p=. 0 pick fpathname y
Source=: (spath each s) ,each <'.ijs'
Project=: (_3}.y),'jproj'
ProjectName=: fpath tofoldername p
ProjectPath=: }:p
smoutput Project
projwrite ''
)

NB. =========================================================
fixproj=: 3 : 0
d=. {."1 [ 1 dirtree y,'/*.jproj'
fixproj1 each d
)

NB. =========================================================
fixproj1=: 3 : 0
dat=. freads y
if. -. 1 e. '=:' E. dat do. 0 return. end.
hdr=. (dat i. LF) {. dat
cocurrent 'temp'
0!:100 dat
src=. Source
cocurrent 'base'
new=. hdr,LF,ProjHdr_jp_,LF,src
new fwrites y
)

dbg 1
dbstops''
NB. smoutput fixproj jpath '~Project7'
NB. smoutput migrate '~Main/pacman'

