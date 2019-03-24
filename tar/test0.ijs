
load 'tar'

cocurrent 'base'

NB. test gzip
t1=: 3 : 0
smoutput 'gzip 1e5'
a1=. a.{~ 1e5$ ?. 1e4#256
a1 gzip f=. '~temp/tar.gz'
smoutput (#a1),fsize f
assert. a1 -: gzip f

smoutput 'gzip 1e8'
a1=. a.{~ 1e8$ ?. 1e4#256
a1 gzip f=. '~temp/tar.gz'
smoutput (#a1),fsize f
assert. a1 -: gzip f
''
)

NB. test tar
t2=: 3 : 0
smoutput 'tar'
tar 'c';'~temp/odbc.tar';'~Addons/data';'odbc'
smoutput tar 't';'~temp/odbc.tar'
tar 'x';'~temp/odbc.tar';'~temp'
smoutput 'tar.gz'
tar 'c';'~temp/odbc.tar.gz';'~Addons/data';'odbc'
smoutput tar 't';'~temp/odbc.tar.gz'
tar 'x';'~temp/odbc.tar.gz';'~temp/z'
smoutput 'tgz'
tar 'c';'~temp/odbc.tgz';'~Addons/data';'odbc'
smoutput tar 't';'~temp/odbc.tgz'
tar 'x';'~temp/odbc.tgz';'~temp/z1'
''
)

no_gzbuffer_jtar_=: 1
smoutput 'no_gzbuffer_jtar_=: 1'
t1''
t2''
no_gzbuffer_jtar_=: 0
smoutput 'no_gzbuffer_jtar_=: 0'
t1''
t2''
