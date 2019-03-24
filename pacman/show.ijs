NB. =========================================================
NB. show summary, history, manifest

NB. =========================================================
show_console=: 4 : 0
if. -. init_console 'read' do. '' return. end.
select. x
case. 'search' do.
  pkgs=. getnames y
  res=. (pkgsearch pkgs) # 1 2 3 4 {"1 PKGDATA
  res=. curtailcaption res
case. 'show' do.
  pkgs=. getnames y
  if. pkgs -: ,<'all' do. pkgs=. 1 {"1 PKGDATA end.
  res=. (msk=. pkgshow pkgs) # 5 {"1 PKGDATA
  if. #res do.
    res=. ,((<'== '), &.> msk # 1 {"1 PKGDATA) ,. res      NB. package names
    res=. (2#LF) joinstring (70&foldtext)&.> res NB. wrap & delimit
  end.
case. 'showinstalled' do.
  dat=. (isjpkgout y) {:: (1 2 3 4 {"1 PKGDATA);<y
  res=. (-.@pkgnew # ])dat
  res=. curtailcaption res
case. 'shownotinstalled' do.
  dat=. (isjpkgout y) {:: (1 2 3 4 {"1 PKGDATA);<y
  res=. (pkgnew # 0 2 3&{"1@])dat
  res=. curtailcaption res
case. 'showupgrade' do.
  dat=. (isjpkgout y) {:: (1 2 3 4 {"1 PKGDATA);<y
  res=. (pkgups # ])dat
  res=. curtailcaption res
case. 'status' do.
  res=. checklastupdate''
  res=. res,LF,checkstatus''
end.
res
)

NB. =========================================================
showfiles_console=: 4 : 0
if. -. init_console 'read' do. '' return. end.
pkgs=. getnames y
pkgs=. pkgs (e. # [) (-.@pkgnew # 1&{"1@]) PKGDATA  NB. filter installed packages
pkgs=. pkgs -. <BASELIB                             NB. filter out base library
if. 0=#pkgs do. '' return. end.
fn=. (<'~addons/') ,&.> (pkgs) ,&.> <'/',x,(x-:'history'){::'.ijs';'.txt'
res=. res #~ msk=. (<_1) ~: res=. fread@jpath &.> fn
if. #res do.
  res=. ,((<'== '), &.> msk#pkgs) ,. res      NB. package names
  res=. (2#LF) joinstring res
end.
)
