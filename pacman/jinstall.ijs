NB. jinstall

NB. =========================================================
NB. jinstall v initial J install
NB. called by system installation script
NB.
NB.  ide is none/slim/full  - Qt IDE selection
NB.  addons is none/all     - Addons selection
NB.
NB. does:
NB.  JE update
NB.  Jqt install selected
NB.  Addons install selected
NB.  desktop shortcuts (if ~/Desktop folder)

NB. =========================================================
jinstall=: 3 : 0

JINSTALL=: 1

'j ide addons'=. 3 {. ;: y

ifide=. -. ide -: 'none'
ifaddons=. -. addons -: 'none'

echo 'Installing ', 1 pick revinfo_j_''

'update' jpkg ''
echo 'Updating J engine...'
je_update''

if. 2~:ftype jpath'~/Desktop' do.
  echo 'No Desktop folder, so shortcuts not installed'
else.
  echo 'Installing shortcuts...'
  shortcut'jbreak'
  shortcut'jc'
  shortcut'jhs'
  if. ifide do. shortcut'jqt' end.
end.

if. ifide do.
  echo 'Installing Jqt IDE...'
  'install' jpkg 'base library ide/qt'
  getqtbin ide
end.

if. addons -: 'all' do.
  echo 'Installing Addons...'
  'install' jpkg addons
end.

echo 'Installation complete'

exit 0

)
