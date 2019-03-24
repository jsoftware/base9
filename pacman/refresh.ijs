NB. refresh
NB.
NB. refresh configuration

NB. =========================================================
refreshweb=: 3 : 0
if. 0 = refreshjal'' do. 0 return. end.
readlocal''
1
)

NB. =========================================================
refreshaddins=: 3 : 0
setfiles''
ADDLABS=: ''
f=. ADDCFG,'addins.txt'
p=. jpath '~addons/'
sd=. ;subdir each subdir p
if. 0=#sd do.
  '' fwrite f
  write_config'' return.
end.
r=. s=. ''
for_d. sd do.
  mft=. freads (>d),'manifest.ijs'
  if. mft -: _1 do. continue. end.
  VERSION=: ''
  0!:100 mft
  ver=. fmtver fixver VERSION
  n=. }: (#p) }. >d
  n=. '/' (I.n='\') } n
  r=. r,n,' ',ver,LF
  s=. s,d
end.
r fwritenew f
s=. (#p) }.each }: each s
install_labs each s
write_config''
)

NB. =========================================================
refreshjal=: 3 : 0
'rc p'=. httpget WWW,zipext 'jal'
if. rc do. 0 return. end.
unzip p;ADDCFG
ferase p
if. *./ CFGFILES e. {."1 [ 1!:0 ADDCFG,'*' do. 1 return. end.
msg=. 'Could not install the local repository catalog.'
log msg
info msg
0
)

NB. =========================================================
NB. updatejal v Retrieves latest info from JAL server and reports status
NB. eg: updatejal ''
updatejal=: 3 : 0
log 'Updating server catalog...'
if. -. init_console 'server' do. '' return. end.
refreshaddins''
readlocal''
pacman_init''
res=. checklastupdate''
res,LF,checkstatus''
)
