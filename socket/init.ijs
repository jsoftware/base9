NB. init

coclass <'jsocket'
coinsert 'jsocket jdefs'

jsystemdefs 'hostdefs'
jsystemdefs 'netdefs'

NB. asserts for assumptions that make for simpler, streamlined code
3 : 0''
assert. INADDR_ANY=0
assert. sockaddr_sz=16
if. IFUNIX do.
  assert. fds_bits_off=0
end.
)
