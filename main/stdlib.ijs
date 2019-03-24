NB.-standard library
NB.%stdlib.ijs - core utilities
NB.-This script defines core utilities for the J standard library.
NB.-Definitions are loaded into the z locale.

18!:4 <'z'

NB. =========================================================
NB.*TAB n tab character
NB.*LF n linefeed character
NB.*LF2 n LF,LF pair
NB.*FF n formfeed character
NB.*CR n carriage return character
NB.*CRLF n CR,LF pair
NB.*DEL n ascii 127 character
NB.*EAV n ascii 255 character
NB.*EMPTY n empty matrix (i.0 0)
NB.*noun n integer 0
NB.*adverb n integer 1
NB.*conjunction n integer 2
NB.*verb n integer 3
NB.*monad n integer 3
NB.*dyad n integer 4
NB.*Debug n debug flag, initialized to 0
'TAB LF FF CR DEL EAV'=: 9 10 12 13 127 255{a.
LF2=: LF,LF
CRLF=: CR,LF
EMPTY=: i.0 0
Debug=: 0
'noun adverb conjunction verb monad dyad'=: 0 1 2 3 3 4

NB. =========================================================
NB.*setalpha v set alpha channel
setalpha=: 16bff&$: : (4 : 0)
((_32&(34 b.))^:IF64 _8 (32 b.) x)&(23 b.) 16bffffff (17 b.) y
)

NB. =========================================================
NB.*getalpha v get alpha channel
getalpha=: 16bff (17 b.) _24&(34 b.)

