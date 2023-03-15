installer=: 3 : 0
echo 'these steps can take several minutes'
echo '*** next step updates addons and base library'
'update'jpkg''
'upgrade'jpkg'all'
'install'jpkg {."1'shownotinstalled'jpkg''
if. IFIOS +. UNAME-:'Android' do.
  echo LF,'ALL DONE!',LF,'exit this J session and start new session'
  i.0 0
  return.
end.
echo '*** next step updates Jqt ide'
do_install'qtide'
echo '*** next step updates JE'
'upgrade'jpkg'jengine'
echo '*** next step creates desktop J launch icons'
if. 2~:ftype jpath'~/Desktop' do.
  echo '~/Desktop folder does not exist for shortcuts'
  echo 'perhaps create ~/Desktop as link to your Desktop folder and rerun'
  assert 0
else.
  shortcut'jc'
  shortcut'jhs'
  shortcut'jqt'
end.
echo LF,'ALL DONE!',LF,'exit this J session and start new session with double click',LF,'of desktop icon to run J with the corresponding user interface'
i.0 0
)

NB. shortcut 'jc' or 'jhs' or 'jqt' - create desktop launch icon
shortcut=: 3 : 0
if. ((<UNAME)e.'OpenBSD';'FreeBSD') do. uname=. 'Linux' else. uname=. UNAME end.
try. ".uname,' y' catchd. echo 'create ',y,' launch icon failed' end.
)

defaults=: 3 : 0
A=: ' ~addons/ide/jhs/config/jhs.cfg'
L=: hostpathsep jpath'~/Desktop/'
W=: hostpathsep jpath'~'
I=: hostpathsep jpath'~bin/icons/'
N=: RELNO
DS=: ;(('Win';'Linux';'OpenBSD';'FreeBSD';'Darwin')i.<UNAME){'.lnk';'.desktop';'.desktop';'.desktop';'.app'
LIB=: ''
)

NB. windows
vbs=: 0 : 0
Set oWS=WScript.CreateObject("WScript.Shell")
Set oLink=oWS.CreateShortcut("<N>")
oLink.TargetPath="<C>"
oLink.Arguments="<A>"
oLink.WorkingDirectory = "<W>"
oLink.IconLocation="<I>"
oLink.Save
)

Win=: 3 : 0
defaults''
Winx y
)

Winx=: 3 : 0
select. y
case.'jc' do.
  win'jc' ;'jconsole';'jgray.ico';LIB
case. 'jhs' do.
  win'jhs';'jconsole';'jblue.ico';LIB,A
case. 'jqt' do.
  win'jqt';'jqt' ;'jgreen.ico';LIB
case. do.
  assert 0
end.
)

win=: 3 : 0
'type bin icon arg'=. y
f=. jpath '~temp/shortcut.vbs'
n=. L,type,N,DS
c=. hostpathsep jpath '~bin/',bin
(vbs rplc '<N>';n;'<C>';c;'<A>';arg;'<W>';W;'<I>';I,icon) fwrite f
r=. spawn_jtask_ 'cscript "',f,'"'
r assert -.'runtime error' E. r
ferase f
i.0 0
)

NB. Linux (Ubuntu)
desktop=: 0 : 0
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Name=<N>
Exec=<E>
Path=<W>
Icon=<I>
)

NB. Linux (RedHat and Centos)
desktoprh=: 0 : 0
[Desktop Entry]
Version=1.0
Type=Application
Terminal=<TT>
Name=<N>
Exec=<E>
Path=<W>
Icon=<I>
)

lter=: 0 : 0

x-terminal-emulator does not exist and does not link to your preferred terminal
edit launch icon properties and change x-terminal-emulator to be your preferred terminal
 or
create it with: sudo update-alternatives --config x-terminal-emulator

)

get_terminal=: 3 : 0
if. 0=#TermEmu_j_ do. echo lter end.
TermEmu_j_
)

Linux=: 3 : 0
defaults''
Linuxx y
)

