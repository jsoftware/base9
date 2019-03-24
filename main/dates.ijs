NB. date and time utilities
NB.%dates.ijs - date and time utilities
NB.-This script defines date and time utilities and is included in the J standard library.
NB.-Definitions are loaded into the z locale.

NB.   calendar        calendar for year [months]
NB.   isotimestamp    ISO-formatted time stamp
NB.   getdate         get date from character string
NB.   todate          convert to date
NB.   todayno         convert to day number
NB.   tsdiff          differences between dates
NB.   tsrep           timestamp as a single number
NB.   timestamp       formatted timestamp
NB.   valdate         validate dates
NB.   weekday         weekday from date
NB.   weeknumber      weeknumber from date
NB.   weeksinyear     number of weeks in year
NB.
NB.   tstamp          obsolete naming for timestamp

cocurrent 'z'

NB. =========================================================
NB.*calendar v formatted calendar for year [months]
NB.-
NB.-Returns calendar for year, as a list of months
NB.-
NB.-syntax:
NB.+[opt] calendar year [months]
NB.-
NB.-right argument is one or more numbers: year, months
NB.-If no months are given, it defaults to all months.
NB.-
NB.-optional left argument is startday of week,
NB.- 0=sunday (default)
NB.- 1=monday
NB.-
NB.-example:
NB.+   calendar 2014 3 4
NB.+┌─────────────────────┬─────────────────────┐
NB.+│         Mar         │         Apr         │
NB.+│ Su Mo Tu We Th Fr Sa│ Su Mo Tu We Th Fr Sa│
NB.+│                    1│        1  2  3  4  5│
NB.+│  2  3  4  5  6  7  8│  6  7  8  9 10 11 12│
NB.+│  9 10 11 12 13 14 15│ 13 14 15 16 17 18 19│
NB.+│ 16 17 18 19 20 21 22│ 20 21 22 23 24 25 26│
NB.+│ 23 24 25 26 27 28 29│ 27 28 29 30         │
NB.+│ 30 31               │                     │
NB.+└─────────────────────┴─────────────────────┘
calendar=: 3 : 0
0 calendar y
:
a=. ((j<100)*(-100&|){.6!:0'')+j=. {.y
b=. (a-x)+-/<.4 100 400%~<:a
r=. 28+3,(~:/0=4 100 400|a),10$5$3 2
r=. (-7|b+0,+/\}:r)|."0 1 r(]&:>:*"1>/)i.42
m=. (<:}.y),i.12*1=#y
h=. 'JanFebMarAprMayJunJulAugSepOctNovDec'
h=. ((x*3)|.' Su Mo Tu We Th Fr Sa'),:"1~_3(_12&{.)\h
<"2 m{h,"2[12 6 21 ($,) r{' ',3":1+i.31 1
)

NB. =========================================================
NB.*getdate v get date from character string
NB.-Get date from character string.
NB.-Useful for input forms with date entry fields.
NB.-syntax:
NB.+[opt] getdate string
NB.-
NB.- date forms permitted:
NB.-    1986 5 23
NB.-    May 23 1986
NB.-    23 May 1986
NB.-
NB.- optional x:
NB.-  0  = days first - default (23 5 1986)
NB.-  1  = months first (5 23 1986)
NB.-
NB.-Other characters allowed:  ,-/:
NB.-
NB.-If not given, century defaults to current
NB.-
NB.-Only first 3 characters of month are tested.
NB.-
NB.-example:
NB.+   getdate '23/5/86'
NB.+2086 5 23
NB.+   getdate 'may 23, 1986'
NB.+1986 5 23
NB.+   getdate '1986-5-23'
NB.+1986 5 23
getdate=: 3 : 0
0 getdate y
:
r=. ''
opt=. x
chr=. [: -. [: *./ e.&'0123456789 '
dat=. ' ' (I. y e.',-/:') } y

if. chr dat do.
  opt=. 0
  dat=. a: -.~ <;._1 ' ',dat
  if. 1=#dat do. r return. end.
  typ=. chr &> dat
  dat=. (2{.typ{dat),{:dat
  mth=. 3{.>1{dat
  uc=. 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
  lc=. 'abcdefghijklmnopqrstuvwxyz'
  mth=. (lc,a.) {~ mth i.~ uc,a.
  mos=. _3[\'janfebmaraprmayjunjulaugsepoctnovdec'
  mth=. <": >:mos i. mth
  dat=. ;' ',each mth 1 } dat
end.

dat=. ". :: (''"_) dat
if. 0 e. #dat do. return. end.

if. 3 ~: #dat do. r return. end.

if. 31 < {.dat do. 'y m d'=. dat
else. ((opt|.'d m '),' y')=. dat
end.

if. y<100 do.
  y=. y + (-100&|) {. 6!:0''
end.

(#~ valdate) y,m,d
)

NB. =========================================================
NB.*isotimestamp v format time stamps as:  2000-05-23 16:06:39.268
NB.-Format time stamps as:  2000-05-23 16:06:39.268
NB.-
NB.-y is one or more time stamps in 6!:0 format.
isotimestamp=: 3 : 0
r=. }: $y
t=. _6 [\ , 6 {."1 y
NB. d=. '--b::' 4 7 10 13 16 }"1 [ 4 3 3 3 3 3 ": <.t
NB. d=. d ,. }."1 [ 0j3 ": ,. 1 | {:"1 t
d=. '--b:' 4 7 10 13 }"1 [ 4 3 3 3 3 ": <. 5{."1 <.t
d=. d ,. ':' 0 }"1 [ 7j3 ": ,. {:"1 t
c=. {: $d
d=. ,d
d=. '0' (I. d=' ')} d
d=. ' ' (I. d='b')} d
(r,c) $ d
)

NB. =========================================================
NB.*todate v converts day numbers to dates
NB.-Converts day numbers to dates, converse [todayno](#todayno)
NB.-
NB.-This conversion is exact and provides a means of
NB.-performing exact date arithmetic.
NB.-
NB.- y = day numbers
NB.- x = optional:
NB.-   0 - result in form <yyyy mm dd> (default)
NB.-   1 - result in form <yyyymmdd>
NB.-   2 - result in form <yyyy mm dd hh MM ss>
NB.-
NB.-example:
NB.+   todate 72460
NB.+1998 5 23
NB.+
NB.+   todate 0 1 2 3 + todayno 1992 2 27
NB.+1992 2 27
NB.+1992 2 28
NB.+1992 2 29
NB.+1992 3  1

todate=: 3 : 0
0 todate y
:
s=. $y
y=. s$ 0 (I. (,y) e. _ __)},y
a=. 657377.75 +, y=. <. p=. y
d=. <. a - 36524.25 * c=. <. a % 36524.25
d=. <.1.75 + d - 365.25 * y=. <. (d+0.75) % 365.25
r=. (1+12|m+2) ,: <. 0.41+d-30.6* m=. <. (d-0.59) % 30.6
if. 1<x do.
  h=. <. t=. 24*(1&|) ,p
  mm=. <. t=. 60*t-h
  ss=. 60*t-mm
  r=. s $ |: ((c*100)+y+m >: 10) ,r , |: h ,. mm,. ss
else.
  r=. s $ |: ((c*100)+y+m >: 10) ,r
end.
if. 1=x do. r=. 100 #. r end.
r
)

NB. =========================================================
NB.*todayno v converts dates to day numbers
NB.-Converts dates to day numbers, converse [todate](#todate)
NB.-
NB.- y = dates
NB.-
NB.- x = optional:
NB.-   0 - dates in form YYYY MM DD (default)
NB.-   1 - dates in form YYYYMMDD
NB.-   2 - dates in form YYYY MM DD HH MM SS
NB.-
NB.-0 = todayno 1800 1 1, or earlier
NB.-
NB.-example:
NB.+   todayno 1998 5 23
NB.+72460

todayno=: 3 : 0
0 todayno y
:
a=. y
if. 1=x do. a=. 0 100 100 #: a end.
a=. ((*/r=. }: $a) , {:$a) $,a
if. 1<x do.
  'y m d h mm s'=. <"_1 |: a
else.
  'y m d'=. <"_1 |: a
end.
y=. 0 100 #: y - m <: 2
n=. +/ |: <. 36524.25 365.25 *"1 y
n=. n + <. 0.41 + 0 30.6 #. (12 | m-3),"0 d
if. 1<x do.
  n=. n + (24 60 60#.h,.mm,.s)%24*3600
end.
0 >. r $ n - 657378
)

NB. =========================================================
NB.*tsdiff v differences between pairs of dates.
NB.-Return differences between pairs of dates.
NB.-syntax:
NB.+end tsdiff begin
NB.-
NB.-  end, begin are vectors or matrices in form YYYY MM DD
NB.-  end dates should be later than begin dates
NB.-
NB.-method is to subtract dates on a calendar basis to determine
NB.-integral number of months plus the exact number of days remaining.
NB.-This is converted to payment periods, where # days remaining are
NB.-calculated as: (# days)%365
NB.-
NB.-example:
NB.+   1994 10 1 tsdiff 1986 5 23
NB.+8.35799

tsdiff=: 4 : 0
r=. -/"2 d=. _6 (_3&([\)) \ ,x,"1 y
if. #i=. i#i.#i=. 0 > 2{"1 r do.
  j=. (-/0=4 100 400 |/ (<i;1;0){d)* 2=m=. (<i;1;1){d
  j=. _1,.j + m{0 31 28 31 30 31 30 31 31 30 31 30 31
  n=. <i;1 2
  r=. (j + n{r) n } r
end.
r +/ . % 1 12 365
)

NB. =========================================================
NB.*tsrep v timestamp representation as a single number
NB.-
NB.-syntax:
NB.-[opt] timerep times
NB.-  opt=0  convert timestamps to numbers (default)
NB.-      1  convert numbers to timestamps
NB.-
NB.-timestamps are in 6!:0 format, or matrix of same.
NB.-
NB.-example:
NB.+   tsrep 1800 1 1 0 0 0
NB.+0
NB.+   x: tsrep 1995 5 23 10 24 57.24
NB.+6165887097240
tsrep=: 3 : 0
0 tsrep y
:
if. x do.
  r=. $y
  'w n t'=. |: 0 86400 1000 #: ,y
  w=. w + 657377.75
  d=. <. w - 36524.25 * c=. <. w % 36524.25
  d=. <.1.75 + d - 365.25 * w=. <. (d+0.75) % 365.25
  s=. (1+12|m+2) ,: <. 0.41+d-30.6* m=. <. (d-0.59) % 30.6
  s=. |: ((c*100)+w+m >: 10) ,s
  r $ s,. (_3{. &> t%1000) +"1 [ 0 60 60 #: n
else.
  a=. ((*/r=. }: $y) , {:$y) $, y
  'w m d'=. <"_1 |: 3{."1 a
  w=. 0 100 #: w - m <: 2
  n=. +/ |: <. 36524.25 365.25 *"1 w
  n=. n + <. 0.41 + 0 30.6 #. (12 | m-3),"0 d
  s=. 3600000 60000 1000 +/ .*"1 [ 3}."1 a
  r $ s+86400000 * n - 657378
end.
)

NB. =========================================================
NB.*timestamp v format time stamps as:  23 May 1998 16:06:39
NB. Format time stamps as:  23 May 1998 16:06:39
NB.-
NB.-y is one or more time stamps in 6!:0'' format.
NB.-If empty defaults to current time.
timestamp=: 3 : 0
if. 0 = #y do. w=. 6!:0'' else. w=. y end.
r=. }: $ w
t=. 2 1 0 3 4 5 {"1 [ _6 [\ , 6 {."1 <. w
d=. '+++::' 2 6 11 14 17 }"1 [ 2 4 5 3 3 3 ": t
mth=. _3[\'   JanFebMarAprMayJunJulAugSepOctNovDec'
d=. ,((1 {"1 t) { mth) 3 4 5 }"1 d
d=. '0' (I. d=' ') } d
d=. ' ' (I. d='+') } d
(r,20) $ d
)

NB. =========================================================
NB.*tstamp v format time stamps as:  23 May 1998 16:06:39
NB.-Same as [timestamp])#timestamp)
tstamp=: timestamp

NB. =========================================================
NB.*valdate v validate dates
NB.-syntax:
NB.-valdate dates
NB.- dates is 3-element vector
NB.-       or 3-column matrix
NB.-       in form YYYY MM DD
NB.-
NB.-returns 1 if valid
valdate=: 3 : 0
s=. }:$y
'w m d'=. t=. |:((*/s),3)$,y
b=. *./(t=<.t),(_1 0 0<t),12>:m
day=. (13|m){0 31 28 31 30 31 30 31 31 30 31 30 31
day=. day+(m=2)*-/0=4 100 400|/w
s$b*d<:day
)

NB. =========================================================
NB.*weekday v returns weekday from date, 0=Sunday ... 6=Saturday
NB.-Returns weekday from date, 0=Sunday ... 6=Saturday.
NB.-Arguments as for [todayno](#todayno)
NB.-
NB.-example:
NB.+   weekday 1997 5 23
NB.+5
NB.+   1 weekday 19970523
NB.+5

weekday=: 7 | 3 + todayno

NB. =========================================================
NB.*weeknumber v gives the year and weeknumber of date
NB.-
NB.-Gives the year and weeknumber of date.
NB.-
NB.-A week belongs to a year iff 4 days of the week belong to that year.
NB.-see [iso 8601 calendar](http://www.phys.uu.nl/~vgent/calendar/isocalendar.htm)
NB.-
NB.-y = dates
NB.-In the ISO 8601 calendar a week starts on monday.
NB.-
NB.-example:
NB.+   weeknumber 2005 1 2
NB.+2004 53
NB.+   weeknumber 2005 1 3
NB.+2005 1

weeknumber=: 3 : 0
yr=. {.y
sd=. 1 ((i.~weekday){]) ((<:yr),.12,.29+i.3),yr,.1,.1+i.4
wk=. >.7%~>: y -&todayno sd
if. wk >weeksinyear yr do.
  (>:yr),1
elseif. wk=0 do.
  (,weeksinyear)<:yr
elseif. do.
  yr,wk
end.
)

NB. =========================================================
NB.*weeksinyear v gives number of weeks in year
NB.-Gives number of weeks in year
NB.-
NB.-y = years
NB.-
NB.-In the ISO 8601 calendar a week starts on monday.
NB.-
NB.-example:
NB.+  weeksinyear 2000 +i.10
NB.+52 52 52 52 53 52 52 52 52 53

weeksinyear=: 3 : '52+ +./"1 [ 4=weekday(1 1,:12 31),"0 1/~ y'
