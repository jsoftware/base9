NB. android
NB.%android.ijs - android utilities
NB.-This script defines android utilities and is included in the J standard library.
NB.-Definitions are loaded into the z locale.

18!:4 <'z'

NB. =========================================================
NB.*anddf v android download file
NB.-Download a file via android's embedded http client overwriting target file.
NB.-example:
NB.+'http://www.jsoftware.com/moin_static180/common/jwlogo.png' anddf jpath'~temp/jwlogo.png'
NB.-
NB.-syntax:
NB.+x anddf y
NB.-returns:
NB.- >=0 success, number of bytes in file
NB.-  _1 unknown error
NB.-  _2 target file exists and is not writable
NB.-  _3 parent directory is not writable
NB.-  _5 malformed url
NB.-  _6 i/o exception during transport
NB.-  _99 web request returns invalid '0' status code
NB.- <= _100 negation of unsuccessful http response code (!=200), ie. _404 "Not Found"

anddf=: 4 : '''libj.so android_download_file > i *c *c'' 15!:0 x;y'

NB. =========================================================
NB.*andunzip v android zip
NB.-Monadically, it unzips the file at y into the same directory.
NB.-
NB.-Optional x may specify an alternate output directory
NB.-
NB.-syntax:
NB.+andunzip y ; x andunzip y
NB.-
NB.-returns:
NB.-  0 success
NB.- _1 generic i/o error
NB.- _2 zipfile not found
NB.- _3 output directory not writable
NB.- _4 zip format exception
andunzip=: 3 : 0
'' andunzip y
:
'libj.so java_unzip_file > i *c *c' 15!:0 y;x
)

NB. start new activity using intent
android_exec_am=: 3 : 0
'intent uri mimetype flags'=. 4{.y
user=. (UserNumber_ja_"_)^:(0=4!:0<'UserNumber_ja_') (_1)
2!:0 ::0: utf8 'am start ',((user>:0)#'--user ', ":user),' -a ', intent, ' -d ', (dquote uri), ((*#mimetype)#' -t ', mimetype), ((0~:flags)#' -f ', ":flags)
i.0 0
)

android_exec_host=: 2!:1@(3&{.)`android_exec_am@.(0=4!:0<'AndroidPackage')

NB. return rotation, density, densityDpi, heightPixels, scaledDensity, widthPixels, xdpi, ydpi
NB. rotation: 0=portrait, 1=landscape.  width and height varies with rotation
NB. xdpi and ydpi are un-reliable
android_getdisplaymetrics=: 3 : 0
NB. asus zenfone 6
dm=. 0 2 320 1280 2 720 243.247 244.273
NB. API level 18 (android 4.3) have wm command
if. 18<:APILEVEL_ja_ do.
NB. cache values because wm density/size are slow
  if. 0=4!:0<'android_getdisplaymetrics_memo_ja_' do.
    dm=. android_getdisplaymetrics_memo_ja_
  else.
    try.
      densityDpi=. 0&". ' '-.~ (}.~ i:&' ') LF-.~ 2!:0 'wm density'
      ('widthPixels heightPixels')=: 0&". ;._1 'x', ' '-.~ (}.~ i:&' ') LF-.~ 2!:0 'wm size'
NB. kludge
      density=. (0.5*heightPixels>480) + (0.5*heightPixels>320) + densityDpi% 160
      dm=. 1 2 3 4 5 (density, densityDpi, heightPixels, density, widthPixels)}dm
    catch. end.
    android_getdisplaymetrics_memo_ja_=: dm
  end.
end.
'DM_density_ja_ DM_densityDpi_ja_ DM_scaledDensity_ja_'=: 1 2 4{dm
dm
)
