NB. update JE in place
NB. updates JE (beta or release) to latest version at web site

NB. je_update_jpacman_''
NB. je_update_jpacman_'force' - updates even if already there - for testing

jef=: '~temp/je_update/'

je_update=: 3 : 0
if. IFIOS+.UNAME-:'Android' do. 'update not supported for this platform' return. end.
mkdir_j_ jef
sh=. 'update.',;(UNAME-:'Win'){'sh';'bat'
ferase jef,sh
'plat name bname'=. je_sub''
old=. fread bname
old fwrite jef,name,'.old'
if. #msg=. je_get'' do. echo msg return. end.
if. (-.'force'-:y) *. old-:fread jef,name,'.new' do.
  echo 'the current JE is already up to date' return.
end.
OLD=. hostpathsep jpath bname
NEW=. hostpathsep jpath jef,name,'.new'
if. UNAME-:'Win' do.
  (win_update rplc 'OLD';OLD;'NEW';NEW) fwrite jef,sh
else.
  if. FHS*.UNAME-:'Linux' do. NB. deb type install
    d=. deb_update
  else.
    d=. unix_update
  end.
  (d rplc 'OLD';OLD;'NEW';NEW) fwrite jef,sh
  2!:0 'chmod +x ',jpath jef,sh
end.
echo shutdown rplc 'CMD';hostpathsep jpath jef,sh
)

NB. get latest binary for this install - beta/release windows/linux/macos 32/64  avx/nonavx
je_get=: 3 : 0
mkdir_j_ jef
'plat name bname'=. je_sub''
t=. <;._1 '/',9!:14''
version=. ;{.t
br=. ;3{t NB. betaxxx or releasexxx
i=. ('beta';'rele')i. <4{.br
if. i=2 do. 'current JE is not beta or release' return. end.
type=. ;i{'beta';'release'
if. 1~:ftype bname do. 'update not supported for this type of install' return. end.
erase'JENEW'
jeold=. fread bname
path=. 'http://www.jsoftware.com/download/jengine/',version,'-',type,'/'
avxname=. name
avx=. 'nonavx'-:_6{.;1{t
if. avx do.
  avxname=. avxname rplc '.';'-nonavx.'
end.
tname=. '~temp/',avxname
ferase tname
arg=. path,'P/jX/N' rplc 'P';plat;'N';avxname;'X';;IF64{'32';'64'
echo arg
httpget_jpacman_ arg
(fread tname)fwrite jef,name,'.new'
echo 'saved as:    ',jef,name,'.new'
echo 'new version: ',jengine_version tname
''
)

je_sub=: 3 : 0
i=. ('Win';'Darwin')i.<UNAME
plat=. ;i{'windows';'darwin';IFRASPI{::'linux';'raspberry'
name=. ;i{'j.dll';'libj.dylib';'libj.so'
bname=. '~bin/',name
if. FHS*.UNAME-:'Linux' do.
  v=. ({.~i.&'/')}.9!:14''
  sub=. '.',({.v),'.',}.v    NB. x j805 -> libj.so.8.05
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

unix_update=: 0 : 0
#!/bin/sh
cp "NEW" "OLD"
echo restart J and check JVERSION
)

deb_update=: 0 : 0
#!/bin/sh
sudo cp "NEW" "OLD"
sudo chmod 644 "OLD"
sudo chown root:root "OLD"
sudo ldconfig
)

win_update=: 0 : 0
@ECHO OFF
copy "NEW" "OLD"
echo restart J and check JVERSION
)

shutdown=: 0 : 0

hint: copy command so you can paste it in terminal/command window

!!! shutdown J (all copies running this version) !!!

in a terminal/command window run the following:

"CMD"

note: command may require admin/sudo priviliege

)
