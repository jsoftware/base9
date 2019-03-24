NB. busybox
NB.
NB. Usage: wget [-c|--continue] [--spider] [-q|--quiet] [-O|--output-document FILE]
NB.         [--header 'header: value'] [-Y|--proxy on/off] [-P DIR]
NB.         [-S|--server-response] [-U|--user-agent AGENT] URL...

NB. =========================================================
NB. busyboxget used for github downloads
NB. y is url;outfile
busyboxget=: 3 : 0
'f p'=. 2 {. (boxxopen y),a:
if. 0=#p do.
  p=. jpath '~temp/',f #~ -. +./\. f = '/'
end.
ferase p
cmd=. '"','"',~jpath '~tools/ftp/busybox.exe'
cmd=. cmd,' wget -O ',p,' ',f
fail=. 0
try.
  fail=. _1-: e=. shellcmd cmd
catch. fail=. 1 end.
if. fail +. 0 >: fsize p do.
  msg=. 'Connection failed'
  log msg
  r=. 1;msg
  ferase p
else.
  r=. 0;p
end.
r
)
