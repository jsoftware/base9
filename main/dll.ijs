NB. utilities for calling DLLs
NB.%dll.ijs - utilities for calling DLLs
NB.-This script defines utilities for calling DLLs and is included in the J standard library.
NB.-Definitions are loaded into the z locale.

cocurrent 'z'

NB. =========================================================
NB.*cd v call DLL procedure
cd=: 15!:0

NB. =========================================================
NB.*memr v memory read
NB.*memw v memory write
NB.*mema v memory allocate
NB.*memf v memory free
NB.*memu v forcecopy
memr=: 15!:1
memw=: 15!:2
mema=: 15!:3
memf=: 15!:4
memu=: '' 1 : 'try. 15!:15 m catch. a: { ] return. end. 15!:15'

NB. =========================================================
NB.*cdf v free DLLs
NB.*cder v error information
NB.*cderx v GetLastError information
cdf=: 15!:5
cder=: 15!:10
cderx=: 15!:11

NB. =========================================================
NB.gh v allocate header
NB.fh v free header
NB.*symget v get address of locale entry for name
NB.*symset v set array as address
NB.*symdat v get address of data for name
NB. 15!:6  - get address of locale entry for name
NB. 15!:7  - set array as address
NB. 15!:8  - allocate header
NB. 15!:9  - free header
NB. 15!:12 - mmblks return 3 col integer matrix
NB. 15!:14 - get address of data for name
NB. 15!:16 - toggle native front end (nfe) state
NB. 15!:17 - return x callback arguments
NB. 15!:18 - return last jsto output
gh=. 15!:8
fh=. 15!:9
symget=: 15!:6
symset=: 15!:7
symdat=: 15!:14

NB.*cdcb v callback address
cdcb=: 15!:13

NB. =========================================================
NB.*JB01 n 1
NB.*JCHAR n 2
NB.*JSTR n _1,JCHAR
NB.*JINT n 4
NB.*JPTR n JINT
NB.*JFL n 8
NB.*JCMPX n 16
NB.*JBOXED n 32
NB.*JSB n 65536
NB.*JCHAR2 n 131072
NB.*JSTR2 n _1,JCHAR2
NB.*JCHAR4 n 262144
NB.*JSTR4 n _1,JCHAR4
NB.*JTYPES n JB01,JCHAR,JINT,JPTR,JFL,JCMPX,JBOXED,JSB,JCHAR2,JCHAR4
NB.*JSIZES n size in bytes of corresponding JTYPES

JB01=: 1
JCHAR=: 2
JSTR=: _1,JCHAR
JINT=: 4
JPTR=: JINT
JFL=: 8
JCMPX=: 16
JBOXED=: 32
JSB=: 65536
JCHAR2=: 131072
JSTR2=: _1,JCHAR2
JCHAR4=: 262144
JSTR4=: _1,JCHAR4
JTYPES=: JB01,JCHAR,JINT,JPTR,JFL,JCMPX,JBOXED,JSB,JCHAR2,JCHAR4
JSIZES=: >IF64{1 1 4 4 8 16 4 4 2 4;1 1 8 8 8 16 8 8 2 4

NB. =========================================================
NB.*ic v integer conversion
NB.-Integer conversion
NB.-e.g.
NB.-    25185 25699  =  _1 ic 'abcd'
NB.-    'abcd'  =  1 ic _1 ic 'abcd'
NB.-    1684234849 1751606885  = _2 ic 'abcdefgh'
NB.-    'abcdefgh'  =  2 ic _2 ic 'abcdefgh'
ic=: 3!:4

NB.*fc v float conversion
fc=: 3!:5

NB.*endian v flip intel bytes (little endian)
endian=: |.^:('a'={.2 ic a.i.'a')

NB.*Endian   v flip powerpc bytes (BIG Endian)
Endian=: |.^:('a'~:{.2 ic a.i.'a')

NB. bitwise operations
NB.*AND  v bitwise AND (&)
NB.*OR   v bitwise OR  (|)
NB.*XOR  v bitwise XOR (^)
AND=: $:/ : (17 b.)
OR=: $:/ : (23 b.)
XOR=: $:/ : (22 b.)
