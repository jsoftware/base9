coclass'jtar'

tarhelp=: 0 : 0
tar utilities - implements simple tar subset

unix tar
 tar -x -f f.tar -C path
 tar -c -f f.tar -C path folder
 tar -t -f f.tar

J tar
 load'tar'
 tar 'x';'f.tar';path
 tar 'c';'f.tar';path;folder
 tar 't';'f.tar'

 if the tar file name ended with .tar.gz or .tgz, compression flag z is implied

for example,
 on computer
  $> tar -c -f ~/j9/temp/math.tar -C ~/j9/addons finance
  iTunes connect - move math.tar to J app folder

 on J
  tar 't';'finance.tar'
  tar 'x';'finance.tar';'~addons'

J gzip
       gzip '~temp/f.gz' - return data from f.gz
  data gzip '~/temp/f.gz' - write data to f.gz
)

NB. for windows, copy zlib1.dll from gtk binary to j.dll folder or windows/system32
libz=: IFUNIX{::'zlib1.dll';unxlib^:IFUNIX 'z'
cv=: IFWIN#'+'
null=: {.a.
chksum=: 148+i.8
folderx=: '000755 ',null,'000765 ',null,'000024 ',null
filex=: '000644 ',null,'000765 ',null,'000024 ',null

no_gzbuffer=: 0
