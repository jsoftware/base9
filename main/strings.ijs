NB. string manipulation
NB.%strings.ijs - string utilities
NB.-This script defines string utilities and is included in the J standard library.
NB.-Definitions are loaded into the z locale.

NB. charsub        character substitution
NB. chopstring     chop delimited string to list of boxed strings
NB. cut            cut text, by default on blanks
NB. cuts           cut y at x (conjunction)
NB. deb            delete extra blanks
NB. debc           delete extra blank columns in matrix
NB. dlb            delete leading blanks
NB. dltb           delete leading and trailing blanks
NB. dltbs          delete multiple leading and trailing blanks
NB. dtb            delete trailing blanks
NB. dtbs           delete multiple trailing blanks
NB. delstring      delete occurrences of x from y
NB. joinstring     join boxed list y with x; see splitstring
NB. ljust          left justify
NB. rjust          right justify
NB. rplc           replace in string
NB. splitnostring  split y by non-overlapping substrings x
NB. splitstring    split y by substring x
NB. ss             string search for x in y
NB.
NB. dropafter      drop after x in y
NB. dropto         drop to x in y
NB. takeafter      take after x in y
NB. taketo         take to x in y
NB.
NB. quote          quote text
NB. dquote         double quote text
NB.
NB. stringreplace  replace in string
NB. fstringreplace replace in file

NB. For example:
NB.
NB.   3       =  'de' # cuts _1 'abcdefg'
NB.   'abcfg' =  'de' delstring 'abcdefg'
NB.   'abcde' =  'de' dropafter 'abcdefg'
NB.   'defg'  =  'de' dropto    'abcdefg'
NB.   'fg'    =  'de' takeafter 'abcdefg'
NB.   'abc'   =  'de' taketo    'abcdefg'

cocurrent 'z'

NB. =========================================================
NB.*cuts c cut strings at given text
NB.-This builds verbs to cut strings at given text and
NB.-apply verbs to the pieces.
NB.-syntax:
NB.+string (verb cuts n) text
NB.-  n=_1  up to but not including string
NB.-  n= 1  up to and including string
NB.-  n=_2  after but not including string
NB.-  n= 2  after and including string
cuts=: 2 : 0
if. n=1 do. [: u (#@[ + E. i. 1:) {. ]
elseif. n=_1 do. [: u (E. i. 1:) {. ]
elseif. n= 2 do. [: u (E. i. 1:) }. ]
elseif. 1 do. [: u (#@[ + E. i. 1:) }. ]
end.
)

NB. =========================================================
NB.*cut v cut text, by default on blanks
NB.*deb v delete extra blanks
NB.*dlb v delete leading blanks
NB.*dltb v delete leading and trailing blanks
NB.*dtb v delete trailing blanks
NB.*delstring v delete occurrences of x from y
NB.*joinstring v join boxed list y with x; see splitstring
NB.*ljust v left justify
NB.*rjust v right justify
NB.*ss v string search

cut=: ' '&$: :([: -.&a: <;._2@,~)
deb=: #~ (+. 1: |. (> </\))@(' '&~:)
debc=: #~"1 [: (+. (1: |. (> </\))) ' '&(+./ .~:)
delstring=: 4 : ';(x E.r) <@((#x)&}.) ;.1 r=. x,y'
detab=: ' ' I.@(=&TAB@])} ]
dlb=: }.~ =&' ' i. 0:
dltb=: #~ [: (+./\ *. +./\.) ' '&~:
dtb=: #~ [: +./\. ' '&~:
joinstring=: ''&$: : (#@[ }. <@[ ;@,. ])
ljust=: (|.~ +/@(*./\)@(' '&=))"1
rjust=: (|.~ -@(+/)@(*./\.)@(' '&=))"1
ss=: I. @ E.

NB. =========================================================
NB.*dropafter v drop after x in y
NB.*dropto v drop to x in y
NB.*takeafter v take after x in y
NB.*taketo v take to x in y

dropto=: ] cuts 2
dropafter=: ] cuts 1
taketo=: ] cuts _1
takeafter=: ] cuts _2

