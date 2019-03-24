
tostring=: 3 : 0
}: ;'.',~each ":each a.i.y
)

data2string=: 3 : 0
tostring 4{.4}.2{::y
)

namesub=: 3 : 0
if. 0~:res y do. (sdsockerror'');0;'';0 return. end.
0;AF_INET;(data2string y);256#.a.i.2 3{2{::y
)

flip=: 'a'={.2 ic a.i.'a'
bigendian=: |.^:flip NB. to flip or not to flip
hns=: 3 : 'a.{~256 256#:y'          NB. y to short NBO chars
hs=: 3 : 'bigendian a.{~256 256#:y' NB. y to short chars
res=: >@:{.

sockaddr_in=: 3 : 0
's fam host port'=. y
assert. fam=AF_INET
if. 0=#host do. host=. '0.0.0.0' end.
(hs AF_INET),(hns port),(afroms host),8#{.a.
)

sockaddr_split=: 3 : 0
'fam port host'=. 1 0 1 0 1 0 0 0 <;.1 (8){.y
assert. AF_INET = 256 256 #. a. i. bigendian fam
port=. 256 256 #. a. i. port
host=. }. , sfroma "0 host
host;port
)

sfroma=: 3 : 0
'.',": a. i. y
)

NB. binary address from dot form
afroms=: 3 : 0
a.{~4{.".each '.' cutopen y
)

NB. 0 or error code from result
rc0=: 3 : 0
if. 0=>{.y do. 0 else. sdsockerror'' end.
)


NB. =========================================================
NB.*sdsockaddress v returns address
NB. y active socket
sdsockaddress=: 3 : 0"0
r=. getsocknameJ y;(sockaddr_in_sz#{.a.);,sockaddr_in_sz
(rc0 r);data2string r
)

NB. =========================================================
NB.*sdsend v send data
NB. y- socket; indicator specifying the way in which the call is made (0)
NB. x- data
sdsend=: 4 : 0"1
if. '' -: $x do. x=. ,x end.
r=. >{.sendJ (>0{y);x;(#x);>1{y
if. _1=r do. 0;~sdsockerror'' else. 0;r end.
)

NB. =========================================================
NB.*sdsendto v send data
NB. y- socket ; flags ; family ; address ; port
NB. x- data
sdsendto=: 4 : 0"1
if. 3 = #y do.
  's flags saddr'=. y
  r=. >{.sendtoJ s;x;(#x);flags;saddr;sockaddr_in_sz
else.
  's flags family address port'=. y
  r=. >{.sendtoJ s;x;(#x);flags;(sockaddr_in 0 2 3 4{y);sockaddr_in_sz
end.
if. _1=r do. 0;~sdsockerror'' else. 0;r end.
)


NB. =========================================================
NB.*sdcleanup v close all sockets
sdcleanup=: 3 : '0[(sdclose ::0:@] shutdownJ@(;&2)"0)^:(*@#) SOCKETS_jsocket_'

NB. =========================================================
NB.*sdinit v initialize
sdinit=: 3 : 0
if. 0=nc<'SOCKETS_jsocket_' do. 0 return. end.
SOCKETS_jsocket_=: ''
if. IFUNIX do. 0 return. end.
NB. 257 is version 1.1
if. 0~:res WSAStartupJ 257;1000$' ' do. _1[sminfo'Socket Error' else. 0 end.
)

NB. =========================================================
NB.*sdrecv v read data
NB. y- socket,data_size, indicator specifying the way in which the call is made (0)
sdrecv=: 3 : 0"1
's size'=. 2{.y
r=. recvJ s;(size#' ');size;2{3{.y
if. 0>c=. res r do. '';~sdsockerror'' return. end.
0;c{.>2{r
)

NB. NB. =========================================================
NB. NB.*sdrecvfrom v read data from
NB. NB. y- socket, data_size, indicator specifying the way in which the call is made (0)
NB. sdrecvfrom=: 3 : 0"1
NB. 's size flags'=. 3 {. y ,<0
NB. r=. recvfromJ s;(size#' ');size;flags;(sockaddr_in_sz#{.a.);,sockaddr_in_sz
NB. 'unexpected size of peer address' assert sockaddr_in_sz = 6 pick r
NB. if. 0>c=. res r do. (sdsockerror '');'';'' return. end.
NB. 0;(c{.>2{r);data2string 3}.r
NB. )

NB. ======== LML mods =================================================
NB.*sdrecvfrom v read data from
NB. y- socket, data_size, indicator specifying the way in which the call is made (0)
sdrecvfrom=: 3 : 0"1
's size flags'=. 3 {. y ,<0
s=. {.s
r=. recvfromJ s;(size#' ');size;flags;(sockaddr_in_sz#{.a.);,sockaddr_in_sz
'unexpected size of peer address' assert sockaddr_in_sz = 6 pick r
if. 0>c=. res r do. (sdsockerror '');'';'' return. end.
0;(c{.>2{r); 5{r
)

NB. =========================================================
NB.*sdconnect v connect to the socket
NB. y - socket , family , address , port
sdconnect=: 3 : 0"1
rc0 connectJ (>{.y);(sockaddr_in y);sockaddr_in_sz
)

NB. =========================================================
NB.*sdsocket v creates a socket
sdsocket=: 3 : 0"1
s=. res socketJ <"0 [3{.y,(0=#y)#PF_INET,SOCK_STREAM,IPPROTO_TCP
if. s=_1 do. 0;~sdsockerror'' return. end.
SOCKETS_jsocket_=: SOCKETS_jsocket_,s
0;s
)

NB. =========================================================
NB.*sdbind v bind socket
NB. y - socket , family , address , port
NB. family must be AF_INET
NB. address of '' is '0.0.0.0' (INADDR_ANY)
sdbind=: 3 : 0"1
rc0 bindJ (>{.y);(sockaddr_in y);sockaddr_in_sz
)

NB. =========================================================
NB.*sdasync v set up async connection for the socket
sdasync=: 3 : 0"0
if. IFUNIX do. 'not implemented under Unix - please use sdselect' assert 0 end.
flags=. OR/ FD_READ,FD_WRITE,FD_OOB,FD_ACCEPT,FD_CONNECT,FD_CLOSE
hwnd=. ".wd'qhwndx'
if. >{.WSAAsyncSelectJ ({.y);hwnd;1026;flags do. sdsockerror '' else. 0 end.
)

NB. =========================================================
NB.*sdlisten v set up listener for the socket
NB. y - socket;queue_length
NB. SOMAXCONN - The maximum length of the queue of pending connections
sdlisten=: 3 : 0"1
rc0 listenJ ;/2 {. y,<^:(L.y) SOMAXCONN
)

NB. =========================================================
NB.*sdaccept v accept connection
NB. y - socket
sdaccept=: 3 : 0"0
if. _1~:s=. res r=. acceptJ y;(sockaddr_in_sz$' ');,sockaddr_in_sz do.
  SOCKETS_jsocket_=: SOCKETS_jsocket_,s
  0;s
else. 0;~sdsockerror '' end.
)

NB. =========================================================
NB.*sdgethostbyname v returns an address from a name
NB. y - host name
sdgethostbyname=: 3 : 0
if. 0~:hostent=. res gethostbynameJ <y do.
  addr_list=. memr hostent, h_addr_list_off, 1, JPTR
  first_addr=. memr addr_list, 0, 1, JPTR
  'name did not resolve to address' assert first_addr ~: 0
  addr=. tostring memr first_addr,0,4
else.
  addr=. '255.255.255.255'
end.
0;PF_INET;addr
)

NB. =========================================================
NB.*sdgethostbyaddr v returns a name from an address
NB. y - AF_INET;host ip address
sdgethostbyaddr=: 3 : 0"1
'fam addr'=. y
phe=. res gethostbyaddrJ (afroms addr);4;fam
if. phe=0 do. _1;'unknown host' return. end.
a=. memr phe,h_name_off,1,JPTR
0;memr a,0,JSTR
)

NB. =========================================================
NB.*sdclose v close socket
NB. y - socket
sdclose=: 3 : 0"0
if. 0=res closesocketJ <y do.
  0[SOCKETS_jsocket_=: SOCKETS_jsocket_-.y
else.
  sdsockerror ''
end.
)

NB. =========================================================
NB. fdset_bytes		compute byte array marking file descriptors
NB. output is a character(byte) vector
NB. x is result length
NB. y is a list of descriptors ("small ints").
fdset_bytes=: 4 : 0
bitvector=. 1 y} (x*8)#0
bytes=. a. {~ _8 #.@|.\ bitvector
NB. endiness, reverse bytes
if. -.flip do. bytes=. , _4 |.\ bytes end. NB. IF64 ?? _8
bytes
)

NB. =========================================================
NB. fdset_fds	compute file descriptors from the byte array
NB. y is the byte array
fdset_fds=: 3 : 0
bytes=. y
NB. endiness, reverse bytes
if. -.flip do. bytes=. , _4 |.\ bytes end.
bitvec=. , _8 |.\ , (8#2)&#: a. i. bytes
I. bitvec
)

NB. =========================================================
NB.*sdselect v find sockets that need work
NB. if no arguments given, look at all sockets
NB. convert millisecond timeout to seconds/microseconds
sdselect=: 3 : 0
if. 0=#y do. y=. SOCKETS_jsocket_;SOCKETS_jsocket_;SOCKETS_jsocket_;0 end.
'r w e t'=. y
time=. <<.1000000 1000000#:1000*t
NB. windows fdset is count,sockets and unix is bit vector
if. IFUNIX do.
  max1=. >:>./r,w,e,0
  m=. 4  NB. IF64 ?? 8
  n=. 32 NB. IF64 ?? 64
  bytes=. m*>:<.n%~max1
  r=. bytes fdset_bytes r
  w=. bytes fdset_bytes w
  e=. bytes fdset_bytes e
  rwe=. r;w;e
else.
  max1=. 0
  rwe=. (] ,~ #) each r;w;e
end.
if. _1=res q=. selectJ (<max1),rwe,time do.
  (sdsockerror '');($0);($0);($0)
else.
  if. IFUNIX do. rwe=. fdset_fds each 2 3 4{q else. rwe=. ({.{.}.)each 2 3 4{q end.
  (<0),rwe
end.
)

NB. =========================================================
NB. returns the value of a socket option
sdgetsockopt=: 3 : 0
's lev name'=. y
r=. getsockoptJ s;lev;name;(,_1);,4
if. 0~:res r do. 0;~sdsockerror'' return. end.
d=. ''$>4{r
if. name-:SO_LINGER do. 0;65536 65536#:d else. 0;d end.
)

NB. =========================================================
NB.*sdsetsockopt v sets the int value of a socket option.
sdsetsockopt=: 3 : 0
's lev name val'=. y
if. name -: SO_LINGER do. val=. 65536 65536#.val end.
rc0 setsockoptJ s;lev;name;(,val);4
)

NB. =========================================================
NB.*sdsockerror v retrieve socket error code
sdsockerror=: 3 : 0
> {. cderx ''
)

NB. =========================================================
NB.*sdioctl v read or write socket control information
sdioctl=: 3 : 0
's option value'=. y
r=. ioctlsocketJ s;option;,value
if. 0~:res r do. 0;~sdsockerror'' else. 0;''$>3{r end.
)

NB. =========================================================
NB.*sdionread v get number of bytes available for reading socket
sdionread=: 3 : 0
''$>{.sdcheck sdioctl y,FIONREAD,0
)

NB. =========================================================
NB.*sdgethostname v returns host name
sdgethostname=: 3 : 0
if. 0=res r=. gethostnameJ (256#' ');256 do.
  0;>{.1 take (0{a.)cutopen ;1{r
else.
  0;'unknown host'
end.
)

NB. =========================================================
NB.*sdgetpeername v returns address this socket is connected to
NB. y active socket
sdgetpeername=: 3 : 0"0
namesub getpeernameJ y;(sockaddr_in_sz#{.a.);,sockaddr_in_sz
)

NB. =========================================================
NB.*sdgetsockname v returns address of this socket
NB. y active socket
sdgetsockname=: 3 : 0"0
namesub getsocknameJ y;(sockaddr_in_sz#{.a.);,sockaddr_in_sz
)


NB. =========================================================
NB.*sdgetsockets v returns all socket numbers
sdgetsockets=: 3 : '0;SOCKETS_jsocket_'

NB. =========================================================
NB.*sdcheck v check socket for errors
NB. socket utilities
sdcheck=: }. ` (sderror 13!:8 3:) @. (0 ~: >@{.)
