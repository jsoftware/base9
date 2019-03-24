NB. lib

NB. =========================================================
NB. compile flags:
PCRE2_NOTBOL=: 16b1
PCRE2_NOTEOL=: 16b2
PCRE2_MULTILINE=: 16b400

NB. info types:
PCRE2_INFO_SIZE=: 22

NB. =========================================================
NB. pcre2 library is in bin or tools/regex
3 : 0''
select. UNAME
case. 'Win' do. t=. 'jpcre2.dll'
case. 'Darwin' do. t=. 'libjpcre2.dylib'
case. 'Linux' do. t=. 'libjpcre2.so'
case. 'Android' do. t=. 'libjpcre2.so'
end.

f=. BINPATH,'/',t
if. 0 = 1!:4 :: 0: <f do.
  f=. jpath '~tools/regex/',t
end.

NB. fall back one more time
if. ('Android'-:UNAME) *. 0 = 1!:4 :: 0: <f do.
  f=. (({.~i:&'/')LIBFILE),'/',t
elseif. ('Linux'-:UNAME) *. (IFUNIX>'/'e.LIBFILE) *. 0 = 1!:4 :: 0: <f do.
  f=. 'libpcre2-8.so.0'
elseif. 0 = 1!:4 :: 0: <f do.
  f=. t
end.

pcre2dll=: f
)

NB. =========================================================
makefn=: 3 : 0
'name decl'=. y
('j',name)=: ('"',pcre2dll,'" ',name,'_8 ',(IFWIN#'+ '),decl)&(15!:0)
EMPTY
)

NB. void pcre2_code_free_8 (pcre2_code_8 *);
NB. pcre2_code_8 *pcre2_compile_8 (PCRE2_SPTR8, size_t, uint32_t, int *, size_t *, pcre2_compile_context_8 *);
NB. int pcre2_get_error_message_8 (int, PCRE2_UCHAR8 *, size_t);
NB. uint32_t pcre2_get_ovector_count_8 (pcre2_match_data_8 *);
NB. size_t *pcre2_get_ovector_pointer_8 (pcre2_match_data_8 *);
NB. int pcre2_match_8 (const pcre2_code_8 *, PCRE2_SPTR8, size_t, size_t, uint32_t, pcre2_match_data_8 *, pcre2_match_context_8 *);
NB. pcre2_match_data_8 *pcre2_match_data_create_from_pattern_8 (const pcre2_code_8 *, pcre2_general_context_8 *);
NB. void pcre2_match_data_free_8 (pcre2_match_data_8 *);
NB. int pcre2_pattern_info_8 (const pcre2_code_8 *, uint32_t, void *);

makefn 'pcre2_code_free';'n *'
makefn 'pcre2_compile';'* *c x i *i *x *'
makefn 'pcre2_get_error_message';'i i *c x'
makefn 'pcre2_get_ovector_count';'i *'
makefn 'pcre2_get_ovector_pointer';'*x *'
makefn 'pcre2_match';'i * *c x x i * *'
makefn 'pcre2_match_data_create_from_pattern';'* * *'
makefn 'pcre2_match_data_free';'n *'
makefn 'pcre2_pattern_info';'i * i *c'