NB. =========================================================
NB.*charsub v character substitution
NB.-syntax:
NB.+characterpairs charsub string
NB.-example:
NB.+   '-_$ ' charsub '$123 -456 -789'
NB.+123 _456 _789
NB.-note:
NB.-Use [rplc](#rplc) for arbitrary string replacement.
NB.
NB. thanks to Dan Bron/Jforum 25 April 2006
charsub=: 4 : 0
'f t'=. |: _2 ]\ x
l=. f i."1 0 y
x=. l { t,'?'
c=. l = #f
c } x ,: y
)

NB. =========================================================
NB.*chopstring v chop delimited string to list of boxed strings
NB.-syntax:
NB.+[fd[;sd0[,sd1]]] chopstring string
NB.- returns: list of boxed literals
NB.-  y is: delimited string
NB.-  x is: a literal or 1 or 2-item boxed list of optional delimiters.
NB.-      0{:: single literal field delimiter (fd). Defaults to ' '
NB.-  (1;0){:: (start) string delimiter (sd0). Defaults to "
NB.-  (1;1){:: end string delimiter (sd1). Defaults to "
NB.-
NB.-Consecutive field delimiters indicate empty field.
NB.-Field delimiters may occur within a field if
NB.-the field is enclosed by string delimiters.
NB.-example:
NB.+   ('|';'<>') chopstring '<hello|world>|4|84.3'
NB.+┌───────────┬─┬────┐
NB.+│hello|world│4│84.3│
NB.+└───────────┴─┴────┘
chopstring=: 3 : 0
(' ';'""') chopstring y
:
dat=. y
'fd sd'=. 2{. boxopen x
assert. 1 = #fd
if. #sd do.
  sd=. ~.sd
  if. 1 < #sd do.                  NB. replace diff start and end delims with single
    s=. {. '|`' -. fd              NB. choose single sd
    dat=. dat charsub~ ,sd,.s
    sd=. s
  end.
  dat=. dat,fd
  b=. dat e. fd
  c=. dat e. sd
  d=. ~:/\ c                       NB. mask inside sds
  fmsk=. b > d                     NB. end of fields
  smsk=. (> (0 , }:)) c            NB. first in group of sds
  smsk=. -. smsk +. c *. 1|.fmsk   NB. or previous to fd
  y=. smsk#y,fd                    NB. compress out string delims
  fmsk=. 0:^:(,@1: -: ]) smsk#fmsk
  fmsk <;._2 y                     NB. box
else.                              NB. no string delimters so can simplify processing
  <;._2 dat,fd
end.
)

NB. =========================================================
NB.*dltbs v delete multiple leading and trailing blanks
NB.-Delete multiple leading and trailing blanks.
NB.-Text is delimited by characters in x with default LF
NB.-example:
NB.+   < 'A' dltbs ' A abc  def  Ars  A  x y  z  '
NB.+┌───────────────────┐
NB.+│Aabc  defArsAx y  z│
NB.+└───────────────────┘
dltbs=: LF&$: : (4 : 0)
txt=. ({.x), y
a=. txt ~: ' '
b=. (a # txt) e. x
c=. b +. }. b, 1
d=. ~: /\ a #^:_1 c ~: }: 0, c
}. (a >: d) # txt
)

NB. =========================================================
NB.*dquote v double quote text
NB.-example:
NB.+   dquote 'Pete"s Place'
NB.+"Pete""s Place"
dquote=: ('"'&,@(,&'"'))@ (#~ >:@(=&'"'))

NB. =========================================================
NB.*dtbs v delete multiple trailing blanks in text
NB.-Delete multiple trailing blanks in text.
NB.-Text is delimited by characters in x with default CRLF
NB.-example:
NB.+   < 'A' dtbs ' A abc  def  Ars  A  x y  z  '
NB.+┌──────────────────────┐
NB.+│A abc  defArsA  x y  z│
NB.+└──────────────────────┘
NB.
NB. Algorithm thanks to Brian Bambrough (JForum Nov 2000)
dtbs=: 3 : 0
CRLF dtbs y
:
txt=. y , {.x
blk=. txt ~: ' '
ndx=. +/\ blk
b=. blk < }. (txt e. x), 0
msk=. blk >: ndx e. b # ndx
}: msk # txt
)

