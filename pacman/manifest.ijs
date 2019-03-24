NB. manifest
NB.
NB. for reading manifest from git repo

NB. =========================================================
getmanifesturl=: 3 : 0
'tag rep cmt'=. y
select. tag
case. 'github' do.
  p=. <;.2 rep,'/'
  rpo=. ;2 {. p
  sub=. ;2 }. p
  'https://raw.githubusercontent.com/',rpo,cmt,'/',sub,'manifest.ijs'
case. do.
  ''
end.
)

NB. =========================================================
NB. read manifest returning success flag
readmanifest=: 3 : 0
url=. getmanifesturl y
if. 0=#url do. 0 return. end.
'rc man'=. gitrepoget url
if. rc do. 0 return. end.
dat=. freads man
if. dat -: _1 do.
  0[log 'could not read manifest for ',y return.
end.
ferase man
if. 0=valmanifest dat do. 0 return. end.
defmanifest dat
)

NB. =========================================================
defmanifest=: 3 : 0
defmanifest1 y

NB. valid platforms:
pfm=. (tolower UNAME)&, each '';IF64{'32';'64'

NB. read files and other nouns:
files=. 'FILES'&, each '';toupper each pfm
other=. ;: 'DEPENDS FOLDER PLATFORMS RELEASE VERSION'
all=. files,other
(all)=: <''
n=. all intersect nl_jpacmandef_ 0
(n)=: ". each n ,each <'_jpacmandef_'
coerase <'jpacmandef'

FILES=: ~. cutLF ;LF ,each ". each files
if. 0=#FILES do. 0[echo 'Files not given' return. end.
FILES=: ~. FILES, <'manifest.ijs'

if. 0=#FOLDER do. 0[echo 'Folder not given' return. end.
if. #PLATFORMS do.
  if. 0=#pfm intersect ;: PLATFORMS do.
    0[echo 'Platform not supported for this addon' return.
  end.
end.
if. #RELEASE do.
  rel=. <./0 ". 'j' -.~ RELEASE
  ver=. 0 ". 'j' -.~ ({.~i.&'/')9!:14''
  if. rel > ver do.
    0[echo 'Release not supported for this addon: ',9!:14'' return.
  end.
end.
if. #DEPENDS do.
  dependcheck a: -.~ deb each <;._2 termLF DEPENDS
end.

1
)

NB. =========================================================
defmanifest1=: 3 : 0
coerase <'jpacmandef'
cocurrent 'jpacmandef'
0!:100 y
)

NB. =========================================================
dependcheck=: 3 : 0
m=. (0 = #@(1!:0)) &> (<jpath '~addons/') ,each y , each <'/*'
if. 1 e. m do.
  echo 'This addon requires addons to be installed:',;' ',each m#y
end.
)

NB. =========================================================
NB. valmanifest
NB. validate argument only has assignments of character strings
valmanifest=: 3 : 0
b=. <;._2 y
b=. dlb each b
b=. b -. a:
b=. b #~ (<'NB.') ~: 3 {.each b
c=. ;: :: 0: each b
msk=. c ~: <0
c=. msk # c

NB. ---------------------------------------------------------
NB. remove multiline nouns
bgn=. noundef c
ndx=. bgn i. 1
hdr=. ndx {. c
c=. bgn <;.1 c
len=. # &> c
ndx=. c i. &> <<,<,')'
if. 1 e. ndx = len do.
  txt=. towords 0 pick ((ndx=len) i. 1) pick c
  log 'invalid manifest for ',x,' at definition: ',txt
  0 return.
end.
c=. hdr, ; (ndx+1) }.each c
c

NB. ---------------------------------------------------------
NB. remove trailing comments
msk=. (<'NB.') = (3: {. >@{:) each c
c=. (-msk) }.each c

NB. ---------------------------------------------------------
NB. everything else should be global string assignments
msk=. 3 ~: # &> c
if. 1 e. msk do.
  txt=. towords (msk i. 1) pick c
  log 'invalid manifest for ',x,' at line: ',txt
  0 return.
end.
c3=. > c
ass=. (<'=:') = 1 {"1 c3
chr=. '''' = {. &> 2 {"1 c3
if. 0 e. ass *. chr do.
  txt=. towords ((0 = ass *.chr) i. 1) pick c
  echo 'invalid manifest for ',x,' at line: ',txt
  0 return.
end.

NB. ---------------------------------------------------------
1
)
