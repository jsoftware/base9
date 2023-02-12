#!/bin/sh
set -e

echo "this script will install j system on /usr"

[ "Linux" = "$(uname)" ] || "OpenBSD" = "$(uname)" ] || "FreeBSD" = "$(uname)" ] || [ "Darwin" = "$(uname)" ] || { echo "$(uname) not supported" ; exit 1; }

if [ "$(uname -m)" = "x86_64" ] || [ "$(uname -m)" = "amd64" ] ; then
 cpu="x86_64"
elif [ "$(uname -m)" = "i386" ] || [ "$(uname -m)" = "i686" ] ; then
 cpu="i686"
elif [ "$(uname -m)" = "aarch64" ] || [ "$(uname -m)" = "arm64" ] ; then
 cpu="aarch64"
elif [ "$(uname -m)" = "armv6l" ] ; then
 cpu="arm"
else
 echo "platform $(uname -m) not supported"
 exit 1
fi

cd ..
[ "j904" = ${PWD##*/} ] || { echo "directory not j904" ; exit 1; }
cd -

[ "Darwin" = "$(uname)" ] || [ "$(id -u)" = "0" ] || { echo "need sudo" ; exit 1; }

if [ "Darwin" = "$(uname)" ]; then
EXT=dylib
VEXT=9.4.dylib
GEXT=dylib
if [ "aarch64" = "$cpu" ]; then
 BIN=/opt/homebrew/bin
 ETC=/opt/homebrew/etc
 SHR=/opt/homebrew/share
 LIB=/opt/homebrew/lib
else
 BIN=/usr/local/bin
 ETC=/usr/local/etc
 SHR=/usr/local/share
 LIB=/usr/local/lib
fi
else
EXT=so
VEXT=so.9.4
GEXT=so.10
if [ "Linux" = "$(uname)" ]; then
# Linux Raspberry
BIN=/usr/bin
ETC=/etc
SHR=/usr/share
if [ "aarch64" = "$cpu" ]; then
 LIB=/usr/lib/aarch64-linux-gnu
elif [ "arm" = "$cpu" ]; then
 LIB=/usr/lib/arm-linux-gnueabihf
elif [ "x86_64" = "$cpu" ]; then
 if [ -d /usr/lib/x86_64-linux-gnu ]; then
 LIB=/usr/lib/x86_64-linux-gnu
 elif [ -d /usr/lib64 ]; then
 LIB=/usr/lib64
 else
 LIB=/usr/lib
 fi
else
 if [ -d /usr/lib/i686-linux-gnu ]; then
 LIB=/usr/lib/i686-linux-gnu
 else
 LIB=/usr/lib
 fi
fi
else
# OpenBSD FreeBSD
BIN=/usr/local/bin
ETC=/usr/local/etc
SHR=/usr/local/share
LIB=/usr/local/lib
fi

fi
mkdir -p $SHR/j/9.4/addons/ide || { echo "can not create directory" ; exit 1; }
chmod 755 $SHR/j || { echo "can not set permission" ; exit 1; }
mkdir -p $ETC/j/9.4 || { echo "can not create directory" ; exit 1; }
chmod 755 $ETC/j || { echo "can not set permission" ; exit 1; }
rm -rf $SHR/j/9.4/system
cp -r ../system $SHR/j/9.4/.
rm -rf $SHR/j/9.4/tools
cp -r ../tools $SHR/j/9.4/.
rm -rf $SHR/j/9.4/icons
cp -r icons $SHR/j/9.4/.
rm -rf $SHR/j/9.4/addons/ide/jhs
cp -r ../addons/ide/jhs $SHR/j/9.4/addons/ide/.
find $SHR/j/9.4 -type d -exec chmod a+rx {} \+
find $SHR/j/9.4 -type f -exec chmod a+r {} \+
cp profile.ijs $ETC/j/9.4/.
cp profilex_template.ijs $ETC/j/9.4/.
find $ETC/j/9.4 -type d -exec chmod a+rx {} \+
find $ETC/j/9.4 -type f -exec chmod a+r {} \+
echo "#!/bin/sh" > ijconsole.sh
echo "cd ~ && $BIN/ijconsole \"$@\"" >> ijconsole.sh
mv ijconsole.sh $BIN/.
chmod 755 $BIN/ijconsole.sh
if [ -f "$BIN/ijconsole-9.4" ] ; then
mv "$BIN/ijconsole-9.4" /tmp/ijconsole-9.4.old.$$
fi
cp jconsole $BIN/ijconsole-9.4
chmod 755 $BIN/ijconsole-9.4
if [ -f "$BIN/ijconsole" ] ; then
mv "$BIN/ijconsole" /tmp/ijconsole.old.$$
fi
if [ "Linux" = "$(uname)" ]; then
update-alternatives --install $BIN/ijconsole ijconsole $BIN/ijconsole-9.4 904
else
(cd $BIN && ln -sf ijconsole-9.4 ijconsole)
fi

if [ -d "$LIB" ] ; then
if [ -f "$LIB/libj.$VEXT" ] ; then
mv "$LIB/libj.$VEXT" /tmp/libj.$VEXT.old.$$
fi
cp libj.$EXT "$LIB/libj.$VEXT"
chmod 755 "$LIB/libj.$VEXT"
if [ -f "$LIB/libjgmp.$GEXT" ] ; then
mv "$LIB/libjgmp.$GEXT" /tmp/libjgmp.$GEXT.old.$$
fi
cp libgmp.$GEXT "$LIB/libjgmp.$GEXT"
chmod 755 "$LIB/libjgmp.$GEXT"
fi

if [ "Darwin" != "$(uname)" ]; then
/sbin/ldconfig
fi

echo "done"
