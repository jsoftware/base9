NB. break
NB.%break.ijs - break utilities
NB.-This script defines break utilities and is included in the J standard library.
NB.-Definitions are loaded into the z locale.
NB.-
NB.-`setbreak 'default'` is done by the profile.
NB.-
NB.-setbreak creates file `~break/Pid.Class` and writes 0 to the first byte.
NB.-
NB.-Pid is the process id and Class is normally 'default'.
NB.-
NB.-setbreak calls 9!:47 with this file.
NB.-
NB.-9!:47 maps the first byte of file, and JE tests this byte for break requests.
NB.-
NB.-Another task writes 1 or 2 to the file for attention/break.
NB.-
NB.-9!:46 returns the filename.
NB.-
NB.-`break` y sets break for JEs with class y.
NB.-
NB.-JEs with the same class all get the break. A non-default class protects JE from the default break.
NB.-
NB.- A new setbreak replaces the old.

NB. =========================================================
NB.*break v break J execution
NB. y is class to signal - '' treated as 'default'
break=: 3 : 0
class=. >(0=#y){y;'default'
p=. 9!:46''
if. '~' = {.q=. jpath '~break/' do.
  q=. (>:p i: '/'){.p
end.
fs=. (<q),each {."1[1!:0<q,'*.',class
fs=. fs-.<p NB. don't break us
for_f. fs do.
  v=. 2<.>:a.i.1!:11 f,<0 1
  (v{a.) 1!:12 f,<0 NB. 12 not 2
end.
i.0 0
)

NB. =========================================================
NB.*setbreak v set break
NB.-Set break
NB. y is class
NB.Creates unique file ~break/Pid.Class
setbreak=: 3 : 0
try.
  p=. jpath '~break/'
  1!:5 ::] <p
  f=. p,(":2!:6''),'.',y
  ({.a.) 1!:12 f;0 NB. 12 not 2
  9!:47 f
  f
catch. '' end.
)
