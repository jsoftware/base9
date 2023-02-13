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
if. IFIOS do.
  <;._2 IgnoreIOS
else.
  <'ide/ios'
end.
)

NB. =========================================================
3 : 0''
HTTPCMD=: ''
nc=. '--no-cache'
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
  HTTPCMD=: bbx,' wget -q -O %O %U'
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
JRELEASE=: getJverold ''
LIBTREE=: readtree''
if. IFIOS do.
  WWW=: '/jal/',JRELEASE,'/'
else.
  WWW=: 'http://www.jsoftware.com/jal/',JRELEASE,'/'
end.
)

NB. =========================================================
destroy=: codestroy
