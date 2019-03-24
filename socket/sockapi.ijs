NB. socket API calls

NB. =========================================================
NB. build adverbs
3 : 0''
select. UNAME
case. 'Win' do.
  c=. >IFWINCE{'wsock32';'winsock'
  ccdm=: 1 : ('(''"',c,,'" '',x)&(15!:0)')
  ncdm=: ccdm
  scdm=: ccdm
  wcdm=: ccdm
  LIB=: ''
  closesocketJ=: 'closesocket i i' scdm
  ioctlsocketJ=: 'ioctlsocket i i i *i' scdm
case. do.
  c=. unxlib 'c'
  ccdm=: 1 : ('(''"',c,'" '',x)&(15!:0)')
  ncdm=: ccdm
  scdm=: ccdm
  wcdm=: 1 : ']'
  LIB=: c
  closesocketJ=: 'close i i' scdm
  ioctlsocketJ=: 'ioctl i i x *i' scdm
end.
empty''
)

NB. ---------------------------------------------------------
gethostbyaddrJ=: 'gethostbyaddr * * i i' ncdm
gethostbynameJ=: 'gethostbyname * *c' ncdm
gethostnameJ=: 'gethostname i *c i' ncdm
inet_addrJ=: 'inet_addr i *c' ncdm
inet_ntoaJ=: 'inet_ntoa i i' ncdm

NB. ---------------------------------------------------------
acceptJ=: 'accept i i * *i' scdm
acceptNullJ=: 'acceptNull i i *c *c' scdm
bindJ=: 'bind i i * i' scdm
connectJ=: 'connect i i * i' scdm
FD_ISSETJ=: 'FD_ISSET i i ' scdm
getpeernameJ=: 'getpeername i i * *i' scdm
getprotobynameJ=: 'getprotobyname i *c' scdm
getprotobynumberJ=: 'getprotobynumber i i' scdm
getservbynameJ=: 'getservbyname i i i' scdm
getservbyportJ=: 'getservbyport i i i' scdm
getsocknameJ=: 'getsockname i i * *i' scdm
getsockoptJ=: 'getsockopt i i i i *i *i' scdm
htonlJ=: 'htonl i i' scdm
htonsJ=: 'htons s s' scdm
listenJ=: 'listen i i i' scdm
ntohlJ=: 'ntohl i i' scdm
ntohsJ=: 'ntohs s s' scdm
recvJ=: 'recv i i * i i' scdm
recvfromJ=: 'recvfrom i i *c i i * *i' scdm
selectJ=: 'select i i * * * *' ccdm
sendJ=: 'send i i *c i i' scdm
sendtoJ=: 'sendto i i *c i i * i' scdm
setsockoptJ=: 'setsockopt i i i i *i i' scdm
shutdownJ=: 'shutdown i i i' scdm
socketJ=: 'socket i i i i' scdm

WSAAsyncGetHostByAddrJ=: 'WSAAsyncGetHostByAddr i i i i i i i i' wcdm
WSAAsyncGetHostByNameJ=: 'WSAAsyncGetHostByName i i i *c i i' wcdm
WSAAsyncGetProtoByNameJ=: 'WSAAsyncGetProtoByName i i i *c i i' wcdm
WSAAsyncGetProtoByNumberJ=: 'WSAAsyncGetProtoByNumber i i i i i i' wcdm
WSAAsyncGetServByNameJ=: 'WSAAsyncGetServByName i i i *c *c i i' wcdm
WSAAsyncGetServByPortJ=: 'WSAAsyncGetServByPort i i i i *c i i' wcdm
WSAAsyncSelectJ=: 'WSAAsyncSelect i i i i i' wcdm
WSACancelAsyncRequestJ=: 'WSACancelAsyncRequest i i' wcdm
WSACancelBlockingCallJ=: 'WSACancelBlockingCall i ' wcdm
WSACleanupJ=: 'WSACleanup i ' wcdm
WSAGetLastErrorJ=: 'WSAGetLastError i ' wcdm
WSAIsBlockingJ=: 'WSAIsBlocking i ' wcdm
WSASetBlockingHookJ=: 'WSASetBlockingHook i i' wcdm
WSASetLastErrorJ=: 'WSASetLastError i i' wcdm
WSAStartupJ=: 'WSAStartup i i *' wcdm
WSAStringToAddressJ=: 'WSAStringToAddress i c i i i i' wcdm
WSAUnhookBlockingHookJ=: 'WSAUnhookBlockingHook i ' wcdm
x_WSAFDIsSetJ=: 'x_WSAFDIsSet i i i' wcdm
