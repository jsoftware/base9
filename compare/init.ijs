NB. comparison utilities
NB.
NB. This has utilities to compare character data and files.
NB.
NB. main definitions:
NB.   compare v compare character data
NB.   fcompare v compare two text files
NB.   fcompares v compare two text files as strings
NB.               (i.e. ignoring different line separators)
NB.   fcomparew v compare two text files as strings and
NB.               ignore leading/trailing whitespace
NB.
NB.*compare v compare character data
NB.
NB. form: text1 compare text2
NB. arguments may be character strings, with lines delimited
NB. by LF, or character matrices (trailing blanks ignored).
NB. for Mac, tolerates lines delimited by CR.
NB.
NB. result shows lines not matched, in form:
NB.    n [l] text
NB.
NB. where:
NB.    n    =  0=left argument, 1=right argument
NB.   [l]   =  line number
NB.   text  =  text on line
NB.
NB.*fcompare v compare two text files
NB.
NB. form: opt fcompare files
NB.   opt is optional suffix
NB.   files is 2 file names or prefixes
NB.
NB. files as character string is cut on blanks
NB.
NB. example:
NB.
NB.   fcompare jpath '~system/main/myutil.ijs /jbak/system/main/myutil.ijs'
NB.   '/myutil.ijs' fcompare jpath '~system/main';'/jbak/system/main'
NB.
NB.*fcompares v compare two text files as strings

coclass 'jcompare'

MAXPFX=: 100        NB. max length of prefix test
MAXLCS=: *: MAXPFX  NB. max table size for lcs test
