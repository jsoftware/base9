NB. runs

NB. =========================================================
NB. initialize global values:
pacman_init=: 3 : 0
dat=. ADDONS #~ ({."1 ADDONS) e. {."1 ZIPS
if. 0=#dat do.
  dat=. i.0 6
else.
  ndx=. ({."1 ADDINS) i. {."1 dat
  ins=. ndx { (1 {"1 ADDINS),<''
  dat=. dat,.<''
  dat=. 0 5 1 3 4 2 {"1 dat
  dat=. ins 1 }"0 1 dat
end.
lib=. 'base library';(fmtver LIN);(fmtver 0 pick LIB);'base library scripts';LIBDESC;''
dat=. dat,lib
dat=. (<0),.dat
PKGDATA=: sort dat
nms=. 1 {"1 PKGDATA
nms=. ~. (nms i.&> '/') {.each nms
SECTION=: 'All';nms
DATAMASK=: (#PKGDATA) $ 1
EMPTY
)

NB. =========================================================
NB. init_console v Initializes a console session
NB. y is: literal list. One of: 'edit', 'read', 'server'
NB.       edit or server require write access to ~addons
NB.       additionally server requires access to server
init_console=: 3 : 0
if. 0=#y do. y=. 'read' end.
select. y
fcase. 'edit';'server' do.
  if. -. HASFILEACCESS do. 0 return. end.
case. 'read' do.
  if. -. HASADDONSDIR do. 0 return. end.
  setfiles''
  readlocal''
  pacman_init ''
  res=. 1
case. do. res=. 0  NB. invalid y specified
end.
if. y -: 'server' do. res=. getserver'' end.
res
)

NB. =========================================================
jpkg=: 4 : 0
if. -.INITDONE_jpacman_ do.
  checkaccess''
  checkaddonsdir''
  INITDONE_jpacman_=: 1
end.
select. x
case. 'history';'manifest' do.
  x showfiles_console y
case. 'install' do.
  if. -. HASFILEACCESS*.HASADDONSDIR do. 'file permission error' return. end.
  install_console y
case. 'reinstall' do.
  if. -. HASFILEACCESS*.HASADDONSDIR do. 'file permission error' return. end.
  remove_console y
  install_console y
case. 'remove' do.
  if. -. HASFILEACCESS*.HASADDONSDIR do. 'file permission error' return. end.
  remove_console y
case. ;:'show search showinstalled shownotinstalled showupgrade status' do.
  x show_console y
case. 'update' do.
  if. -. HASFILEACCESS*.HASADDONSDIR do. 'file permission error' return. end.
  updatejal ''
case. 'upgrade' do.  NB. upgrades previously installed packages to latest versions
  if. -. HASFILEACCESS*.HASADDONSDIR do. 'file permission error' return. end.
  upgrade_console y
case. do.
  msg=. 'Valid options are:',LF
  msg=. msg,'  history, install, manifest, remove, reinstall, show, search,',LF
  msg=. msg,'  showinstalled, shownotinstalled, showupgrade, status,',LF
  msg,'  update, upgrade'
end.
)