NB. =========================================================
NB.*abspath v absolute file system path name
abspath=: 3 : 0
if. (1 e. '://'&E.) y=. ,jpathsep y do. y return. end.
if. IFWIN do.
  assert. 0<rc=. >@{. cdrc=. 'kernel32 GetFullPathNameW   i *w i *w *w'&cd (uucp y);((#;])1024$u:' '),<<0
  y=. jpathsep utf8 rc{.3{::cdrc
elseif. ('/' ~: {.) y do.
  y=. iospath^:IFIOS (1!:43'') , '/' , utf8 y
end.
y
)

NB. =========================================================
NB.*apply v apply verb x to y
apply=: 128!:2

NB. =========================================================
NB.*assert v assert value is true
NB.-assertion failure if  0 e. y
NB.-e.g. 'invalid age' assert 0 <: age
assert=: 0 0 $ 13!:8^:((0 e. ])`(12"_))

NB. =========================================================
NB.*bind c binds argument to a monadic verb
NB.-binds monadic verb to an argument creating a new verb
NB.-that ignores its argument.
NB.-e.g.  fini=: sminfo bind 'finished...'
bind=: 2 : 'x@(y"_)'

NB. =========================================================
NB.*boxopen v box argument if open
NB.-Box argument if open.
NB.- e.g. if script=: 0!:0 @ boxopen, then either
NB.-   script 'work.ijs'  or  script <'work.ijs'
NB.-
NB.-See also [boxxopen](#boxxopen).
NB.-
NB.-Use [cutopen](#cutopen) to allow multiple arguments.
boxopen=: <^:(L.=0:)

NB. =========================================================
NB.*boxxopen v box argument if open and not empty
NB.-Box argument if open and not empty.
NB.-
NB.-See also [boxopen](#boxopen).
boxxopen=: <^:(L.<*@#)

NB. =========================================================
NB.*bx v indices of 1's in boolean (same as I.)
bx=: I.

NB. =========================================================
NB.*clear v clear all names in locale
NB.-Clear all names in locale, returns any names not erased.
NB.-example:
NB.+clear 'myloc'
clear=: 3 : 0
". 'do_',(' '-.~y),'_ '' (#~ -.@(4!:55)) (4!:1) 0 1 2 3'''
)

NB. =========================================================
NB.*cutLF v cut text on LF, removing empties
cutLF=: 3 : 'if. L. y do. y else. a: -.~ <;._2 y,LF end.'

NB. =========================================================
NB.*cutopen v cut argument if open
NB.-Cut argument if open.
NB.-This allows an open argument to be given where a boxed list is required.
NB.-
NB.-Most common situations are handled. it is similar to boxopen, except
NB.-allowing multiple arguments in the character string.
NB.-
NB.- x is optional delimiters, default LF if in y, else blank
NB.- y is boxed or an open character array.
NB.-
NB.- if y is boxed it is returned unchanged, otherwise:
NB.- if y has rank 2 or more, the boxed major cells are returned
NB.- if y has rank 0 or 1, it is cut on delimiters in given in x, or
NB.-   if x not given, LF if in y else blank. Empty items are deleted.
NB.-
NB.- e.g. if script=: 0!:0 @ cutopen, then
NB.+   script 'work.ijs util.ijs'
cutopen=: 3 : 0
y cutopen~ (' ',LF) {~ LF e. ,y
:
if. L. y do. y return. end.
if. 1 < #$y do. <"_1 y return. end.
(<'') -.~ (y e.x) <;._2 y=. y,1{.x
)

NB. =========================================================
NB.*datatype v noun datatype
NB.-unicode/unicode4 are literal2/literal4 in J dictionary
datatype=: 3 : 0
n=. 1 2 4 8 16 32 64 128 1024 2048 4096 8192 16384 32768 65536 131072 262144
t=. '/boolean/literal/integer/floating/complex/boxed/extended/rational'
t=. t,'/sparse boolean/sparse literal/sparse integer/sparse floating'
t=. t,'/sparse complex/sparse boxed/symbol/unicode/unicode4'
(n i. 3!:0 y) pick <;._1 t
)

NB. =========================================================
NB.*def c : (explicit definition)
def=: :

NB. =========================================================
NB.*define a : 0 (explicit definition script form)
define=: : 0

NB. =========================================================
NB.*dfh v decimal from hex
NB.*hfd v hex from decimal
H=. '0123456789ABCDEF'
h=. '0123456789abcdef'
dfh=: 16 #. 16 | (H,h) i. ]
hfd=: h {~ 16 #.^:_1 ]
4!:55 'H';'h'

NB. =========================================================
NB.*do v name for ".
do=: ".

NB. =========================================================
NB.*drop v name for }.
drop=: }.

NB. =========================================================
NB.*each a each (&.>)
each=: &.>

NB. =========================================================
NB.*empty v return empty result (i.0 0)
empty=: EMPTY"_

NB. =========================================================
NB.*erase v erase namelist
erase=: [: 4!:55 ;: ::]

NB. =========================================================
NB.*every a every (&>)
every=: &>

NB. =========================================================
NB.*evtloop v initialize event loop
evtloop=: EMPTY"_

NB. =========================================================
NB.*exit v name for 2!:55 (exit)
exit=: 2!:55

NB. =========================================================
NB.*expand v boolean expand
NB.-form: boolean expand data
expand=: #^:_1

NB. =========================================================
NB.*file2url v convert to file:// format
file2url=: 3 : 0
if. (1 e. '://'&E.) ,y do. y return. end.
y=. (' ';'%20') stringreplace abspath y -. '"'
if. IFWIN do.
  if. '//'-:2{.y do.
    'file:',y
  else.
    'file:///',y
  end.
else.
  'file://',y
end.
)

NB. =========================================================
NB.*fixdotdot v fix up a/b/c/d/../../e/../f to a/b/f
fixdotdot=: 3 : 0
while. 1 e. r=. '../' E. y do.
  y=. ((2+p)}.y),~ ({.~ i:&'/') }: (p=. {.I.r){.y
end.
y
)

NB. =========================================================
NB.*fliprgb v flip between argb and abgr byte order
fliprgb=: 3 : 0
s=. $y
d=. ((#y),4)$2 (3!:4) y=. <.,y
d=. 2 1 0 3{"1 d
s$_2(3!:4),d
)

NB. =========================================================
NB.*getargs v get args
NB. getargs was written by Joey K Tuttle
getargs=: 3 : 0
ARGV getargs y
:
argb=. (]`(([: < 1: {. }.) , [: < 2: }. ])@.('-'"_ = {.))&.> x
NB.-The above boxes parms (elements starting with "-" returning name;value
parm=. 32 = ;(3!:0)&.> argb
((-. parm)#argb);(>parm#argb);(". (0 = isatty 0)#'stdin ''''')
)

NB. =========================================================
NB.*getenv v cover for get environment variable, 2!:5
getenv=: 2!:5

NB. =========================================================
NB.*inv a inverse (^:_1)
NB.*inverse a inverse (^:_1)
inv=: inverse=: ^:_1

NB. =========================================================
NB.*iospath v iOS file system path
iospath=: 3 : 0
if. IFIOS *. ('/j'-:2{.y) do. y=. y,~ '/Documents',~ 2!:5 'HOME' end.
y
)

NB. =========================================================
NB.*isatty v test whether a file descriptor refers to a terminal
NB.-Test whether a file descriptor refers to a terminal
NB.- FILE_TYPE_CHAR=: 2
NB.- STD_INPUT_HANDLE=: _10
NB.- STD_OUTPUT_HANDLE=: _11
NB.- STD_ERROR_HANDLE=: _12
3 : 0''
if. IFUNIX do.
  isatty=: ((unxlib 'c'),' isatty > i i') & (15!:0)
else.
  isatty=: 2: = ('kernel32 GetFileType > i x' & (15!:0)) @ ('kernel32 GetStdHandle > x i'& (15!:0)) @ - @ (10&+)
end.
''
)

NB. =========================================================
NB.*isutf8 v if character string is valid UTF-8
isutf8=: 0:`(1:@(7&u:) :: 0:)@.(2=3!:0)

NB. =========================================================
NB.*isutf16 v if character string is valid UTF-16
isutf16=: 0:`(1:@(8&u:) :: 0:)@.(131072=3!:0)

NB. =========================================================
NB.*items a name for ("_1)
items=: "_1

NB. =========================================================
NB.*fetch v name for {::
fetch=: {::

NB. =========================================================
NB.*leaf a leaf (L:0)
leaf=: L:0

NB. =========================================================
NB.*list v list data formatted in columns
NB.-syntax:   {width} list data
NB.-accepts data as one of:
NB.-  boxed list
NB.-  character vector, delimited by CR, LF or CRLF; or by ' '
NB.-  character matrix
NB.-formats in given width, default screenwidth
list=: 3 : 0
w=. {.wcsize''
w list y
:
if. 0=#y do. i.0 0 return. end.
if. 2>#$y=. >y do.
  d=. (' ',LF) {~ LF e. y=. toJ ": y
  y=. [;._2 y, d #~ d ~: {: y
end.
y=. y-. ' '{.~ c=. {:$ y=. (": y),.' '
(- 1>. <. x % c) ;\ <"1 y
)

NB. =========================================================
NB.*nameclass v name for 4!:0
NB.*nc v name for 4!:0
nameclass=: nc=: 4!:0

NB. =========================================================
NB.*namelist v name for 4!:1
namelist=: 4!:1

NB. =========================================================
NB.*nl v selective namelist
NB.-syntax:
NB.+[mp] nl sel
NB.-
NB.-  sel:  one or more integer name classes, or a name list.
NB.-        if empty use: 0 1 2 3.
NB.-  mp:   optional matching pattern. If mp contains '*', list names
NB.-        containing mp, otherwise list names starting mp. If mp
NB.-        contains '~', list names that do not match.
NB.-
NB.- e.g. 'f' nl 3      - list verbs that begin with 'f'
NB.-      '*com nl ''   - list names containing 'com'
nl=: 3 : 0
'' nl y
:
if. 0 e. #y do. y=. 0 1 2 3 end.

if. 1 4 8 e.~ 3!:0 y do.
  nms=. (4!:1 y) -. ;: 'x y x. y.'
else.
  nms=. cutopen_z_ y
end.

if. 0 e. #nms do. return. end.

if. #t=. x -. ' ' do.
  'n s'=. '~*' e. t
  t=. t -. '~*'
  b=. t&E. &> nms
  if. s do. b=. +./"1 b
  else. b=. {."1 b end.
  nms=. nms #~ n ~: b
end.
)

NB. =========================================================
NB.*names v formatted namelist
names=: list_z_ @ nl

NB. =========================================================
NB.*Note v notes in script
NB.-
NB.-*Monadic form:*
NB.-
NB.-This enables multi line comments without repeated NB.-and
NB.-requires a right parenthesis in the first column of a line to
NB.-close. The right argument may be empty, numeric, text, or any
NB.-noun. Reads and displays the comment text but always returns an
NB.-empty character string so the comment is not duplicated on screen.
NB.-
NB.-The right argument can number or describe the notes, e.g.
NB.-
NB.+  Note 1     Note 2.2   or    Note 'The special case' etc.
NB.-
NB.-*Dyadic form:*
NB.-
NB.-This permits a single consist form of comment for any lines which are
NB.-not tacit definitions. The left argument must be a noun. The function
NB.-code displays the right argument and returns the left argument.
NB.-
NB.-example:
NB.+Note 1
NB.+... note text
NB.+)
NB.
NB.+   (2 + 3)=(3 + 2) Note 'addition is commutative'
Note=: 3 : '0 0 $ 0 : 0' : [

NB. =========================================================
NB.*on c name for @:
on=: @:

NB. =========================================================
NB.*pick v pick (>@{)
pick=: >@{

NB. =========================================================
NB.*rows a rows ("1)
rows=: "1

NB. =========================================================
NB.*script v load script, cover for 0!:0
NB.*scriptd v load script with display, cover for 0!:1
script=: [: 3 : '0!:0 y [ 4!:55<''y''' jpath_z_ &.: >
scriptd=: [: 3 : '0!:1 y [ 4!:55<''y''' jpath_z_ &.: >

NB. =========================================================
NB.*stdout v name for 1!:2&4
NB.*stderr v name for 1!:2&5
NB.*stdin v name for 1!:1&3 with obverse stdout
stdout=: 1!:2&4
stderr=: 1!:2&5
stdin=: 1!:1@3: :. stdout

NB. =========================================================
NB.*sign v sign (*)
sign=: *

NB. =========================================================
NB.*sminfo v info box or output to session
sminfo=: 3 : 0
if. IFJHS do. smoutput >{:boxopen y
elseif. IFQT do. wdinfo_jqtide_ y
elseif. IFJA do. wdinfo_ja_ y
elseif. IFJNET do. wdinfo_jnet_ y
elseif. (0-:11!:0 ::0:'qwd') < 3=4!:0<'wdinfo' do. wdinfo y
elseif. do. smoutput >{:boxopen y end.
)

NB. =========================================================
NB.*echo v output to session
NB.*smoutput v output to session
NB.*tmoutput v output to stdout
echo=: 0 0 $ 1!:2&2
smoutput=: 0 0 $ 1!:2&2
tmoutput=: 0 0 $ 1!:2&4

NB. =========================================================
NB.*sort v sort up
sort=: /:~ : /:

NB. =========================================================
NB.*split v split head from tail
NB.-example:
NB.+   split 'abcde'
NB.+┌─┬────┐
NB.+│a│bcde│
NB.+└─┴────┘
NB.+   2 split 'abcde'
NB.+┌──┬───┐
NB.+│ab│cde│
NB.+└──┴───┘
split=: {. ,&< }.

NB. =========================================================
NB.*table a function table
NB.-table   - function table  (adverb)
NB.-example:
NB.+   1 2 3 * table 10 11 12 13
NB.+┌─┬───────────┐
NB.+│*│10 11 12 13│
NB.+├─┼───────────┤
NB.+│1│10 11 12 13│
NB.+│2│20 22 24 26│
NB.+│3│30 33 36 39│
NB.+└─┴───────────┘
table=: 1 : 0~
:
(((#~LF-.@e.])5!:5<'u');,.y),.({.;}.)":x,y u/x
)

NB. =========================================================
NB.*take v name for {.
take=: {.

NB. =========================================================
NB.*timespacex v time and space for expressions
NB.-syntax:
NB.+[repetitions] timespacex 'expression'
NB.-example:
NB.+   10 timespacex &> 'q:123456787';'3^10000x'
NB.+0.005 58432
NB.+0.061 52352
NB.-See also [timex](#timex).
timespacex=: 6!:2 , 7!:2@]

NB. =========================================================
NB.*timex v time expressions
NB.-syntax:
NB.+[repetitions] timex 'expression'
NB.-See also [timespacex](#timespacex).
timex=: 6!:2

NB. =========================================================
NB.*tolist v convert boxed to list
tolist=: }.@;@:(LF&,@,@":&.>)

NB. =========================================================
NB.*tolower v convert text to lower case
NB.*toupper v convert text to upper case
tolower=: 3 : 0
x=. I. 26 > n=. ((65+i.26){a.) i. t=. ,y
($y) $ ((x{n) { (97+i.26){a.) x}t
)

toupper=: 3 : 0
x=. I. 26 > n=. ((97+i.26){a.) i. t=. ,y
($y) $ ((x{n) { (65+i.26){a.) x}t
)

NB. =========================================================
NB.*type v object type
t=. <;._1 '/invalid name/not defined/noun/adverb/conjunction/verb/unknown'
type=: {&t@(2&+)@(4!:0)&boxopen

NB. =========================================================
NB.*ucp v convert text to UTF-16
NB.-This is 7-bit ascii (if possible) or literal2 with UTF-16 encoding
NB.-(compare [uucp](#uucp)).
NB.-
NB.-inverse is [utf8](#utf8).
ucp=: 7&u:

NB. =========================================================
NB.*ucpcount v literal2 count
NB.-Counts number of literal2 in a string when converted to UTF-16
NB.-
NB.-A unicode codepoint has one or two literal2, this gives the
NB.-number of literal2, not unicode codepoint
ucpcount=: # @ (7&u:)

NB. =========================================================
NB.*usleep v sleep for n microseconds
NB.- linux max value around 33 minutes
NB.- windows minimum resolution in milliseconds.
3 : 0''
if. IFUNIX do.
  usleep=: 3 : ('''',(unxlib 'c'),' usleep > i i''&(15!:0) >.y')
else.
  usleep=: 3 : '0: ''kernel32 Sleep > n i''&(15!:0) >.y % 1000'
end.
EMPTY
)

NB. =========================================================
NB.*utf8 v convert string to UTF-8
NB.-Convert string to literal with UTF-8 encoding
NB.-
NB.-Inverse of [ucp](#ucp).
utf8=: 8&u:

NB. =========================================================
NB.*uucp v convert text to UTF-16
NB.-Convert text to literal2 with UTF-16 encoding
NB.-
NB.-This is always literal2 (compare [ucp](#ucp))
uucp=: u:@(7&u:)

NB. =========================================================
NB.*toCRLF v converts character strings to CRLF delimiter
NB.*toHOST v converts character strings to Host delimiter
NB.*toJ v converts character strings to J delimiter (linefeed)
3 : 0''
h=. 9!:12''
subs=. 2 : 'x I. @(e.&y)@]} ]'
toJ=: (LF subs CR) @: (#~ -.@(CRLF&E.@,))
toCRLF=: 2&}. @: ; @: (((CR&,)&.>)@<;.1@(LF&,)@toJ)
if. h=5 do.
  toHOST=: ]
else.
  toHOST=: toCRLF
end.
1
)
