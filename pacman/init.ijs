NB. =========================================================
NB. Package Manager for JAL - GUI & jconsole interfaces

NB. =========================================================
NB. init

cocurrent 'jpacman'
coinsert 'j'

BASELIB=: 'base library'
DATAMASK=: 0
HWNDP=: ''
ISGUI=: 0
INITDONE=: 0
HASFILEACCESS=: 0
HASADDONSDIR=: 0
ONLINE=: 0
PKGDATA=: 0 7$a:
SECTION=: ,<'All'
SYSNAME=: 'Package Manager'
TIMEOUT=: 60
WWWREV=: REV=: _1

IgnoreIOS=: 0 : 0
api/jni
data/dbman
data/ddmysql
data/odbc
demos/isigraph
demos/wd
demos/wdplot
games/minesweeper
games/nurikabe
games/pousse
games/solitaire
general/pcall
general/sfl
graphics/d3
graphics/fvj3
graphics/fvj4
graphics/gnuplot
graphics/graph
graphics/graphviz
graphics/grid
graphics/jturtle
graphics/print
graphics/tgsj
graphics/treemap
gui/monthview
gui/util
ide/qt
ide/ja
ide/jnet
math/tabula
media/animate
media/gdiplus
media/image3
media/imagekit
media/ming
media/paint
media/wav
)

Ignore=: 3 : 0''
if. IFIOS>IFQT do.
  <;._2 IgnoreIOS
else.
  <'ide/ios'
end.
)

NB. =========================================================
3 : 0''
HTTPCMD=: ''
nc=. '--no-cache'
NB. e.g. RELNO = '9.7', VERNO = 907
n=. 2 {. 100 #.inv >{.revinfo_j_''
RELNO=: ,'0,p<.>0' (8!:2) n
VERNO=: 100 #. n
if. IFUNIX do.
  IFWGET=. IFCURL=. 0
  if. -. IFIOS +. UNAME-:'Android' do.
    try.
      2!:0'which wget 2>/dev/null'
      IFWGET=. 1 catch. end.
    try.
      2!:0'which curl 2>/dev/null'
      IFCURL=. 1 catch. end.
  end.
  if. IFCURL do.
    HTTPCMD=: 'curl -L -o %O --stderr %L -f -s -S %U'
  elseif. IFWGET do.
    if. 'Android'-:UNAME do. nc=. ''
    else. try. nc=. nc #~ 1 e. nc E. shell 'wget --help' catch. nc=. '' end. end.
    HTTPCMD=: 'wget ',nc,' -O %O -o %L -t %t %U'
  end.
else.
  bbx=. '"','"',~jpath '~tools/ftp/busybox.exe'
  IFCURL=. 0
  if. 1=ftype f=. (2!:5'SystemRoot'),'\System32\curl.exe' do. NB. inside C:\Windows\System32 for windows 10 or newer
    IFCURL=. 1
  elseif. 1=ftype f=. jpath '~addons/web/gethttp/bin/curl.exe' do.
    IFCURL=. 1
  end.
  if. IFCURL do.
    HTTPCMD=: (dquote winpathsep f),' -L -o %O --stderr %L -f -s -S %U'
  else.
    HTTPCMD=: bbx,' wget -q -O %O %U'
  end.
  UNZIP=: bbx,' unzip -q -o '
end.
)

NB. =========================================================
NB. setfiles
NB.
NB. form: setfiles 'current'
setfiles=: 3 : 0
ADDCFG=: jpath '~addons/config/'
makedir ADDCFG
ADDCFGIJS=: ADDCFG,'config.ijs'
JRELEASE=: 'j', ": 100 #. 2 {. 100 #.inv >{.revinfo_j_''  NB. for jal
LIBTREE=: readtree''
if. IFIOS do.
  WWW=: '/jal/',JRELEASE,'/'
else.
  WWW=: 'https://www.jsoftware.com/jal/',JRELEASE,'/'
end.
)

NB. =========================================================
destroy=: codestroy
