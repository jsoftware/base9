NB. unxlib
NB.%unxlib.ijs - common shared library for UNIX
NB.-This script defines the common shared library for UNIX and is included in the J standard library.
NB.-Definitions are loaded into the z locale.

cocurrent <'z'

NB. =========================================================
NB.*UNXLIB n table of common shared libraries
NB. pre-built libxml2.so not available in android
UNXLIB=: ([: <;._1 ' ',]);._2 (0 : 0)
libc.so.6 libc.so.7 libc.so.7 libc.so libc.dylib libc.so
libz.so.1 libz.so.7 libz.so.6 libz.so libz.dylib libz.so
libsqlite3.so.0 libsqlite3.so.0 libsqlite3.so.0 libsqlite.so libsqlite3.dylib libsqlite3.so
libxml2.so.2 libxml2.so.18.0 libxml2.so.2 libxml2.so libxml2.dylib libxml2.so
libpcre2-8.so.0 libpcre2-8.so.0.6 libpcre2-8.so.0 libpcre2-8.so libpcre2-8.dylib libpcre2-8.so
)
3 : 0^:((<UNAME)e.'Linux';'OpenBSD';'FreeBSD')''
b=. (<UNAME)i.~'Linux';'OpenBSD';'FreeBSD'
a=. 2!:0 ::(''"_) b{::'/sbin/ldconfig -p';'/sbin/ldconfig -r';'/sbin/ldconfig -r'
if. #a1=. I. '/libc.so.' E. a do.
  UNXLIB=: (<({.~i.&(10{a.))}.a}.~{.a1) (<0,b)}UNXLIB
end.
if. #a1=. I. '/libz.so.' E. a do.
  UNXLIB=: (<({.~i.&(10{a.))}.a}.~{.a1) (<1,b)}UNXLIB
end.
if. #a1=. I. '/libsqlite3.so.' E. a do.
  UNXLIB=: (<({.~i.&(10{a.))}.a}.~{.a1) (<2,b)}UNXLIB
end.
if. #a1=. I. '/libxml2.so.' E. a do.
  UNXLIB=: (<({.~i.&(10{a.))}.a}.~{.a1) (<3,b)}UNXLIB
end.
if. #a1=. I. '/libpcre2-8.so.' E. a do.
  UNXLIB=: (<({.~i.&(10{a.))}.a}.~{.a1) (<4,b)}UNXLIB
end.
''
)
NB. =========================================================
NB.*unxlib v return the name of a shared library.
NB.-example:
NB.+unxlib 'c'
unxlib=: 3 : 0
r=. (;: 'c z sqlite3 libxml2 pcre2') i. <,y
c=. (;: 'Linux OpenBSD FreeBSD Android Darwin') i. <UNAME_z_
(<r,c) {:: UNXLIB_z_
)
