NB. util

res=: >@:{.
taketo=: [: ] (E. i. 1:) {. ]
deb=: #~ (+. (1: |. (> </\)))@(' '&~:)

NB. =========================================================
NB. fdset_bytes		compute the fds_bits byte array marking from a vector
NB.			with file descriptors to be marked.
NB.
NB. Output is a character (byte) vector.  The length of this result
NB. vector is given by x and must be
NB. - a multiple of the word size (4).
NB. - large enough to accomodate all elements
NB. - not larger than FD_SETSIZE/8
NB. The monad defaults x to the smallest such value.
NB.
NB. y is a list of the interesting file descriptors ("small ints").

fdset_bytes=: 3 : 0
max=. >./ y
'cannot represent fds within FD_SETSIZE limit' assert max<FD_SETSIZE
len=. 4 * <. 32 %~ max+31
len fdset_bytes y
:
len=. x
fds=. y
bitvector=. 1 fds} (len*8)#0
bytes=. a. {~ _8 #.@|.\ bitvector
NB. Dependending on the platform endiness, the bytes within the words
NB. need to be reversed:
if. -. 1 0 0 0 -: a. i. 2 ic 1 do.
  bytes=. , _4 |.\ bytes
end.
bytes
)

NB. =========================================================
NB. fdset_fds	compute the list of file descriptors from
NB.		the fd_set byte array representation.
NB. Input y is the byte array (as for example, filled by select(2)).
fdset_fds=: 3 : 0
bytes=. y
NB. Dependending on the platform endiness, the bytes within the words
NB. need to be reversed:
if. -. 1 0 0 0 -: a. i. 2 ic 1 do.
  bytes=. , _4 |.\ bytes
end.
bitvec=. , _8 |.\ , (8#2)&#: a. i. bytes
fds=. I. bitvec
)
