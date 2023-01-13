#!/bin/bash
#
# build l64 and l32 .so files

# set these first:
R=~/j9/tools/regex
S=~/svn/pcre2
# ----------------

rm -f $R/*.so
cd $S

build() {
rm -f src/*.o
./configure \
 --enable-pcre2-8 \
 --disable-pcre2-16 \
 --disable-pcre2-32 \
 --disable-debug \
 --disable-jit \
 --disable-static \
 --enable-bsr-anycrlf \
 --enable-newline-is-anycrlf
make
}

build
cp .libs/libpcre2-8.so.0.7.0 $R/libjpcre2.so

export CFLAGS+=" -m32"
build
cp .libs/libpcre2-8.so.0.7.0 $R/libjpcre2_32.so

chmod 644 $R/*
ls -l $R
