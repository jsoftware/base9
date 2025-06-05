NB. jade utilities
NB.%jade.ijs - J session utilities
NB.-This script defines J session utilities ((J application development environment)
NB.-and is included in the J standard library.
NB.-
NB.-Definitions are loaded into the j locale with cover functions in z.

cocurrent 'z'

NB. =========================================================
NB.*jpath v convert folder name to full path
NB.-example:
NB.+   jpath '~bin/profile.ijs'
NB.+/home/elmo/j9/bin/profile.ijs
NB.-
NB.-For more information, on folder names see [Folders and Projects](http://code.jsoftware.com/wiki/Guides/Folders%20and%20Projects).
jpath=: jpath_j_

NB. =========================================================
NB.*load v load scripts
NB.-load scripts
NB.-
NB.-Argument is a list of names, as full or relative pathnames, or script shortnames.
NB.-
NB.-example:
NB.+load 'numeric plot'           - load numeric and plot scripts
NB.+load '~system/main/task.ijs'  - load the task script
NB.-
NB.-load calls the utility getscripts_j_ to resolve names, for example:
NB.-
NB.+   >getscripts_j_ 'numeric'
NB.+/home/elmo/j9/addons/general/misc/numeric.ijs
load=: 3 : 0
0 load y
:
fls=. getscripts_j_ y
fn=. ('script',x#'d')~
for_fl. fls do.
  if. Displayload_j_ do. smoutput > fl end.
  if. -. fexist fl do.
    smoutput 'not found: ',>fl
  end.
  fn fl
  Loaded_j_=: ~. Loaded_j_,fl
end.
empty''
)

NB. =========================================================
NB.*loadd v load scripts with display
NB.-load scripts with display
NB.-
NB.-This is the same as load except that the script is displayed
NB.-as it is executed.
loadd=: 1&load

NB. =========================================================
NB.*require v load scripts if not already loaded
NB.-load scripts if not already loaded
require=: 3 : 0
fls=. Loaded_j_ -.~ getscripts_j_ y
if. # fls do. load fls else. empty'' end.
)

NB. =========================================================
NB.*scripts v view script names
NB.-this lists the script shortnames, which are stored in Public_j_.
NB.-
NB.-syntax:
NB.+scripts ''        NB. list names
NB.+scripts 'v'       NB. list names with corresponding scripts
scripts=: scripts_j_

NB. =========================================================
NB.*show v show names using a linear representation
NB.-show names using a linear representation
NB.-
NB.-Useful for a quick summary of definitions.
NB.-syntax:
NB.+show namelist  (e.g. show 'deb edit list')
NB.+show numbers   (from 0 1 2 3=nouns, adverbs etc)
NB.+show ''        (equivalent to show 0 1 2 3)
NB.-
NB.-example:
NB.+   show 'IF*' nl_z_ 0
NB.+IF64=: 1
NB.+IFIOS=: 0
NB.+IFJA=: 0
NB.+...

show=: 3 : 0
y=. y,(0=#y)#0 1 2 3
if. (3!:0 y) e. 2 32 do. y=. cutopen y
else. y=. (4!:1 y) -. (,'y');,'y.' end.
wid=. {.wcsize''
sub=. '.'&(I. @(e.&(9 10 12 13 127 254 255{a.))@]})
j=. '((1<#$t)#(":$t),''$''),":,t'
j=. 'if. L. t=. $.^:_1 ".y do. 5!:5 <y return. end.';j
j=. 'if. 0~:4!:0 <y do. 5!:5 <y return. end.';j
a=. (,&'=: ',sub @ (3 : j)) each y
}: ; ((wid <. #&> a) {.each a) ,each LF
)

NB. =========================================================
NB.*xedit v load file in external editor
NB.-syntax:
NB.+xedit file [ ; row ]   (row is optional and is 0-based)
xedit=: xedit_j_

NB. =========================================================
NB.*wcsize v return size of console, as columns and rows
NB.-example:
NB.+   wcsize''
NB.+79 24
wcsize=: 3 : 0
if. (IFQT+.IFJNET+.IFJHS+.IFIOS+.UNAME-:'Android') < IFUNIX do.
  |.@".@(-.&LF)@(2!:0) :: (Cwh_j_"_) '/bin/stty size 2>/dev/null'
else.
  (Cwh_j_"_)`((0 ". wd) :: (Cwh_j_"_))@.IFQT 'sm get termcwh'
end.
)
