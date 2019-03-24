NB. folders
NB.
NB. tofoldername      - convert to folder name (standard utility in j)
NB. toprojectfolder   - convert to current project folder
NB.                     if fails, use tofoldername
NB. toprojectname     - convert to project name
NB. touserfolder      - as toprojectfolder, but only for UserFolders
NB.                     if fails, return empty

NB. =========================================================
NB. toprojectfolder
NB.
NB. convert file name to project folder name
NB.
NB. conversion method:
NB.  - if already a foldername, return in canonical format
NB.  - otherwise, searches for best fit starting from current project
NB.  - if no fit, then check other folders
toprojectfolder=: 3 : 0
if. 0=#y do. '' return. end.
r=. toprojectfolder1 y
if. L. y do. r else. >r end.
)

NB. =========================================================
toprojectfolder1=: 3 : 0
res=. filecase@jpathsep each boxxopen y
rex=. I. '~' ~: {.&> res
if. 0=#rex do. res return. end.
if. #Folder do.
  pid=. termsep jpath '~',Folder
  for_i. rex do.
    nax=. termsep nam=. i pick res
    if. pid matchhead nax do.
      res=. (<'~',Folder,(<:#pid) }. nam) i} res
      rex=. rex -. i
    end.
  end.
end.
if. 0=#rex do. res return. end.
pus=. UserFolders,SystemFolders
pds=. {."1 pus
pps=. termsep each {:"1 pus
ndx=. \: # &> pps
pds=. ndx{pds
pps=. ndx{pps
len=. # &> pps
for_i. rex do.
  nam=. i pick res
  msk=. pps = len {. each <nam,'/'
  if. 1 e. msk do.
    ndx=. ((i. >./) msk # len) { I. msk
    nam=. ('~', > ndx { pds),(<: ndx { len) }. nam
    res=. (<nam) i } res
  end.
end.
res
)

NB. =========================================================
NB. return name using user folder, default project folder
NB. or empty if none
touserfolder=: 3 : 0
p=. toprojectfolder y
if. '~' ~: {.p do. '' return. end.
f=. }. (p i.'/'){.p
p #~ (<f) e. {."1 UserFolders
)
