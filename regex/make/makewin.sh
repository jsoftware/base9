#!/bin/bash
#
# build w64 and w32 pcre2.dll
#
# run after makelinux (uses same config)

# set these first:
R=~/j9/tools/regex
S=~/svn/pcre2
# ----------------

rm -f $R/*.dll

cd $S/src

build() {
rm -f *.a
rm -f *.o
for f in auto_possess chartables compile config context convert \
 dfa_match error extuni find_bracket jit_compile maketables \
 match match_data newline ord2utf pattern_info serialize \
 string_utils study substitute substring tables ucd valid_utf xclass ; do
 $CC -c -I. -DPCRE2_CODE_UNIT_WIDTH=8 -DHAVE_CONFIG_H pcre2_${f}.c -o pcre2_${f}.o;
done
$CC -shared -static-libgcc *.o -o $S
}

CC="x86_64-w64-mingw32-gcc -m64"
S=jpcre2.dll
build
mv $S $R

CC="i686-w64-mingw32-gcc -m32"
S=jpcre2_32.dll
build
mv $S $R

chmod 644 $R/*
ls -l $R
