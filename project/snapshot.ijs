NB. snapshot utilities

pp_today=: 2 }. [: ": [: <. 100 #. 3 {. 6!:0

NB. =========================================================
NB. get script snapshot list for given folder
pic_files=: 3 : 0
{."1 [1!:0 (snappath y),'/p','/*',~pp_today''
)

NB. =========================================================
NB. argument is date yymmdd
pic_list=: 3 : 0
t=. y,(0=#y)#pp_today''
p=. (snappath each fpath each FolderTree) ,each <'/p*'
d=. 1!:0 each p
m=. I. 0 < # &> d
if. 0 = #m do. EMPTY return. end.
p=. ;t&pic_list1 each m
s=. >}."1 p
p=. ({."1 p),<'total'
(>p),.' ',.":s,+/s
)

NB. =========================================================
pic_list1=: 4 : 0
fp=. (snappath fpath y pick FolderTree),'/p',x,'/'
d=. 1!:0 fp,'*'
if. 0=#d do. i. 0 3 return. end.
f=. {."1 d
c=. (EAV+/ .=fread) each (<fp) ,each f
s=. 2{"1 d
m=. (<'/',~y pick FolderIds),each f
m,.c,.s
)

NB. =========================================================
NB. y = full filename
NB. reads all records as boxed list
pic_read=: 3 : 0
'f p'=. fpathname y
r=. fread (snappath f),'/p',(pp_today''),'/',p
if. r -: _1 do. '' else. <;._2 r end.
)

NB. =========================================================
NB. y = (full filename);index
NB. reads record at index, removing timestamp
pic_readx=: 3 : 0
'f n'=. y
_6 }. n pick pic_read f
)

NB. =========================================================
NB. return snap path for directory path (Qt IDE only)
snappath=: 3 : 0
jpath '~snap/.snp/',getsha1_jqtide_ projname2path remsep y
)

NB. =========================================================
ss_cleanup=: 3 : 0
if. 1~:#y do.
  r=. ''
  r=. r,'0 = list invalid snapshot directories',LF
  r=. r,'1 = list non-existent projects with snapshots',LF
  r=. r,'100 = remove invalid snapshot directories',LF
  r=. r,'101 = remove snapshots for non-existent projects'
  smoutput r return.
end.
'd r n'=. ss_dirs''
select. y
case. 0 do.
  d #~ n=2
case. 1 do.
  r #~ n=1
case. 100 do.
  ; {. &> rmdir_j_ each d #~ n=2
case. 101 do.
  ; {. &> rmdir_j_ each d #~ n=1
end.
)

NB. =========================================================
NB. return pair
NB.   all snapshot directories
NB.   corresponding project names or '' if invalid
ss_dir=: 3 : 0
p=. jpath '~snap/.snp/'
d=. 1!:0 p,'*'
d=. ('d' = 4 {"1 > 4 {"1 d) # {."1 d
d=. (<p) ,each d
d;<(1!:1 :: (''"_))@< each d ,each <'/dir.txt'
)

NB. =========================================================
NB. single snapshot directory
NB. argument is projectname
ss_dir1=: 3 : 0
if. 0=#y do. '' return. end.
dir (snappath y),'/*'
)

NB. =========================================================
NB. return 3 lists:
NB.   all snapshot directories
NB.   corresponding project names or '' if invalid
NB.   numeric list:
NB.     0 project snapshot
NB.     1 non-project snapshot
NB.     2 invalid snapshot
ss_dirs=: 3 : 0
'd r'=. ss_dir''
s=. /:r
r=. s{r
d=. s{d
m=. 0 < #&> r
n=. 2 * -. m
r=. m#r
p=. (*./\.@:~:&'/' # ]) each r
p=. r ,each '/' ,each p ,each <ProjExt
n=. (-. fexist &> p) (I.m) } n
r=. (tofoldername_j_ each r) (I.m) } (#d) # <''
d;r;n
)

NB. =========================================================
NB. ss_files get directory list of files
NB. ignores exclusion list and hidden files
ss_files=: 3 : 0
t=. 1!:0 y,'*'
if. 0=#t do. return. end.
att=. > 4{"1 t
msk=. ('h' = 1{"1 att) +: 'd' = 4{"1 att
t=. /:~ msk # t
if. _1 = 4!:0 <'ss_exclude' do.
  exs=. '.' ,each SnapshotX_j_
  ss_exclude_jp_=: [: +./ exs & ((1 e. E.) &>/)
end.
t #~ -. ss_exclude {."1 t
)

NB. =========================================================
ss_find=: 3 : 0
y=. y,(0=#y)#ProjectPath
'd r'=. ss_dir''
ndx=. r i. <jpath remsep_j_ y
ndx pick d,<'not found: ',y
)

NB. =========================================================
ss_info=: 3 : 0
sminfo 'Snapshot';y
)

NB. =========================================================
NB. ss_list v list of snapshots
NB. argument is projectname
ss_list=: 3 : 0
if. 0=#y do. '' return. end.
p=. snappath y
d=. 1!:0 p,'/s*'
if. #d do.
  d=. d #~ 'd' = 4 {"1 > 4 {"1 d
  \:~ {."1 d
else.
  ''
end.
)

NB. =========================================================
NB. ss_match match directories
ss_match=: 4 : 0
x=. termsep x
y=. termsep y
a=. ss_files x
b=. ss_files y
ra=. #a
rb=. #b
if. 0 e. ra,rb do.
  ra = rb return.
end.
fa=. {."1 a
fb=. {."1 b
if. -. fa -: fb do. 0 return. end.
if. -. (2 {"1 a) -: (2 {"1 b) do. 0 return. end.
fx=. x&, each fa
fy=. y&, each fa
(<@(1!:1) fy) -: <@(1!:1) fx
)

NB. =========================================================
NB. remove all snapshots from folder tree
ss_removesnaps=: 3 : 0
direrase each snappath each fpath each FolderTree
)

NB. =========================================================
ss_state=: 3 : 0
'd r n'=. ss_dirs''
r=. 'valid existent, valid nonexistent, invalid:',LF
r=. r,":+/ n =/ 0 1 2
)
