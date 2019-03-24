NB. read

NB. =========================================================
NB. read installed library
readlin=: 3 : 0
LIN=: 6 1 1 >. fixver JLIB
)

NB. =========================================================
readlocal=: 3 : 0
readlin''
ADDONS=: fixjal freads ADDCFG,'addons.txt'
ADDINS=: fixjal2 freads ADDCFG,'addins.txt'
REV=: fixrev freads ADDCFG,'revision.txt'
LASTUPD=: fixupd freads ADDCFG,'lastupdate.txt'
LIBS=: fixlibs freads ADDCFG,'library.txt'
LIB=: fixlib LIBS
ZIPS=: fixzips freads ADDCFG,'zips.txt'
EMPTY
)

NB. =========================================================
NB. j library tree: stable/current
NB. default is current
NB. old beta tree is obsolete
readtree=: 3 : 0
f=. ADDCFG,'tree.txt'
tree=. LF -.~ freads f
if. -. (<tree) e. 'current';'stable' do.
  tree=. 'current'
  writetree tree
end.
tree
)

NB. =========================================================
writetree=: 3 : 0
y fwritenew ADDCFG,'tree.txt'
)
