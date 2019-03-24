
mkdir_j_ jpath '~Main/release/install/system/defs'

F=. cutopen 0 : 0
hostdefs_aix
hostdefs_android_64
hostdefs_android
hostdefs_darwin_64
hostdefs_darwin
hostdefs_linux_64
hostdefs_linux
hostdefs_sunos
hostdefs_win_64
hostdefs_win
netdefs_aix
netdefs_android_64
netdefs_android
netdefs_darwin_64
netdefs_darwin
netdefs_linux_64
netdefs_linux
netdefs_sunos
netdefs_win_64
netdefs_win
)

cp=. 3 : 0
fm=. jpath '~Main/defs/',y,'.ijs'
to=. jpath '~Main/release/install/system/defs/',y,'.ijs'
to fcopynew fm
)

cp each F
