NB. stdlib definitions
NB.-This definitions are called from the standard library

JQTVERSION=: '2.0.3'

NB. =========================================================
NB. do_install v install from jal
NB. y is one of:
NB.- 'qtide'     - install/upgrade the Qt IDE
NB.- 'full'      - install the full Qt IDE
NB.- 'slim'      - install the slim Qt IDE
NB.- 'all'       - install all addon packages
NB.- 'gmp'       - install libgmp binary
NB.-  other      - install those packages, i.e. 'install' jpkg other
NB.- gitrepo:name/repo
do_install=: 3 : 0
if. -. checkaccess_jpacman_ '' do. return. end.
if. y -: 'gmp' do. do_getgmpbin '' return. end.
if. ':' e. y do. install_gitrepo y return. end.
'update' jpkg ''
if. y -: 'addons' do. y=. 'all' end.
if. -. (<y) e. 'full';'qtide';'slim' do.
  'install' jpkg y return.
end.
if. IFQT do.
  smoutput 'Must run from jconsole' return.
end.
if. y-:'qtide' do.
  s=. 'slim'-: 4 {. ;getjqtversion_jpacman_''
  y=. s pick 'full';'slim'
end.
'install' jpkg 'base library ide/qt'
getqtbin y
msg=. (+/ 2 1 * IFWIN,'Darwin'-:UNAME) pick 'jqt.sh';'the jqt icon';'jqt.cmd'
if. '/usr/share/j/' -: 13{. jpath'~install' do. msg=. 'jqt' end.
smoutput 'Exit and restart J using ',msg
)

NB. =========================================================
qt_ldd_test=: 3 : 0
ldd=. ('Darwin'-:UNAME){::'ldd';'otool -L'
suffix=. ('Darwin'-:UNAME){::'so';'dylib'
vsuffix=. ('Darwin'-:UNAME){::*('so.',JQTVERSION);(JQTVERSION,'.dylib')
if. FHS*.IFUNIX do.
  d=. <;._2 hostcmd_jpacman_ ldd,' ',BINPATH,'/jqt-9.04'
  d=. d,<;._2 hostcmd_jpacman_ ldd,' ',y,'/libjqt.',vsuffix
else.
  d=. <;._2 hostcmd_jpacman_ ldd,' ',jpath'~bin/jqt'
  d=. d,<;._2 hostcmd_jpacman_ ldd,' ',jpath'~bin/libjqt.',suffix
end.
b=. d#~;+./each (<'not found') E. each d
if. ('Darwin'-:UNAME)<*#b do.
  echo'jqt dependencies not found - jqt will not start until these are resolved'
  echo >~.b
end.
)

NB. =========================================================
NB. do_getqtbin v get Qt binaries
do_getqtbin=: 3 : 0

bin=. 'JQt ',(((y-:'slim')#'slim ')),'binaries.'

suffix=. IFUNIX{::'dll';('Darwin'-:UNAME){::'so';'dylib'
vsuffix=. IFUNIX{::(JQTVERSION,'.dll');('Darwin'-:UNAME){::('so.',JQTVERSION);(JQTVERSION,'.dylib')
NB. ---------------------------------------------------------
smoutput 'Installing ',bin,'..'
if. 'Linux'-:UNAME do.
  if. IFRASPI do.
    z=. 'jqt-',((y-:'slim') pick 'raspi';'raspislim'),'-',(IF64 pick '32';'64'),'.tar.gz'
  elseif. 0 [ fexist '/etc/redhat-release' do.
NB. provision for jqt-rhel7-x64.tar.gz jqt-rhel7slim-x64.tar.gz
    z=. 'jqt-',((y-:'slim') pick 'rhel7';'rhel7slim'),'-',(IF64 pick '32';'64'),'.tar.gz'
  elseif. do.
    z=. 'jqt-',((y-:'slim') pick 'linux';'slim'),'-',(IF64 pick 'x86';'x64'),'.tar.gz'
  end.
  z1=. 'libjqt.',suffix
elseif. IFWIN do.
  z=. 'jqt-win',((y-:'slim')#'slim'),'-',(IF64 pick 'x86';'x64'),'.zip'
  z1=. 'jqt.',suffix
elseif. do.
  z=. 'jqt-mac',((y-:'slim')#'slim'),'-',(IF64 pick 'x86';'x64'),'.zip'
  z1=. 'libjqt.',suffix
end.
'rc p'=. httpget_jpacman_ 'http://www.jsoftware.com/download/j904/qtide/',z
if. rc do.
  smoutput 'unable to download: ',z return.
end.
d=. jpath '~bin'
if. IFWIN do.
  unzip_jpacman_ p;d
else.
  if. FHS do.
    if. 'Darwin'-:UNAME do.
      d1=. (({.~ i:&'/')BINPATH),'/lib/'
    elseif. IFRASPI do.
      d1=. (({.~ i:&'/')BINPATH),IF64{::'/lib/arm-linux-gnueabihf/';'/lib/aarch64-linux-gnu/'
    elseif. do.
      if. -.fexist d1=. (({.~ i:&'/')BINPATH),IF64{::'/lib/i386-linux-gnu/';'/lib/x86_64-linux-gnu/' do.
        d1=. (({.~ i:&'/')BINPATH),IF64{::'/lib/';'/lib64/'
      end.
    end.
    echo 'install libjqt.',suffix,' to ',d1
    hostcmd_jpacman_ 'rm -f ',BINPATH,'/jqt'
    echo 'cd ',(dquote jpath '~temp'),' && tar --no-same-owner --no-same-permissions -xzf ',(dquote p), ' && chmod 755 jqt && mv jqt ',BINPATH,'/jqt-9.04 && cp libjqt.',suffix,' ',d1,'/libjqt.',vsuffix,' && chmod 755 ',d1,'/libjqt.',vsuffix, ((<UNAME)e.'Linux';'OpenBSD';'FreeBSD')#' && /sbin/ldconfig'
    hostcmd_jpacman_ 'cd ',(dquote jpath '~temp'),' && tar --no-same-owner --no-same-permissions -xzf ',(dquote p), ' && chmod 755 jqt && mv jqt ',BINPATH,'/jqt-9.04 && cp libjqt.',suffix,' ',d1,'/libjqt.',vsuffix,' && chmod 755 ',d1,'/libjqt.',vsuffix, ((<UNAME)e.'Linux';'OpenBSD';'FreeBSD')#' && /sbin/ldconfig'
    if. 'Linux'-:UNAME do.
      echo 'update-alternatives --install ',BINPATH,'/jqt jqt ',BINPATH,'/jqt-9.04 904'
      hostcmd_jpacman_ 'update-alternatives --install ',BINPATH,'/jqt jqt ',BINPATH,'/jqt-9.04 904'
    end.
  else.
    hostcmd_jpacman_ 'cd ',(dquote d),' && tar xzf ',(dquote p)
  end.
end.
ferase p
if. #1!:0 FHS{::(BINPATH,'/',z1);BINPATH,'/jqt' do.
  m=. 'Finished install of ',bin
else.
  m=. 'Unable to install ',bin,LF
  m=. m,'check that you have write permission for: ',LF,BINPATH
end.
smoutput m

NB. ---------------------------------------------------------
NB. install Qt library:
if. ((<UNAME)e.'Linux';'OpenBSD';'FreeBSD') do.
  qt_ldd_test d1
  smoutput 'If libjqt cannot be loaded, see this guide for installing the Qt library'
  smoutput 'https://code.jsoftware.com/wiki/Guides/Linux_Installation'
  return.
end.

tgt=. jpath IFWIN{::'~install/Qt';'~bin/Qt6Core.dll'
y=. (*#y){::0;y

smoutput 'Installing Qt library...'
if. IFWIN do.
  z=. 'qt62-win-',((y-:'slim')#'slim-'),(IF64 pick 'x86';'x64'),'.zip'
else.
  z=. 'qt62-mac-',((y-:'slim')#'slim-'),(IF64 pick 'x86';'x64'),'.zip'
end.
'rc p'=. httpget_jpacman_ 'http://www.jsoftware.com/download/j904/qtlib/',z
if. rc do.
  smoutput 'unable to download: ',z return.
end.
d=. jpath IFWIN{::'~install';'~bin'
if. IFWIN do.
  unzip_jpacman_ p;d
else.
  hostcmd_jpacman_ 'unzip -o ',(dquote p),' -d ',dquote d
end.
ferase p
if. #1!:0 tgt do.
  m=. 'Finished install of Qt library.'
else.
  m=. 'Unable to install Qt library.',LF
  m=. m,'check that you have write permission for: ',LF,IFWIN{::tgt;jpath'~bin'
end.
smoutput m

)

NB. =========================================================
NB. do_getgmpbin v get libgmp binaries
do_getgmpbin=: 3 : 0

if. IFIOS +. UNAME-:'Android' do.
  smoutput 'not available on the platform' return.
end.

bin=. (IFUNIX{::'mpir';'gmp'),' binary.'

suffix=. IFUNIX{::'dll';('Darwin'-:UNAME){::'so';'dylib'
libname=. IFUNIX{::('mpir.',suffix);'libgmp.',suffix
libjname=. IFUNIX{::('mpir.',suffix);'libjgmp.',suffix

NB. ---------------------------------------------------------
if. ''-:1!:46'' do.
  if. FHS do.
    if. 'Darwin'-:UNAME do.
      dest=. (({.~ i:&'/')BINPATH),'/lib/'
    elseif. IFRASPI do.
      dest=. (({.~ i:&'/')BINPATH),IF64{::'/lib/arm-linux-gnueabihf/';'/lib/aarch64-linux-gnu/'
    elseif. do.
      if. -.fexist dest=. (({.~ i:&'/')BINPATH),IF64{::'/lib/i386-linux-gnu/';'/lib/x86_64-linux-gnu/' do.
        dest=. (({.~ i:&'/')BINPATH),IF64{::'/lib/';'/lib64/'
      end.
    end.
  else.
    dest=. BINPATH,'/'
  end.
else.
  dest=. (1!:46''),'/'
end.
if. fexist f=. dest, FHS{::libname;libjname do.
  smoutput f,' already exists' return.
end.

NB. ---------------------------------------------------------
smoutput 'Installing ',bin,'..'
if. 'Linux'-:UNAME do.
  if. IFRASPI do.
    z=. libname,~ IF64{::'linux/arm/';'linux/aarch64/'
  elseif. do.
    z=. libname,~ IF64{::'linux/i386/';'linux/x86_64/'
  end.
elseif. IFWIN do.
  z=. libname,~ IF64{::'windows/win32/';'windows/x64/'
elseif. do.
  z=. libname,~ 'apple/macos/'
end.
'rc p'=. httpget_jpacman_ 'http://www.jsoftware.com/download/jengine/mpir/',z
if. rc do.
  smoutput 'unable to download: ',z return.
end.
echo 'install ',(FHS{::libname;libjname),' to ',dest
if. IFWIN do.
  (dest,libname) fcopynew p
else.
  (dest,FHS{::libname;libjname) fcopynew p
  hostcmd_jpacman_ ::0: 'chmod 755 ',dquote (dest,FHS{::libname;libjname)
end.
ferase p
if. fexist (dest,FHS{::libname;libjname) do.
  m=. 'Finished install of ',bin
else.
  m=. 'Unable to install ',bin,LF
  m=. m,'check that you have write permission for: ',LF,dest
end.
smoutput m

)