NB. =========================================================
NB.*rplc v replace characters in text string
NB.-This is [stringreplace](#stringreplace) but
NB.-with arguments reversed.
NB.-example:
NB.+   'hello' rplc 'e';'a';'o';'owed'
NB.+hallowed
rplc=: stringreplace~

NB. =========================================================
NB.*fstringreplace v file string replace
NB.-Replace strings in file
NB.-syntax:
NB.+(old;new) fstringreplace file
fstringreplace=: 4 : 0
nf=. 'no match found'
y=. boxopen y
try. size=. 1!:4 y catch. nf return. end.
if. size=0 do. nf return. end.
old=. freads y
new=. x stringreplace old
if. old -: new do. nf return. end.
new fwrites y
cnt=. +/ (0 pick x) E. old
(":cnt),' replacement',((1~:cnt)#'s'),' made'
)

NB. =========================================================
NB.*quote v quote text
NB. quote 'Pete''s Place'
NB.-example:
NB.+   quote 'Pete"s Place'
NB.+'Pete''s Place'
quote=: (''''&,@(,&''''))@ (#~ >:@(=&''''))

NB. =========================================================
NB.*splitnostring v split y by non-overlapping substrings x
NB.-Split y by non-overlapping substrings x
NB.-This is a non-overlapping variant of E.
nos=. i.@#@] e. #@[ ({~^:a:&0@(,&_1)@(]I.+) { _1,~]) I.@E.
splitnostring=: #@[ }.each [ (nos f. <;.1 ]) ,

NB. =========================================================
NB.*splitstring v split y by substring x
NB.-Split y by substring x.
NB.-see [joinstring](#joinstring).
splitstring=: #@[ }.each [ (E. <;.1 ]) ,

NB. =========================================================
NB.*stringreplace v replace characters in text string
NB.-
NB.-syntax:
NB.+oldnew stringreplace text
NB.-oldnew is a 2-column boxed matrix of `old ,. new`
NB.-or a vector of same
NB.-
NB.-stringreplace priority is the same order as oldnew
NB.-
NB.-example:
NB.-
NB.+    ('aba';'XYZT';'ba';'+') stringreplace 'ababa'
NB.+ XYZT+
NB.+
NB.+    ('ba';'+';'aba';'XYZT') stringreplace 'ababa'
NB.+ a++
stringreplace=: 4 : 0

txt=. ,y
t=. _2 [\ ,x
old=. {."1 t
new=. {:"1 t
oldlen=. # &> old
newlen=. # &> new

if. *./ 1 = oldlen do.

  hit=. (;old) i. txt
  ndx=. I. hit < #old

  if. 0 e. $ndx do. txt return. end.

  cnt=. 1
  exp=. hit { newlen,1
  hnx=. ndx { hit
  bgn=. ndx + +/\ 0, (}: hnx) { newlen - 1

else.

  hit=. old I. @ E. each <txt
  cnt=. # &> hit

  if. 0 = +/ cnt do. txt return. end.

  bgn=. set=. ''

  pick=. > @ {
  diff=. }. - }:

  for_i. I. 0 < cnt do.
    ln=. i pick oldlen
    cx=. (i pick hit) -. set, ,bgn -/ i.ln
    while. 0 e. b=. 1, <:/\ ln <: diff cx do. cx=. b#cx end.
    hit=. (<cx) i} hit
    bgn=. bgn, cx
    set=. set, ,cx +/ i.ln
  end.

  cnt=. # &> hit
  msk=. 0 < cnt
  exp=. (#txt) $ 1
  del=. newlen - oldlen

  if. #add=. I. msk *. del > 0 do.
    exp=. (>: (add{cnt) # add{del) (;add{hit) } exp
  end.

  if. #sub=. I. msk *. del < 0 do.
    sbx=. ; (;sub{hit) + each (sub{cnt) # i. each sub{del
    exp=. 0 sbx } exp
  end.

  hit=. ; hit
  ind=. /: (#hit) $ 1 2 3
  hnx=. (/: ind { hit) { ind
  bgn=. (hnx { hit) + +/\ 0, }: hnx { cnt # del

end.

ind=. ; bgn + each hnx { cnt # i.each newlen
rep=. ; hnx { cnt # new
rep ind} exp # txt
)

NB. =========================================================
NB.*undquote v undo double quote text
NB.-example:
NB.+   undquote '"Pete""s Place"'
NB.+Pete"s Place
undquote=: (#~ -.@('""'&E.))@}:@}.^:(('"' = {.) *. '"' = {:)

