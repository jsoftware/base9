NB.-files
NB.%files.ijs - file utilities
NB.-This script defines file utilities and is included in the J standard library.
NB.-Definitions are loaded into the z locale.
NB.-
NB.-read verbs take a right argument of a filename, optionally
NB.-linked with one or two numbers (as for 1!:11):
NB.-  0 = start of read (may be negative)
NB.-  1 = length of read (default rest of file)
NB.-
NB.-write verbs return number of characters written.
NB.-
NB.-filenames may be open or boxed character or unicode strings
NB.-
NB.-string verbs write out text delimited with the host OS delimiter,
NB.-and read in text delimited by LF.
NB.-
NB.-on error, the result is _1,
NB.-e.g. for file not found/file read error/file write error
NB.
NB.-   dat fappend fl     append
NB.-   dat fappends fl    append string
NB.-  verb fapplylines fl apply verb to lines of file
NB.-   to  fcopynew fls   copy files (if changed)
NB.-       fdir           file directory
NB.-       ferase fl      erase file
NB.-       fexist fl      return 1 if file exists
NB.-       fpathname      split file path into path;name
NB.-   opt fread fl       read file
NB.-   opt freadblock fl  read lines of file in blocks
NB.-       freadr fl      read records (flat file)
NB.-       freads fl      read string
NB.-    to frename fl     rename file
NB.-   dat freplace fl    replace in file
NB.-   opt fselect txt    select file
NB.-       fsize fl       size of file
NB.-   str fss fl         string search file
NB.-oldnew fssrplc fl     search and replace in file
NB.-       fstamp fl      file timestamp
NB.-       fgets txt      convert text read from file to J string
NB.-       fview fl       view file (requires textview)
NB.-   dat fwrite fl      write file
NB.-   dat fwrites fl     write string

cocurrent 'z'

fexists=: #~ fexist
f2utf8=: ]

NB. =========================================================
NB.*fboxname v fix and box filename
fboxname=: <@(fixdotdot^:IFIOS)@jpath_j_@(8 u: >) ::]

NB. =========================================================
NB.*fappend v append text to file
NB.-Append text to file.
NB.-
NB.-The text is first ravelled. The file is created if necessary.
NB.-
NB.-Returns number of characters written, or an error message.
NB.-
NB.-syntax:
NB.+text fappend filename
NB.-
NB.-example:
NB.+   'chatham' fappend 'newfile.txt'
NB.+7
fappend=: 4 : 0
(,x) (#@[ [ 1!:3) :: _1: fboxname y
)

NB. =========================================================
NB.*fappends v append string to file
NB.-Append string to file.
NB.-
NB.-The text is first ravelled into a vector with each row
NB.-terminated by the host delimiter.
NB.-
NB.-The file is created if necessary. Returns number of characters
NB.-written, or an error message.
fappends=: 4 : 0
(fputs x) (#@[ [ 1!:3) :: _1: fboxname y
)

