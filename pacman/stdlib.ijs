NB. stdlib definitions
NB.-This definitions are called from the standard library

NB. =========================================================
NB. do_install v install from jal
NB. y is one of:
NB.- 'qtide'     - install/upgrade the Qt IDE
NB.- 'full'      - install the full Qt IDE
NB.- 'slim'      - install the slim Qt IDE
NB.- 'all'       - install all addon packages
NB.-  other      - install those packages, i.e. 'install' jpkg other
NB.- gitrepo:name/repo
do_install=: 3 : 0
if. -. checkaccess_jpacman_ '' do. return. end.
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
if. '/usr/share/j/' -: 13{. jpath'~install' do.
  d=. <;._2 hostcmd_jpacman_ 'ldd /usr/bin/jqt-9.03'
  d=. d,<;._2 hostcmd_jpacman_ 'ldd ',y,'/libjqt.so.9.03'
else.
  d=. <;._2 hostcmd_jpacman_ 'ldd ',jpath'~bin/jqt'
  d=. d,<;._2 hostcmd_jpacman_ 'ldd ',jpath'~bin/libjqt.so'
end.
b=. d#~;+./each (<'not found') E. each d
if. #b do.
  echo'jqt dependencies not found - jqt will not start until these are resolved'
  echo >~.b
end.
)

NB. =========================================================
NB. do_getqtbin v get Qt binaries
do_getqtbin=: 3 : 0

bin=. 'JQt ',(((y-:'slim')#'slim ')),'binaries.'

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
  z1=. 'libjqt.so'
elseif. IFWIN do.
  z=. 'jqt-win',((y-:'slim')#'slim'),'-',(IF64 pick 'x86';'x64'),'.zip'
  z1=. 'jqt.dll'
elseif. do.
  z=. 'jqt-mac',((y-:'slim')#'slim'),'-',(IF64 pick 'x86';'x64'),'.zip'
  z1=. 'libjqt.dylib'
end.
'rc p'=. httpget_jpacman_ 'http://www.jsoftware.com/download/j903/qtide/',z
if. rc do.
  smoutput 'unable to download: ',z return.
end.
d=. jpath '~bin'
fhs=. '/usr/share/j/' -: 13{. jpath'~install'
if. IFWIN do.
  unzip_jpacman_ p;d
else.
  if. 'Linux'-:UNAME do.
    if. fhs do.
      if. fexist '/etc/redhat-release' do.
        d1=. IF64{::'/usr/lib/.';'/usr/lib64/.'
      else.
        if. IFRASPI do.
          d1=. IF64{::'/usr/lib/arm-linux-gnueabihf/.';'/usr/lib/aarch64-linux-gnu/.'
        elseif. do.
          d1=. IF64{::'/usr/lib/i386-linux-gnu/.';'/usr/lib/x86_64-linux-gnu/.'
        end.
      end.
      echo 'install libjqt.so to ',d1
      hostcmd_jpacman_ 'rm -f /usr/bin/jqt'
      echo 'cd ',(dquote jpath '~temp'),' && tar --no-same-owner --no-same-permissions -xzf ',(dquote p), ' && chmod 755 jqt && mv jqt /usr/bin/jqt-9.03 && cp libjqt.so ',d1,'/libjqt.so.9.03 && chmod 755 ',d1,'/libjqt.so.9.03 && ldconfig'
      hostcmd_jpacman_ 'cd ',(dquote jpath '~temp'),' && tar --no-same-owner --no-same-permissions -xzf ',(dquote p), ' && chmod 755 jqt && mv jqt /usr/bin/jqt-9.03 && cp libjqt.so ',d1,'/libjqt.so.9.03 && chmod 755 ',d1,'/libjqt.so.9.03 && ldconfig'
      echo 'update-alternatives --install /usr/bin/jqt jqt /usr/bin/jqt-9.03 903'
      hostcmd_jpacman_ 'update-alternatives --install /usr/bin/jqt jqt /usr/bin/jqt-9.03 903'
    else.
      hostcmd_jpacman_ 'cd ',(dquote d),' && tar xzf ',(dquote p)
    end.
  else.
    hostcmd_jpacman_ 'unzip -o ',(dquote p),' -d ',dquote d
  end.
end.
ferase p
if. #1!:0 fhs{::(jpath '~bin/',z1);'/usr/bin/jqt' do.
  m=. 'Finished install of ',bin
else.
  m=. 'Unable to install ',bin,LF
  m=. m,'check that you have write permission for: ',LF,fhs{::(jpath '~bin');'/usr/bin'
end.
smoutput m

NB. ---------------------------------------------------------
NB. install Qt library:
if. 'Linux'-:UNAME do.
  qt_ldd_test d1
  smoutput 'If libjqt cannot be loaded, see this guide for installing the Qt library'
  smoutput 'https://code.jsoftware.com/wiki/Guides/Linux_Installation'
  return.
end.

tgt=. jpath IFWIN{::'~install/Qt';'~bin/Qt5Core.dll'
y=. (*#y){::0;y

smoutput 'Installing Qt library...'
if. IFWIN do.
  z=. 'qt512-win-',((y-:'slim')#'slim-'),(IF64 pick 'x86';'x64'),'.zip'
else.
  z=. 'qt512-mac-',((y-:'slim')#'slim-'),(IF64 pick 'x86';'x64'),'.zip'
end.
'rc p'=. httpget_jpacman_ 'http://www.jsoftware.com/download/j903/qtlib/',z
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
