NB. install

NB. =========================================================
install=: 3 : 0
dat=. getdepend y
'num siz'=. pmview_applycounts dat
many=. 1 < num
msg=. 'Installing ',(":num),' package',many#'s'
msg=. msg,' of ',(many#'total '),'size ',sizefmt siz
log msg
installdo 1 {"1 dat
log 'Done.'
readlocal''
pacman_init 0
)

NB. =========================================================
NB. install_console v Installs packages for console use of pacman
NB. installs packages not currently installed
NB. upgrades currently installed packages to latest JAL version
NB. up-to-date packages are ignored
install_console=: 3 : 0
if. -. init_console 'server' do. '' return. end.
pkgs=. getnames y
if. pkgs -: ,<'all' do. pkgs=. 1 {"1 PKGDATA end.
pkgs=. pkgs (e. # [) ~. (<'base library'), ((pkgnew +. pkgups) # 1&{"1@]) PKGDATA  NB.filter valid, new, upgradeable
pkgs=. pkgs -. Ignore
pkgs=. getdepend_console pkgs
if. 0 = num=. #pkgs do. '' return. end.
many=. 1 < num
msg=. 'Installing ',(":num),' package',many#'s'
log msg
installdo pkgs
log 'Done.'
readlocal''
pacman_init ''
checkstatus''
)

NB. =========================================================
NB. upgrade_console v Upgrades already installed packages for console
upgrade_console=: 3 : 0
if. -. init_console 'read' do. '' return. end.
pkgs=. getnames y
if. (0=#pkgs) +. pkgs -: ,<'all' do. pkgs=. 1{"1 PKGDATA end.
pkgs=. pkgs (e. # [) (pkgups # 1&{"1@])PKGDATA NB.filter valid, upgradeable
install_console pkgs
)

NB. =========================================================
installdo=: 3 : 0
msk=. -. y e. <BASELIB
if. 0 e. msk do.
  install_library''
end.
install_addon each msk # y
)

NB. =========================================================
install_addon=: 3 : 0
ndx=. ({."1 ZIPS) i. <y
if. ndx = #ZIPS do. EMPTY return. end.
log 'Downloading ',y,'...'
f=. 3 pick ndx { ZIPS
'rc p'=. httpget WWW,'addons/',f
if. rc do. return. end.
log 'Installing ',y,'...'
msg=. unzip p;jpath'~addons'
ferase p
if. 0>:fsize jpath'~addons/',y,'/manifest.ijs' do.
  log 'Extraction failed: ',msg
  info 'Extraction failed:',LF2,msg
  return.
end.
install_addins y
install_config y
)

NB. =========================================================
install_addins=: 3 :0
fl=. ADDCFG,'addins.txt'
ins=. fixjal2 freads fl
ins=. ins #~ (<y) ~: {."1 ins
ndx=. ({."1 ADDONS) i. <y
ins=. sort ins, 2 {. ndx { ADDONS
(fmtjal2 ins) fwrites fl
)

NB. =========================================================
install_config=: 3 : 0
ADDLABS=: ''
0!:0 :: ] < ADDCFGIJS
install_labs y
write_config''
)

NB. =========================================================
install_labs=: 3 : 0
labs=. dirtree jpath '~addons/',y,'/*.ijt'
if. 0=#labs do. return. end.
pfx=. jpath '~addons/'
labs=. (#pfx) }.each {."1 labs
LABCATEGORY=: ''
0!:0 ::] <jpath '~addons/',y,'/manifest.ijs'
cat=. LABCATEGORY
if. 0 = #cat do.
  cat=. toupper1 (y i. '/') {. y
end.
new=. labs ,each <' ',cat
txt=. sort ~. new,<;._2 ADDLABS
ndx=. 4 + (1 i.~ '.ijt'&E.) &> txt
msk=. fexist &> (<pfx) ,each ndx {.each txt
txt=. msk # txt
ADDLABS=: ; txt ,each LF
)

NB. =========================================================
install_library=: 3 : 0
log 'Downloading base library...'
f=. 1 pick LIB
'rc p'=. httpget WWW,'library/',f
if. rc do. return. end.
log 'Installing base library...'
unzip p;jpath'~system'
ferase p
readlin''
)

NB. =========================================================
write_config=: 3 : 0
txt=. 'NB. Addon configuration',LF2
txt=. txt,'ADDLABS=: 0 : 0',LF,ADDLABS,')',LF
txt fwrites ADDCFGIJS
)