NB. =========================================================
NB.*fapplylines a apply verb to lines in file delimited by LF
NB.-Apply verb to lines in file delimited by LF.
NB.
NB.-syntax:
NB.-    lineproc fapplylines file  NB. line terminators removed
NB.-  1 lineproc fapplylines file  NB. line terminators preserved
fapplylines=: 1 : 0
0 u fapplylines y
:
y=. > fboxname y
s=. 1!:4 <y
if. s = _1 do. return. end.
p=. 0
dat=. ''
while. p < s do.
  b=. 1e6 <. s-p
  dat=. dat, 1!:11 y;p,b
  p=. p + b
  if. p = s do.
    len=. #dat=. dat, LF -. {:dat
  elseif. (#dat) < len=. 1 + dat i:LF do.
    'file not in LF-delimited lines' 13!:8[3
  end.
  if. x do.
    u ;.2 len {. dat
  else.
    u ;._2 CR -.~ len {. dat
  end.
  dat=. len }. dat
end.
)

NB. =========================================================
NB.*fcopynew v copies files if changed
NB.-Copies files if changed.
NB.-syntax:
NB.+tofile fcopynew fromfiles
NB.-
NB.- returns: 0, size    not changed
NB.-          1, size    changed
NB.-         _1         failure
fcopynew=: 4 : 0
dat=. fread each boxopen y
if. (<_1) e. dat do. _1 return. end.
dat=. ; dat
if. dat -: fread :: 0: x do. 0,#dat else.
  if. _1=dat fwrite x do. _1 else. 1,#dat end.
end.
)

NB. =========================================================
NB.*fdir v file directory
NB.-example:
NB.+fdir jpath '~system/main/s*.ijs'
fdir=: 1!:0@fboxname

NB. =========================================================
NB.*ferase v erases a file
NB.-Erases a file.
NB.-
NB.-Returns 1 if successful, otherwise _1
ferase=: (1!:55 :: _1:) @ (fboxname &>) @ boxopen

NB. =========================================================
NB.*fexist v test if a file exists
NB.-Returns 1 if the file exists, otherwise 0.
fexist=: (1:@(1!:4) :: 0:) @ (fboxname &>) @ boxopen

NB. =========================================================
NB.*fgets v convert text read from file to J string
fgets=: 3 : 0
y=. (-(26{a.)={:y) }. y
if. 0=#y do. '' return. end.
y,LF -. {:y=. toJ y
)

NB. =========================================================
NB.*fmakex v make file executable
fmakex=: (] 1!:7~ 'x' 2 5 8} 1!:7) @ fboxname

