#!/bin/bash
#
# build OSX .dylib file

# set these first:
R=~/j9/tools/regex
S=~/svn/pcre2
# ----------------

cd $S

rm -f $R/*.dylib src/*.o

./configure \
 --enable-pcre2-8 \
 --disable-pcre2-16 \
 --disable-pcre2-32 \
 --disable-debug \
 --disable-jit \
 --disable-unicode \
 --enable-bsr-anycrlf \
 --enable-newline-is-anycrlf \

make
cp .libs/libpcre2-8.0.dylib $R/libpcre2.dylib
chmod 644 $R/*
ls -l $R
