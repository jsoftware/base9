NB. browser

NB. =========================================================
dquote=: 3 : 0
if. '"' = {.y do. y else. '"',y,'"' end.
)

NB. =========================================================
NB. browse
NB.
NB. load url/filename in browser
browse=: 3 : 0
if. -. isURL cmd=. dltb y do.
  if. -.fexist cmd do. EMPTY return. end.
end.
if. IFJHS do.
  redirecturl_jijxm_=: file2url cmd
  EMPTY return.
elseif. IFIOS do.
  jh '<a href="',(file2url cmd),'"</a>'
  EMPTY return.
end.
browser=. Browser_j_
select. UNAME
case. 'Win' do.
  ShellExecute=. 'shell32 ShellExecuteW > i x *w *w *w *w i'&cd
  SW_SHOWNORMAL=. 1
  NULL=. <0
  if. 0 = #browser do.
    r=. ShellExecute 0;(uucp 'open');(uucp winpathsep cmd);NULL;NULL;SW_SHOWNORMAL
  else.
    r=. ShellExecute 0;(uucp 'open');(uucp winpathsep browser);(uucp dquote winpathsep cmd);NULL;SW_SHOWNORMAL
  end.
  if. r<33 do. sminfo 'browse error:',browser,' ',cmd,LF2,1{::cderx'' end.
case. 'Android' do.
  android_exec_host 'android.intent.action.VIEW';(utf8 ('file://'&,)@abspath^:(-.@isURL) cmd);'text/html';16b0004000
case. do.
  if. 0 = #browser do.
    browser=. dfltbrowser''
  end.
  browser=. dquote (browser;Browser_nox_j_){::~ nox=. (UNAME-:'Linux') *. (0;'') e.~ <2!:5 'DISPLAY'
  cmd=. browser,' ',dquote cmd
  try.
    2!:1 cmd, (0=nox)#' >/dev/null 2>&1 &'
  catch.
    msg=. 'Could not run the browser with the command:',LF2
    msg=. msg, cmd,LF2
    if. IFQT do.
      msg=. msg, 'You can change the browser definition in Edit|Configure|Base',LF2
    end.
    sminfo 'Run Browser';msg
  end.
end.
EMPTY
)

NB. =========================================================
NB. dfltbrowser ''
NB.     return default browser, or ''
dfltbrowser=: verb define
select. UNAME
case. 'Android' do. ''
case. 'Win' do. ''
case. 'Darwin' do. 'open'
case. do.
  try.
    2!:0'which x-www-browser 2>/dev/null'
    'x-www-browser' return. catch. end.
  try.
    2!:0'which google-chrome 2>/dev/null'
    'google-chrome' return. catch. end.
  try.
    2!:0'which chromium 2>/dev/null'
    'chromium' return. catch. end.
  try.
    2!:0'which chromium-browser 2>/dev/null'
    'chromium-browser' return. catch. end.
  try.
    2!:0'which firefox 2>/dev/null'
    'firefox' return. catch. end.
  try.
    2!:0'which konqueror 2>/dev/null'
    'konqueror' return. catch. end.
  try.
    2!:0'which opera 2>/dev/null'
    'opera' return. catch. end.
  '' return.
end.
)