NB. =========================================================
NB.*fpathcreate v create a folder path, returning success
fpathcreate=: 3 : 0
if. 0=#y do. 1 return. end.
p=. (,'/'-.{:) jpathsep y
if. # 1!:0 }: p do. 1 return. end.
for_n. I. p='/' do. 1!:5 :: 0: < n{.p end.
)

NB. =========================================================
NB.*fpathname v split file name into path;name
fpathname=: +./\.@:=&'/' (# ; -.@[ # ]) ]

NB. =========================================================
NB.*fread v read file
NB.-Read file.
NB.-
NB.- y is filename {;start size}
NB.- optional x calls freads
fread=: 3 : 0
if. 1 = #y=. boxopen y do.
  1!:1 :: _1: fboxname y
else.
  1!:11 :: _1: (fboxname {.y),{:y
end.
:
x freads y
)

NB. =========================================================
NB.*freadblock v read block of lines from file
NB.-Read block of lines from file.
NB.-
NB.-Lines are terminated by LF.
NB.-
NB.-Blocksize defaults to 1e6
NB.-
NB.-y is filename;start position
NB.-
NB.-returns: block;new start position
freadblock=: 3 : 0
1e6 freadblock y
:
'f p'=. y
f=. > fboxname f
s=. 1!:4 <f
if. s = _1 do. return. end.
if. (s = 0) +. p >: s do. '';p return. end.
if. x < s-p do.
  dat=. 1!:11 f;p,x
  len=. 1 + dat i: LF
  if. len > #dat do.
    'file not in LF-delimited lines' 13!:8[3
  end.
  p=. p + len
  dat=. len {. dat
else.
  dat=. 1!:11 f;p,s-p
  dat=. dat, LF -. {: dat
  p=. s
end.
(toJ dat);p
)

NB. =========================================================
NB.*freadr v read records from flat file
NB.-Read records from flat file.
NB.-
NB.-y is filename {;record start, # of records}
NB.-
NB.-Records are assumed of fixed length delimited by
NB.-one (only) of CR, LF, or CRLF.
NB.-
NB.-the result is a matrix of records.
freadr=: 3 : 0
'f s'=. 2{.boxopen y
f=. fboxname f
max=. 1!:4 :: _1: f
if. max -: _1 do. return. end.
pos=. 0
step=. 10000
whilst. blk = cls
do.
  blk=. step<.max-pos
  if. 0=blk do. 'file not organized in records' return. end.
  dat=. 1!:11 f,<pos,blk
  cls=. <./dat i.CRLF
  pos=. pos+step
end.
len=. cls+pos-step
dat=. 1!:11 f,<len,2<.max-len
dlm=. +/CRLF e. dat
wid=. len+dlm
s=. wid*s,0 #~ 0=#s
dat=. 1!:11 f,<s
dat=. (-wid)[\dat
(-dlm)}."1 dat
)

NB. =========================================================
NB.*freads v read file as string
NB.-Read file as string.
NB.-
NB.- y is filename {;start size}
NB.- x is optional (b and m same as fread):
NB.-    = b    read as boxed vector
NB.-    = m    read as matrix
freads=: 3 : 0
'' freads y
:
dat=. fread y
if. (dat -: _1) +. 0=#dat do. return. end.
dat=. fgets dat
if. 'b'e.x do. dat=. <;._2 dat
elseif. 'm'e.x do. dat=. ];._2 dat
end.
)

NB. =========================================================
NB.*frename v renames file
NB.-syntax:
NB.+newname frename oldname
NB.-
NB.-Returns 1 if rename successful.
frename=: 4 : 0
x=. > fboxname x
y=. > fboxname y
if. x -: y do. 1 return. end.
if. IFUNIX do.
  0=((unxlib 'c'),' rename > i *c *c') 15!:0 y;x
else.
  'kernel32 MoveFileW > i *w *w' 15!:0 (uucp y);uucp x
end.
)

NB. =========================================================
NB.*freplace v replace text in file
NB.-
NB.-syntax:
NB.+dat freplace file;pos
freplace=: 4 : 0
y=. boxopen y
dat=. ,x
f=. #@[ [ 1!:12
dat f :: _1: (fboxname {.y),{:y
)

NB. =========================================================
NB.*fsize v return file size
NB.-
NB.-Returns file size or _1 if error
fsize=: (1!:4 :: _1:) @ (fboxname &>) @ boxopen

NB. =========================================================
NB.*fss v file string search
NB.-Search file for string, returning indices.
NB.-
NB.-syntax:
NB.+str fss file
fss=: 4 : 0
y=. fboxname y
size=. 1!:4 :: _1: y
if. size -: _1 do. return. end.
blk=. (#x) >. 100000 <. size
r=. i.pos=. 0
while. pos < size do.
  dat=. 1!:11 y,<pos,blk <. size-pos
  r=. r,pos+I. x E. dat
  pos=. pos+blk+1-#x
end.
r
)

NB. =========================================================
NB.*fssrplc v file string search and replace
NB.-
NB.-syntax:
NB.+(old;new) fssrplc file
fssrplc=: fstringreplace

NB. =========================================================
NB.*fstamp v returns file timestamp
fstamp=: (1: >@{ , @ (1!:0) @ fboxname) :: _1:

NB. =========================================================
NB.fputs v convert text for file write as string
fputs=: 3 : 0
dat=. ":y
if. 0 e. $dat do.
  ''
else.
  if. 1>:#$dat do.
    toHOST dat,(-.({:dat) e. CRLF) # LF
  else.
    ,dat,"1 toHOST LF
  end.
end.
)

NB. =========================================================
NB.*ftype v get file type
NB.-Get file type, as:
NB.-
NB.- 0 = not exist
NB.- 1 = file
NB.- 2 = directory
ftype=: 3 : 0
NB. windows needs 1!:4 for synchronization
(1:@(1!:4) :: 0:)^:IFWIN < f=. }: ^: ('/' = {:) , > fboxname y
d=. 1!:0 f
if. #d do.
  >: 'd' = 4 { > 4 { ,d
else.
  0
end.
)

NB. =========================================================
NB.*fview v view file (requires textview)
fview=: 3 : 0
if. 3 ~: nc <'textview_z_' do.
  sminfo 'textview not available.' return.
end.
txt=. freads y
if. txt -: _1 do.
  sminfo 'file not found: ',,>y return.
end.
textview txt
)

NB. =========================================================
NB.*fwrite v write text to file
fwrite=: 4 : 0
(,x) (#@[ [ 1!:2) :: _1: fboxname y
)

NB. =========================================================
NB.*fwrite v write text to file if changed
fwritenew=: 4 : 0
dat=. ,x
if. dat -: fread y do. 0 return. end.
dat fwrite y
)

NB. =========================================================
NB.*fwrites v write string to file
fwrites=: 4 : 0
(fputs x) (#@[ [ 1!:2) :: _1: fboxname y
)
