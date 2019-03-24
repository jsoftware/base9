NB. =========================================================
NB. Removing/purging addons from local installation

remove_console=: 3 : 0
if. -. init_console 'edit' do. '' return. end.
pkgs=. getnames y
if. pkgs -: ,<'all' do. pkgs=. 1 {"1 PKGDATA end.
pkgs=. pkgs (e. # [) (-.@pkgnew # 1&{"1@]) PKGDATA  NB.filter installed
pkgs=. pkgs -. <BASELIB NB. don't remove base library
if. 0 = num=. #pkgs do. '' return. end.
many=. 1 < num
msg=. 'Removing ',(":num),' package',many#'s'
log msg
remove_addon each pkgs
log 'Done.'
readlocal''
pacman_init ''
checkstatus''
)

remove_addon=: 3 : 0
log 'Removing ',y,'...'
treepath=. jpath '~addons/',y
if. ((0 < #@dirtree) *. -.@deltree) treepath do.
  nf=. #dirtree treepath  NB. files still there
  nd=. <: # dirpath treepath NB. subfolders still there
  nd=. nd + (tolower treepath) e. dirpath jpath '~addons/', '/' taketo y
  msg=. (":nd),' directories and ',(":nf),' files not removed.'
  log 'Remove failed: ',msg
  info 'Remove failed:',LF2,msg
  return.
end.
remove_addins y
remove_config y
)

NB. remove_addins v Remove record of pkg y from addins.txt
NB. eg: remove_addins 'tables/tara'
remove_addins=: 3 :0
fl=. ADDCFG,'addins.txt'
ins=. fixjal2 freads fl
ins=. ins #~ (<y) ~: {."1 ins
(fmtjal2 ins) fwrites fl
)

NB. remove_config v Remove pkg y labs from ADDLABS definition.
NB. eg: remove_config 'tables/tara'
remove_config=: 3 : 0
ADDLABS=: ''
0!:0 :: ] < ADDCFGIJS
remove_labs y
write_config''
)

NB. remove_labs v Remove lines of ADDLABS that begin with y
NB. eg: remove_labs 'tables/tara'
remove_labs=: 3 : 0
txt=. <;._2 ADDLABS
txt=. txt #~ (<jpathsep y) ~: (#y)&{. each txt
ADDLABS=: ; txt ,each LF
)
