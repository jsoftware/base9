
NB. =========================================================
NB. viewimage
NB.
NB. open image filename
viewimage=: 3 : 0
if. -. isURL cmd=. dltb y do.
  if. -.fexist cmd do. EMPTY return. end.
end.
if. IFJHS do.
  redirecturl_jijxm_=: file2url cmd
  EMPTY return.
elseif. IFIOS>IFQT do.
  jh '<a href="',(file2url cmd),'"</a>'
  EMPTY return.
end.
nox=. ((<UNAME)e.'Linux';'OpenBSD';'FreeBSD') *. (0;'') e.~ <2!:5 'DISPLAY'
ImageViewer=. nox{::ImageViewer_j_;ImageViewer_nox_j_
select. UNAME
case. 'Win' do.
  ShellExecute=. 'shell32 ShellExecuteW > i x *w *w *w *w i'&cd
  SW_SHOWNORMAL=. 1
  NULL=. <0
  r=. ShellExecute 0;NULL;(uucp winpathsep cmd);NULL;NULL;SW_SHOWNORMAL
  if. r<33 do. sminfo 'view image error: ',cmd,LF2,1{::cderx'' end.
case. 'Android' do.
  android_exec_host 'android.intent.action.VIEW';(utf8 ('file://'&,)@abspath^:(-.@isURL) cmd);'image/*';0
case. do.
  if. 0 = #ImageViewer do.
    ImageViewer=. dfltimageviewer''
  end.
  if. 0 = #ImageViewer do.
    browser=. Browser_j_
    if. 0 = #browser do.
      browser=. dfltbrowser''
    end.
    browser=. dquote (browser;Browser_nox_j_){::~ nox=. ((<UNAME)e.'Linux';'OpenBSD';'FreeBSD') *. (0;'') e.~ <2!:5 'DISPLAY'
  else.
    browser=. dquote ImageViewer
  end.
  cmd=. browser,' ',dquote cmd
  try.
    2!:1 cmd, (0=nox)#' >/dev/null 2>&1 &'
  catch.
    msg=. 'Could not run the image viewer with the command:',LF2
    msg=. msg, cmd,LF2
    if. IFQT do.
      msg=. msg, 'You can change the imageviewer definition in Edit|Configure|Base',LF2
    end.
    sminfo 'Run image viewer';msg
  end.
end.
EMPTY
)

NB. =========================================================
NB. dfltimageviewer ''
NB.     return default imageviewer, or ''
dfltimageviewer=: verb define
select. UNAME
case. 'Win' do. ''
case. 'Android' do. ''
case. 'Darwin' do. 'open'
case. do.
  try.
    2!:0'which xdg-open 2>/dev/null'
    'xdg-open' return. catch. end.
  try.
    2!:0'which eog 2>/dev/null'
    'eog' return. catch. end.
  '' return.
end.
)
