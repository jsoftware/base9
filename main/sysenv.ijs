NB. sysenv - System Environment
NB.%sysenv.ijs - system environment utilities
NB.-This script defines text system environment and is included in the J standard library.
NB.-Definitions are loaded into the z locale.

NB. ---------------------------------------------------------
NB. verbs:
NB.*hostpathsep v  converts path name to use host path separator
NB.*jpathsep v     converts path name to use / separator
NB.*winpathsep v   converts path name to use \ separator
NB.*jcwdpath v     adds path to J current working directory
NB.*jsystemdefs v  loads appropriate netdefs or hostdefs
NB.*IFDEF v        if DEFxxx exists

NB. ---------------------------------------------------------
NB. nouns:
NB.*IF64          n if a 64 bit J system
NB.*IFBE          n if a big-endian system
NB.*IFIOS         n if iOS (iPhone/iPad)
NB.*IFJA          n if J Android (not jconsole)
NB.*IFJHS         n if jhs libraries loaded
NB.*IFQT          n if Qt libraries loaded
NB.*IFRASPI       n if Raspberry Pi or Linux arm64
NB.*IFUNIX        n if UNIX
NB.*IFWIN         n if Windows (2000 and up)
NB.*IFWINCE       n if Windows CE
NB.*IFWINE        n if Wine (Wine Is Not an Emulator)
NB.*IFWOW64       n if running J32 on a 64 bit o/s
NB.*JLIB          n J library version
NB.*UNAME         n name of UNIX o/s
NB.*FHS           n filesystem hierarchy: 0=not used  1=linux and installed under /usr/...

18!:4 <'z'

NB. =========================================================
3 : 0 ''

JLIB=: 'JLIBVERSION'

notdef=. 0: ~: 4!:0 @ <
hostpathsep=: ('/\'{~6=9!:12'')&(I. @ (e.&'/\')@] })
jpathsep=: '/'&(('\' I.@:= ])})
winpathsep=: '\'&(('/' I.@:= ])})
PATHJSEP_j_=: '/'                 NB. should not used in new codes
IFDEF=: 3 : '0=4!:0<''DEF'',y,''_z_'''

NB. ---------------------------------------------------------
IF64=: 16={:$3!:3[2
IFBE=: 'a'~:{.2 (3!:4) a.i.'a'
'IFUNIX IFWIN IFWINCE'=: 5 6 7 = 9!:12''
IFJHS=: 0
IFWINE=: (0 ~: 'ntdll wine_get_version >+ x'&(15!:0)) ::0:`0:@.IFUNIX ''

NB. ---------------------------------------------------------
if. notdef 'IFIOS' do.
  IFIOS=: 0
end.

NB. ---------------------------------------------------------
if. notdef 'IFJA' do.
  IFJA=: 0
end.

NB. ---------------------------------------------------------
if. notdef 'IFJNET' do.
  IFJNET=: 0
end.

NB. ---------------------------------------------------------
if. notdef 'BINPATH' do.
  BINPATH=: '/j/bin'
end.

NB. ---------------------------------------------------------
if. notdef 'UNAME' do.
  if. IFUNIX do.
    if. -.IFIOS do.
      UNAME=: (2!:0 'uname')-.10{a.
    else.
      UNAME=: 'Darwin'
    end.
  elseif. do.
    UNAME=: 'Win'
  end.
end.

NB. ---------------------------------------------------------
if. notdef 'LIBFILE' do.
  LIBFILE=: BINPATH,'/',IFUNIX{::'j.dll';(UNAME-:'Darwin'){::'libj.so';'libj.dylib'
end.

NB. ---------------------------------------------------------
if. notdef 'FHS' do.
  FHS=: IFUNIX>'/'e.LIBFILE
end.

NB. ---------------------------------------------------------
NB. Linux sporadic problem in non-English locale
'libc.so.6 setlocale > x i *c'&(15!:0) ::0:^:(UNAME-:'Linux') 1;,'C'

NB. ---------------------------------------------------------
if. notdef 'IFRASPI' do.
  if. UNAME -: 'Linux' do.
    cpu=. 2!:0 'cat /proc/cpuinfo'
    IFRASPI=: (1 e. 'BCM2708' E. cpu) +. (1 e. 'BCM2709' E. cpu) +. 1 e. 'BCM2710' E. cpu
  else.
    IFRASPI=: 0
  end.
end.

NB. ---------------------------------------------------------
if. IF64 +. IFIOS do.
  IFWOW64=: 0
else.
  if. IFUNIX do.
    IFWOW64=: '64'-:_2{.(2!:0 (UNAME-:'Android'){::'uname -m';'getprop ro.product.cpu.abi')-.10{a.
  else.
    IFWOW64=: 'AMD64'-:2!:5'PROCESSOR_ARCHITEW6432'
  end.
end.

NB. ---------------------------------------------------------
if. notdef 'IFQT' do.
  IFQT=: 0
  libjqt=: IFUNIX{::'jqt.dll';'libjqt',(UNAME-:'Darwin'){::'.so';'.dylib'
  if. 0 ~: 1!:4 :: 0: < ((BINPATH,'/')&,) libjqt do.
    libjqt=: ((BINPATH,'/')&,) libjqt
  end.
end.

NB. ---------------------------------------------------------
if. UNAME-:'Android' do.
  AndroidLibPath=: '/lib',~ ({.~i:&'/')^:2 BINPATH
end.

assert. IFQT *: IFJA
)

NB. =========================================================
jcwdpath=: jpathsep@(1!:43@(0&$),])@((*@# # '/'"_),])

NB. =========================================================
jsystemdefs=: 3 : 0
xuname=. UNAME
if. 0=4!:0 <f=. y,'_',(tolower xuname),(IF64#'_64'),'_j_' do.
  0!:100 toHOST f~
else.
  0!:0 <jpath '~system/defs/',y,'_',(tolower xuname),(IF64#'_64'),'.ijs'
end.
)
