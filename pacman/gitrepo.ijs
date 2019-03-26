NB. install from git repo

NB. =========================================================
NB. supported repos
REPOS=: ;:'github'

NB. =========================================================
cutrepo=: 3 : 0
t=. remsep jpathsep deb y
ndx=. t i. ':'
tag=. ndx {. t
t=. (ndx+1) }. t
ndx=. t i. '@'
rep=. ndx {. t
cmt=. (ndx+1) }. t
cmt=. cmt,(0=#cmt)#'master'
tag;rep;cmt
)

NB. =========================================================
getpackageurl=: 3 : 0
'tag rep cmt'=. y
select. tag
case. 'github' do.
  ball=. IFUNIX pick 'zipball';'tarball'
  p=. <;.2 rep,'/'
  rpo=. ;2 {. p
  'https://github.com/',rpo,ball,'/',cmt
case. do.
  ''
end.
)

NB. =========================================================
getpacsub=: 3 : 0
t=. 1!:0 y,'/*'
d=. , t #~ 'd'= 4 {"1 > 4 {"1 t
if. 0=#d do. 0 return. end.
y,'/',0 pick d
)

NB. =========================================================
gettempdir=: 3 : 0
tmp=. jpath '~temp/pacmandownload'
rmdir_j_ tmp
mkdir_j_ tmp
tmp
)

NB. =========================================================
NB. y is url[;outfile]
gitrepoget=: 3 : 0
'f p'=. 2 {. (boxxopen y),a:
httpget f;3;p
)

NB. =========================================================
install_gitrepo=: 3 : 0
'tag rep cmt'=. cutrepo y
if. -. (<tag) e. REPOS do.
  echo 'Unsupported repo host: ',tag return.
end.
if. 0 -: readmanifest tag;rep;cmt do. 0 return. end.
if. 0 -: readpackage tag;rep;cmt do. 0 return. end.
frm=. 0 pick splitrep rep
msg=. 'installed: ',frm,' ',cmt
if. -. frm -: FOLDER do.
  msg, ' into folder: ',FOLDER
end.
)

NB. =========================================================
readpackage=: 3 : 0
url=. getpackageurl y
if. 0=#url do. 0 return. end.
tmp=. gettempdir''
p=. tmp,'/t1.',IFUNIX pick 'zip';'tar.gz'
'rc msg'=. gitrepoget url;p
if. rc do.
  0[echo 'Could not download addon: ',msg return.
end.
if. 0 >: fsize p do.
  0[echo 'Could not download addon' return.
end.
unzip p;tmp
sub=. getpacsub tmp
if. 0-:sub do. return. end.
removeextras sub
replacepackage sub;FOLDER
rmdir_j_ tmp
1
)

NB. =========================================================
removeextras=: 3 : 0
p=. addsep y
ferase p&, each FILES -.~ (#p) }. each dtree p
)

NB. =========================================================
replacepackage=: 3 : 0
'tmp rep'=. y
'add sub'=. splitrep rep
fm=. tmp,sub
to=. jpath '~addons/',add
dircopy fm;to
1
)