Linuxx=: 3 : 0
select. y
case.'jc' do.
  linux'jc' ;'jconsole';'jgray.png';LIB
case. 'jhs' do.
  linux'jhs';'jconsole';'jblue.png';LIB,A
case. 'jqt' do.
  linux'jqt';'jqt' ;'jgreen.png';LIB
case. do.
  assert 0
end.
i.0 0
)

linux=: 3 : 0
'type bin icon arg'=. y
n=. type,N
f=. L,type,N,DS
c=. hostpathsep jpath '~bin/',bin
rh=. 1<#fread '/etc/redhat-release'
if. rh do.
  if. type-:'jqt' do.
    e=. c
  else.
    e=. c,' ',arg
  end.
else.
  if. type-:'jqt' do.
    e=. '"',c,'"'
  else.
    if. 'gnome-terminal' -: TermEmu=. get_terminal'' do.
      e=. '<T> -- "\"<C>\"<A>"'rplc '<T>';TermEmu;'<C>';c;'<A>';arg
    else.
      e=. '<T> -e "\"<C>\"<A>"'rplc '<T>';TermEmu;'<C>';c;'<A>';arg
    end.
  end.
end.

if. rh do.
  r=. desktoprh rplc '<N>';n
  r=. r rplc '<E>';e
  r=. r rplc '<W>';W
  r=. r rplc '<I>';I,icon
  r=. r rplc '<TT>';(type-:'jc'){'false';'true'
  r fwrite f
  2!:0 ::0: 'chmod +x ',f
else.
  r=. desktop rplc '<N>';n
  r=. r rplc '<E>';e
  r=. r rplc '<W>';W
  r=. r rplc '<I>';I,icon
  r fwrite f
  2!:0 ::0: 'chmod +x ',f
end.
)

NB. Darwin
plist=: 0 : 0
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "https://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
<key>CFBundleExecutable</key><string>apprun</string>
<key>CFBundleIconFile</key><string>i.icns</string>
<key>CFBundleInfoDictionaryVersion</key><string>6.0</string>
<key>CFBundleName</key><string>j</string>
<key>CFBundlePackageType</key><string>APPL</string>
<key>CFBundleVersion</key><string>1.0</string>
</dict></plist>
)

COM=: jpath'~temp/launch.command'

Darwin=: 3 : 0
defaults''
Darwinx y
)


Darwinx=: 3 : 0
select. y
case.'jc' do.
  darwin'jc' ;'jconsole';'jgray.icns';LIB
case. 'jhs' do.
  darwin'jhs';'jconsole';'jblue.icns';LIB,A
case. 'jqt' do.
  darwin'jqt';'jqt' ;'jgreen.icns';LIB
case. do.
  assert 0
end.
i.0 0
)

NB. 1 jhs - 0 jconsole
darwin=: 3 : 0
'type bin icon arg'=. y
n=. type,N
f=. L,type,N,DS
c=. hostpathsep jpath '~bin/',bin
select. type
case.'jc' do.
NB. r=. '#!/bin/sh',LF,'open "',c,'"'
  r=. new_launch rplc '<COM>';COM;'<C>';(hostpathsep jpath '~bin/jconsole');'<A>';LIB
case. 'jhs' do.
  r=. new_launch rplc '<COM>';COM;'<C>';(hostpathsep jpath '~bin/jconsole');'<A>';LIB,A
case. 'jqt' do.
  r=. '#!/bin/sh',LF,'"',c,'.command" ',LIB
end.
fpathcreate f,'/Contents/MacOS'
fpathcreate f,'/Contents/Resources'
plist fwrite f,'/Contents/info.plist'
r fwrite f,'/Contents/MacOS/apprun'
(fread '~bin/icons/',icon) fwrite f,'/Contents/Resources/i.icns'
2!:0 ::0: 'chmod -R +x ',f
)

new_launch=: 0 : 0
#!/bin/sh
echo '#!/bin/sh' > "<COM>"
echo '"<C>" <A>' >> "<COM>"
chmod +x <COM>
open "<COM>"
)
