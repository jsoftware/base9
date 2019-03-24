NB. folders

NB. =========================================================
NB. convert single name to pathname
jpath=: 3 : 0
nam=. jpathsep y
if. '~' ~: {. nam do. return. end.
fld=. SystemFolders, UserFolders
ind=. nam i. '/'
tag=. }. ind {. nam
if. 0=#tag do.       NB. ~/foo =>  ~home/foo
  tag=. 'home'
  nam=. '~home',}.nam
  ind=. nam i. '/'
end.
if. tag -: 'addons' do.
  bal=. 8 }. nam
end.
par=. '.' = {. tag
if. par do.
  len=. ('.' = tag) i. 0
  tag=. len }. tag
end.
ndx=. ({."1 fld) i. <tag
if. ndx < # fld do.
  bal=. ind }. nam
  pfx=. 1 pick ndx { fld
  if. '~' = {.pfx do.
    pfx=. jpath pfx
  end.
  if. par do.
    pfx=. ((#pfx) | (+/\. pfx='/') i: len) {. pfx
  end.
  nam=. pfx,bal
end.
nam
)

NB. =========================================================
NB. tofoldername
NB. convert file names to folder names
NB.
NB. argument is list of filenames
NB. returns names as foldernames where possible
NB.
NB. conversion method:
NB.  - searches for the best fit
NB.  - if none then check for parent folders
tofoldername=: 3 : 0
if. 0=#y do. '' return. end.
folders=. UserFolders,SystemFolders
pds=. {."1 folders
pps=. termsep each {:"1 folders
ndx=. \: # &> pps
pds=. ndx{pds
pps=. ndx{pps
res=. filecase each boxxopen y
len=. # &> pps
for_i. i.#res do.
  nam=. i pick res
  if. '~' = {. nam,'~' do. continue. end.
  msk=. pps = len {. each <nam,'/'
  if. 1 e. msk do.
    ndx=. ((i. >./) msk # len) { I. msk
    nam=. ('~', > ndx { pds),(<: ndx { len) }. nam
    res=. (<nam) i } res
  end.
end.
pps=. }: each pps
ndx=. 1 + pps i: &> '/'
msk=. ndx < len
pps=. msk # ndx {.each pps
pds=. msk # pds
len=. # &> pps
for_i. i.#res do.
  nam=. i pick res
  if. '~' = {. nam,'~' do. continue. end.
  if. '/' = {. nam do. continue. end.
  msk=. pps = len {. each <nam
  if. 1 e. msk do.
    ndx=. ((i. >./) msk # len) { I. msk
    nam=. ('~.', > ndx { pds),(<: ndx { len) }. nam
    res=. (<nam) i } res
  end.
end.
if. L. y do. res else. >res end.
)
