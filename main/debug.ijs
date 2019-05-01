NB. debug utilities
NB.%debug.ijs - debug utilities
NB.-This script defines debug utilities and is included in the J standard library.
NB.-Definitions are loaded into the z locale.
NB.
NB. e.g.  dbss 'f 0'   monadic line 0
NB.       dbss 'f :2'  dyadic line 2
NB.       dbss 'f *:*' all lines
NB.
NB. The call stack (dbstk'') is a 9-column boxed matrix:
NB.   0  name
NB.   1  error number, or 0 if this call has no error.
NB.   2  line number
NB.   3  name class
NB.   4  definition
NB.   5  source script
NB.   6  argument list
NB.   7  locals
NB.   8  suspense

cocurrent 'z'

NB.*dbr v reset, set suspension mode (0=disable, 1=enable)
NB.*dbs v display stack
NB.*dbsq v stop query
NB.*dbss v stop set
NB.*dbrun v run again (from current stop)
NB.*dbnxt v run next (skip line and run)
NB.*dbret v exit and return argument
NB.*dbjmp v jump to line number
NB.*dbsig v signal error
NB.*dbrr v re-run with specified arguments
NB.*dbrrx v re-run with specified executed arguments
NB.*dberr v last error number
NB.*dberm v last error message
NB.*dbstk v call stack
NB.*dblxq v latent expression query
NB.*dblxs v latent expression set
NB.*dbtrace v trace control
NB.*dbq v queries suspension mode (set by dbr)
NB.*dbst v returns stack text

dbr=: 13!:0
dbs=: 13!:1
dbsq=: 13!:2
dbss=: 13!:3
dbrun=: 13!:4
dbnxt=: 13!:5
dbret=: 13!:6
dbjmp=: 13!:7
dbsig=: 13!:8
dbrr=: 13!:9
dbrrx=: 13!:10
dberr=: 13!:11
dberm=: 13!:12
dbstk=: 13!:13
dblxq=: 13!:14
dblxs=: 13!:15
dbtrace=: 13!:16
dbq=: 13!:17
dbst=: 13!:18
NB. these 4 verbs are subject to change without notice
dbcut=: 13!:19
dbover=: 13!:20
dbinto=: 13!:21
dbout=: 13!:22

NB. =========================================================
NB. utilities:
NB. dbctx       display context
NB. dbg         turn debug window on/off
NB. dblocals    display local names on stack
NB. dbstack     display stack
NB. dbstop      add stop definitions
NB. dbstops     set all stop definitions
NB. dbstopme    stop current definition
NB. dbstopnext  stop current definition at next line
NB. dbview      view stack

