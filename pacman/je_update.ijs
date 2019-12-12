NB. update JE in place - updates JE (beta or release) to latest version at web site
NB. je_update_jpacman_''

NB. should have been called je_upgrade
je_update=: 3 : 0
if. IFIOS+.UNAME-:'Android' do. log'upgrade not supported for this platform' return. end.
'jxxx jbithw platform br comm web dt'=. <;._1 '/',9!:14''
if. -.(comm-:'commercial')*.web-:'www.jsoftware.com' do. log'upgrade not possible for this install' return. end.
br=. (br i.'-'){.br
path=. 'http://www.jsoftware.com/download/jengine/',jxxx,'-',br,'/'
'plat name bname'=. je_sub''
DLL=. hostpathsep jpath bname
OLD=. hostpathsep jpath bname,'.old'
NEW=. hostpathsep jpath bname,'.new'
if. 1~:ftype bname do. log'upgrade not supported for this type of install' return. end.

if. IF64 > IFRASPI do.
 t=. httpget path,plat,'/j64'
 if. 1=;{.t do. log'upgrade - read jengine folder failed' return end.
 a=. fread '~temp/j64'
 i=. >:((;(UNAME-:'Win'){'>libj';'>j') E. a)#i.#a
 a=. i}.each (#i)#<a
 a=. (a i.each'<'){.each a NB. hardware binaries available
 a=. a}.~each a i.each 'j'
 a=. }.each a{.~each a i.each '.'
 try. t7=. 2!:7'' catch. t7=. '' end.
 a=. 'j',;{:(a e. ;:t7)#a NB. best of those we can run
 i=. name i.'.'
 name=. <(}:i{.name),a,i}.name
else.
 name=. <name
end.

arg=. (<jxxx),(<br),(<platform),(<3{.jbithw),name
r=. je_get arg
if. _1=r do. log'upgrade file not found' return. end.
if. r-:fread DLL do. log'upgrade not required - already current' return. end.

if. -.testaccess'' do. log'upgrade must be run with admin privileges' return. end.
r fwrite NEW
(fread DLL) fwrite OLD

if. UNAME-:'Win' do.
  if. fexist OLD do.
   if. -.ferase OLD do. log'upgrade failed - ferase j.dll.old - exit all J sessions and try again' return. end.
  end.
 if. -.OLD frename DLL do. log'upgrade failed - rename j.dll to j.dll.old' return. end.
 if. -.DLL frename NEW do. log'upgrade failed - rename j.dll.new to j.dll' return. end.
else.
  if. -.ferase DLL do. log'upgrade failed - ferase libj.so.old - exit all J sessions and try again' return. end.
  if. -.DLL frename NEW do. log'upgrade failed - rename libj.so.new to libj.so' return. end.
  if. FHS*.UNAME-:'Linux' do.
    2!:0 'chmod 644 "',DLL,'"'
    2!:0 'chown root:root "',DLL,'"'
    2!:0 'ldconfig'
  end.
end.
'upgrade installed - shutdown, restart, and check JVERSION'
)

NB. y is 'j901';'beta';'linux';'j64';'libjavx.so'
NB. https://www.jsoftware.com/download/jengine/j901-beta/linux/j64/libj.so
je_get=: 3 : 0
'jxxx br plat bits name'=. y
arg=. 'http://www.jsoftware.com/download/jengine/',jxxx,'-',br,'/',plat,'/',bits,'/',name
ferase'~temp/',name
httpget arg
fread '~temp/',name
)

je_sub=: 3 : 0
i=. ('Win';'Darwin')i.<UNAME
plat=. ;i{'windows';'darwin';IFRASPI{::'linux';'raspberry'
name=. ;i{'j.dll';'libj.dylib';'libj.so'
bname=. '~bin/',name
if. FHS*.UNAME-:'Linux' do.
  v=. ({.~i.&'/')}.9!:14''
  sub=. '.',({.v),'.',}.v    NB. x j901 -> libj.so.9.01
  if. fexist '/etc/redhat-release' do.
    d1=. IF64{::'/usr/lib/';'/usr/lib64/'
  else.
    if. IFRASPI do.
      d1=. IF64{::'/usr/lib/arm-linux-gnueabihf/';'/usr/lib/aarch64-linux-gnu/'
    elseif. do.
      d1=. IF64{::'/usr/lib/i386-linux-gnu/';'/usr/lib/x86_64-linux-gnu/'
    end.
  end.
  bname=. d1,name,sub
end.
plat;name;bname
)

NB. get 9!:14'' result from JE file
jengine_version=: 3 : 0
d=. fread y
'not a file'assert _1~:d
'not a JE' assert (1 i.~'non-unique sparse elements' E. d)<#d
i=. 1 i.~'je9!:14' E. d
if. i=#d do. 'unknown' return. end.
d=. d}.~8+i
s=. d{.~d i. {.a.
s=. s-.LF,12{a. NB. some early ones had Lf and FF chars
dt=. _20{.s
date=. 11{.dt
m=. 2":>:(;:'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec')i.<3{.date
date=. ((_4{.date),'-',m,'-',4 5{date)rplc' ';'0'
(_20}.s),date,11}.dt
)
