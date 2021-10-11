NB. socket z definitions

nms=. <;._2 (0 : 0)
sdsocket
sdrecv
sdsend
sdrecvfrom
sdsendto
sdclose
sdconnect
sdbind
sdlisten
sdaccept
sdselect
sdgetsockopt
sdsetsockopt
sdioctl
sdionread
sdgethostname
sdgetpeername
sdgetsockname
sdgethostbyname
sdgethostbyaddr
sdgetsockets
sdasync
sdcleanup
sdcheck
sderror
)

". > nms ,each (<'_z_=:') ,each nms ,each <'_jsocket_'