NB. =========================================================
NB.*dbctx v display context as character matrix
NB.-Display context as character matrix
NB.- y is ignored
NB.-x is the number of lines before and after the current stop
NB.      default to 10 10
dbctx=: 10 10&$: : (4 : 0)
if. -.13!:17'' do. 0 0$'' return. end.
NB. avoid possible argument error
try.
  'before after'=. 2{. <. , x, 10 10
catch.
  'before after'=. 10 10
end.
if. 0= #d=. 13!:13'' do. 0 0$'' return. end.
if. '*' -.@e. sus=. >{:"1 d do. 0 0$'' return. end.
'name ln nc def src'=. 0 2 3 4 5{(sus i. '*'){d
dyad=. {: ':'&e.;._2 ] 13!:12''
if. (_2{.def) -: LF,')' do.
  def=. }.def [ def0=. {.def=. }:<;._2 def,LF
else.
  def=. ,<def [ def0=: ''
end.
if. def e.~ <,':' do.
  if. dyad do.
    def=. def}.~ >: def i. <,':'
  else.
    def=. def{.~ def i. <,':'
  end.
end.
min=. 0>.ln-before [ max=. (<:#def)<.ln+after
ctx=. ((,.ln=range){' >'),"1 '[',"1 (":,.range) ,"1 ('] ') ,"1 >def{~range=. min + i. >:max-min
> (<'@@ ', name, '[', (dyad#':'), (":ln) ,'] *', (nc{' acv'),' @@ ', src), def0, <"1 ctx
)

NB. =========================================================
NB.*dbg v turn debugging window on/off
dbg=: 3 : 0
if. -.IFQT do.
  13!:0 y return.
end.
if. y do.
  if. _1 = 4!:0 <'jdb_open_jdebug_' do.
    0!:0 <jpath '~addons/ide/qt/debugs.ijs'
  end.
  jdb_open_jdebug_''
  13!:0 [ 1
else.
  jdb_close_jdebug_ :: ] ''
  13!:15 ''
  13!:0 [ 0
end.
)

NB. =========================================================
NB.*dblocals v display names and locals on stack
NB.-syntax:
NB.+[namelist] dblocals stack_indices
NB.-If indices is empty, defaults to all
NB.-example:
NB.+ dblocals ''            NB. display all local names in stack
NB.+'abc Z' dblocals i.5    NB. display names abc and Z where found in first 5 definitions on stack
dblocals=: _1&$: : (4 : 0)
stk=. }. 13!:13''
if. 0=#y do. y=. a: else. y=. (y e. i.#stk) # y end.
loc=. (<y ; 0 7) { stk
if. -. x-:_1 do.
  t=. ;: ::] x
  f=. ({."1 e. t"_) # ]
  ({."1 loc) ,. f &.> {:"1 loc
end.
)

NB. =========================================================
NB.*dbstack v displays call stack with header
NB.+Displays call stack with header
NB.-Ignores definition and source script (default)
NB.-
NB.-y is the number of lines to display, all if empty
NB.-or a name on the stack
NB.-
NB.-limits display to screenwidth
dbstack=: 3 : 0
hdr=. ;:'name en ln nc args locals susp'
stk=. }. 13!:13''
if. #y do.
  if. 2=3!:0 y do.
    stk=. stk #~ (<y)={."1 stk
  else.
    stk=. ((#stk)<.,y){.stk
  end.
end.
stk=. 1 1 1 1 0 0 1 1 1 #"1 stk
stk=. hdr, ": &.> stk
wds=. ({:@$@":@,.)"1 |: stk
len=. 20 >.<.-:({.wcsize'') - +/8, 4 {. wds
tc=. (len+1)&<.@$ {.!.'.' ({.~ len&<.@$)
tc@": each stk
)

NB. =========================================================
NB.*dbstop v set stops on all lines in namelist
NB.-Set stops on all lines in namelist
NB.-
NB.-Adds to current set of stops.
dbstop=: 3 : 0
if. 0 e. #y -. ' ' do. 13!:3'' return. end.
t=. 13!:2''
if. #t do. t=. <;._2 t, ';' -. {:t end.
t=. ~. t, (;: ^: (L.=0:) y) ,&.> <' *:*'
13!:3 ; t ,&.> ';'
)

NB. =========================================================
NB.*dbstops v set stops on all lines in namelist
NB.-Set stops on all lines in namelist
NB.-
NB.-Replaces current set of stops
dbstops=: 3 : 0
13!:3 ; (;: ^: (L.=0:) y) ,&.> <' *:*;'
)

NB. =========================================================
NB.*dbstopme v set stops on current definition if y
NB.-Set stops on current definition if y.
NB.-
NB.-Does nothing if suspension is off.
dbstopme=: 3 : 0
if. y do.
  if. 0 e. $c=. }. 13!:13'' do. return. end.
  c=. (> {. {. c), ' *:*'
  t=. 13!:2''
  if. #t do. t=. <;._2 t, ';' -. {:t end.
  t=. ~. t, <c
  13!:3 }: ; t ,&.> ';'
end.
)

NB. =========================================================
NB.*dbstopnext v set stop on next line of current definition if y
NB.-Set stop on next line of current definition if y.
NB.-
NB.-Does nothing if suspension is off.
dbstopnext=: 3 : 0
if. y do.
  if. 0 e. $c=. }. 13!:13'' do. return. end.
  'd n a'=. 0 2 6 { {. c
  c=. d,' ',(':'#~2=#a),":n+1
  t=. 13!:2''
  if. #t do. t=. <;._2 t, ';' -. {:t end.
  t=. ~. t, <c
  13!:3 }: ; t ,&.> ';'
end.
)

NB. =========================================================
NB.*dbview v view stack
dbview=: 3 : 0
if. -.IFQT do. return. end.
if. _1 = 4!:0 <'jdbview_jdbview_' do.
  'require'~'~addons/ide/qt/dbview.ijs'
end.
jdbview_jdbview_ }. 13!:13''
)

NB. =========================================================
NB.*dbhelp n display help message
dbhelp=: 0 : 0
The call stack (dbstk'') is a 9-column boxed matrix:
  0  name
  1  error number, or 0 if this call has no error.
  2  line number
  3  name class
  4  definition
  5  source script
  6  argument list
  7  locals
  8  suspense

f is the name of a verb
      dbss 'f 0'   monadic line 0
      dbss 'f :2'  dyadic line 2
      dbss 'f *:*' all lines

dbr     13!:0  reset, set suspension mode (0=disable, 1=enable)
dbs     13!:1  display stack
dbsq    13!:2  stop query
dbss    13!:3  stop set
dbrun   13!:4  run again (from current stop)
dbnxt   13!:5  run next (skip line and run)
dbret   13!:6  exit and return argument
dbjmp   13!:7  jump to line number
dbsig   13!:8  signal error
dbrr    13!:9  re-run with specified arguments
dbrrx   13!:10 re-run with specified executed arguments
dberr   13!:11 last error number
dberm   13!:12 last error message
dbstk   13!:13 call stack
dblxq   13!:14 latent expression query
dblxs   13!:15 latent expression set
dbtrace 13!:16 trace control
dbq     13!:17 queries suspension mode (set by dbr)
dbst    13!:18 returns stack text
(these 4 verbs are subject to change without notice)
dbcut   13!:19 cut back
dbover  13!:20 step over (13!:20'' or moveline 13!:20'')
dbinto  13!:21 step into ...
dbout   13!:22 step out  ...
(utilities)
dbctx       display context
dbg         turn debug window on/off
dblocals    display local names on stack
dbstack     display stack
dbstop      add stop definitions
dbstops     set all stop definitions
dbstopme    stop current definition
dbstopnext  stop current definition at next line
dbview      (GUI only) view stack
)
