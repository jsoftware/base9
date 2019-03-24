
0 : 0
     sdsocket        family, type, protocol         create new socket
     sdrecv          socket, count, flags           read socket
data sdsend          socket, flags                  send data
     sdrecvfrom      socket, count, flags           read SOCK_DGRAM socket
data sdsendto        socket, flags, family, address, port    send SOCK_DGRAM socket
     sdclose         socket                         close a socket.
     sdconnect       socket, family, address, port  connect the socket to another socket
     sdbind          socket, family, address, port  bind a socket to an address
     sdlisten        socket, number                 set the socket to listen for connections
     sdaccept        socket                         accept new socket
     sdselect        read, write, error, timeout
     sdgetsockopt    socket, option_level, option_name            returns socket option
     sdsetsockopt    socket, option_level, option_name, value...  set socket option
     sdioctl         socket, option, value          read or write socket control information
     sdgethostname   geturns host name.
     sdgetpeername   socket                         get address of socket this socket is connected to.
     sdgetsockname   socket                         get address of this socket.
     sdgethostbyname name                           get an address from a name.
     sdgethostbyaddr AF_INET, address_name          get a name from an address.
     sdgetsockets                                   get result code and all socket numbers.
     sdasync         socket                         set asynchronous socket
     sdcleanup                                      close all sockets and reset
     sdcheck         returncode;result              check return code for errors
     sderror         returncode                     get error message from error number
)
