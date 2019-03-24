NB. =========================================================
NB. export to z locale

NB.*jpkg v Manages packages (addons, base library) from JAL
NB. eg: 'update' jpkg ''
NB. eg: 'install' jpkg 'all'
NB. eg: 'install' jpkg 'convert/misc tables/csv'
NB. eg: 'install' jpkg 'base library'
NB. eg: 'show' jpkg 'all'
NB. eg: 'showupgrade' jpkg ''
NB. result: current status of local addon library.
NB. y is: space-delimited literal list of addon names to install or upgrade
NB.       or list of boxed addon names.
NB. x is: literal option value: history, install, manifest, reinstall
NB.        remove, search, show, showupgrade, showinstalled,
NB.        shownotinstalled, update, upgrade.
NB. require 'pacman'
jpkg_z_=: 3 : 0
'help' jpkg y
:
a=. conew 'jpacman'
res=. x jpkg__a y
destroy__a''
res
)

NB.*jpkgv v Same as jpkg but with more compact output
NB. Use to view on screen or include in emails
jpkgv_z_=: (<@:>"1@|:^:(0 ~: #))@jpkg

NB.*je_update v update JE in place
je_update_z_=: je_update_jpacman_
