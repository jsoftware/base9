NB. check

NB. =========================================================
CHECKADDONSDIR=: 0 : 0
The addons directory does not exist and cannot be created.

It is set to: XX.

You can either create the directory manually, or set a new addons directory in your profile script.
)

NB. =========================================================
CHECKASK=: 0 : 0
Read catalog from the server using Internet connection now?

Otherwise the local catalog is used offline.
)

NB. =========================================================
CHECKONLINE=: 0 : 0
An active Internet connection is needed to install packages.

Continue only if you have an active Internet connection.

OK to continue?
)

NB. =========================================================
CHECKREADSVR=: 0 : 0
An active Internet connection is needed to read the server repository catalog.

Continue only if you have an active Internet connection.

OK to continue?
)

NB. =========================================================
CHECKSTARTUP=: 0 : 0
Setup repository using Internet connection now?

Select No if not connected, to complete setup later. After Setup is done, repository can be used offline with more options in Tools menu and Preferences dialog.
)

NB. =========================================================
checkaccess=: 3 : 0
if. testaccess'' do. 1 [ HASFILEACCESS_jpacman_=: 1 return. end.
msg=. 'Package Manager will run in read-only mode, as you do not have access to the installation folder.'
if. IFWIN do.
  msg=. msg,LF2,'To run as Administrator, right-click the J icon, select Run as... and '
  msg=. msg,'then select Adminstrator.'
else.
  msg=. msg,LF2,'To run as root, open a terminal and use sudo to run J.'
end.
info msg
0
)

NB. =========================================================
NB. check addons directory exists
checkaddonsdir=: 3 : 0
d=. jpath '~addons'
if. # 1!:0 d do. 1 [ HASADDONSDIR_jpacman_=: 1 return. end.
if. 1!:5 :: 0: <d do.
  log 'Created addons directory: ',d
  1 [ HASADDONSDIR=: 1 return.
end.
info CHECKADDONSDIR rplc 'XX';d
0
)

NB. =========================================================
NB. defines and returns online state from query
getonline=: 3 : 0
ONLINE=: 2=3 2 wdquery y
)

NB. =========================================================
NB. get state from server, return OK flag
getserver=: 3 : 0
'rc p'=. httpgetr (WWW,'revision.txt');2
if. rc do. 0 return. end.
write_lastupdate''
WWWREV=: fixrev p
if. WWWREV = REV do. 1 return. end.
refreshweb''
)

NB. =========================================================
NB. called at startup
NB. sets ONLINE state
NB. returns ok to continue flag
checkonline=: 3 : 0
select. ReadCatalog_j_
case. 0 do.
  if. REV >: 0 do.
    ONLINE=: 0
    log 'Using local copy of catalog. See Preferences to change the setting.'
    1 return.
  end.
  if. 0 = getonline 'Read Catalog from Server';CHECKREADSVR do. 0 return. end.
case. 1 do.
  ONLINE=: 1
case. 2 do.
  if. REV >: 0 do.
    if. 0 = getonline 'Read Catalog from Server';CHECKASK do.
      log 'Using local copy of catalog. See Preferences to change the setting.'
      1 return.
    end.
  else.
    if. 0 = getonline 'Setup Repository';CHECKSTARTUP do. 0 return. end.
  end.
end.
log 'Updating server catalog...'
if. 0 = getserver'' do.
  ONLINE=: 0
  log 'Working offline using local copy of catalog.'
else.
  log 'Done.'
end.
1
)

NB. =========================================================
NB. returns status message
checkstatus=: 3 : 0
if. 0 e. #LIBS do. '' return. end.
msk=. masklib PKGDATA
ups=. pkgups''
libupm=. 1 e. msk *. ups
msk=. -. msk
addnim=. +/msk *. pkgnew''
addupm=. +/msk *. pkgups''
tot=. +/addnim,addupm,libupm
if. 0 = tot do.
  'All available packages are installed and up to date.' return.
end.
select. 0 < addnim,addupm
case. 0 0 do.
  msg=. 'Addons are up to date.'
case. 0 1 do.
  msg=. 'All addons are installed, ',(":addupm), ' can be upgraded.'
case. 1 0 do.
  if. addnim = <:#PKGDATA do.
    msg=. 'No addons are installed.'
  else.
    j=. ' addon',('s'#~1<addnim),' are not yet installed.'
    msg=. 'Installed addons are up to date, ',(":addnim),j
  end.
case. 1 1 do.
  j=. (":addupm),' addon',('s'#~1<addupm),' can be upgraded, '
  msg=. j,(":addnim), ' addon',('s'#~1<addnim),' are not yet installed.'
end.
if. 0 = libupm do.
  msg,LF,'The base library is up to date.'
else.
  msg,LF,'There is a newer version of the base library.'
end.
)

NB. =========================================================
write_lastupdate=: 3 : 0
txt=. ": 6!:0 ''
txt fwrites ADDCFG,'lastupdate.txt'
)

NB. =========================================================
NB. checklastupdate v Returns timestamp of last update of local JAL info
NB. Could be integrated into existing checkstatus verb?
checklastupdate=: 3 : 0
if. _1 -: LASTUPD do.
  res=. 'has never been updated.'
else.
  res=. 'was last updated: ',timestamp LASTUPD
end.
'Local JAL information ',res
)
