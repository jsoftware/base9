NB. PDFReader

NB. =========================================================
NB. viewpdf
NB.
NB. open filename in PDFReader
viewpdf=: 3 : 0
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
nox=. (UNAME-:'Linux') *. (0;'') e.~ <2!:5 'DISPLAY'
PDFReader=. nox{::PDFReader_j_;PDFReader_nox_j_
select. UNAME
case. 'Win' do.
  ShellExecute=. 'shell32 ShellExecuteW > i x *w *w *w *w i'&cd
  SW_SHOWNORMAL=. 1
  NULL=. <0
  if. 0 = #PDFReader do.
    r=. ShellExecute 0;(uucp 'open');(uucp winpathsep cmd);NULL;NULL;SW_SHOWNORMAL
  else.
    r=. ShellExecute 0;(uucp 'open');(uucp winpathsep PDFReader);(uucp dquote winpathsep cmd);NULL;SW_SHOWNORMAL
  end.
  if. r<33 do. sminfo 'view pdf error:',PDFReader,' ',cmd,LF2,1{::cderx'' end.
case. 'Android' do.
  android_exec_host 'android.intent.action.VIEW';(utf8 ('file://'&,)@abspath^:(-.@isURL) cmd);'application/pdf';0
case. do.
  if. 0 = #PDFReader do.
    PDFReader=. dfltpdfreader''
  end.
  PDFReader=. dquote PDFReader
  cmd=. PDFReader,' ',(dquote cmd),' &'
  try.
    2!:1 cmd
  catch.
    msg=. 'Could not run the PDFReader with the command:',LF2
    msg=. msg, cmd,LF2
    if. IFQT do.
      msg=. msg, 'You can change the PDFReader definition in Edit|Configure|Base',LF2
    end.
    sminfo 'Run PDFReader';msg
  end.
end.
EMPTY
)

NB. =========================================================
NB. dfltpdfreader ''
NB.     return default PDFReader, or ''
dfltpdfreader=: verb define
select. UNAME
case. 'Win' do. ''
case. 'Darwin' do. 'open'
case. do.
  try.
    2!:0'which evince 2>/dev/null'
    'evince' return. catch. end.
  try.
    2!:0'which kpdf 2>/dev/null'
    'kpdf' return. catch. end.
  try.
    2!:0'which xpdf 2>/dev/null'
    'xpdf' return. catch. end.
  try.
    2!:0'which okular 2>/dev/null'
    'okular' return. catch. end.
  try.
    2!:0'which acroread 2>/dev/null'
    'acroread' return. catch. end.
  '' return.
end.
)
