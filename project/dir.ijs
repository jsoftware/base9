NB. dir

NB. =========================================================
direrase=: 3 : 0
if. 0=#y do. return. end.
if. 0=#1!:0 y do. return. end.
if. 0=#d=. dirtreex y do. return. end.
d=. d \: # &> d
m=. ferase d
if. _1 e. m do.
  'Unable to delete: ',towords (m=_1)#d
end.
)

NB. =========================================================
NB. dirsubdirs
NB. return sub directories in top level directory
NB. ignore any hidden files
dirsubdirs=: 3 : 0
r=. 1!:0 (termsep jpathsep y),'*'
if. 0=#r do. '' return. end.
{."1 r #~ '-d' -:("1) 1 4{"1 > 4{"1 r
)

NB. =========================================================
NB.*dirtreex v get full directory trees
NB. directory search is recursive through subdirectories
NB. argument and results have full pathnames
NB. argument is not in result if it ends in a path separator
dirtreex=: 3 : 0
y=. jpathsep y
p=. (+./\. y = '/') # y
d=. 1!:0 y,('/' = {:y) # '*'
if. 0 = #d do. '' return. end.
a=. > 4 {"1 d
m=. 'd' = 4 {"1 a
f=. (<p) ,each {."1 d
if. 1 e. m do.
  f, ; dirtreex each (m#f) ,each <'/','*'
end.
)
