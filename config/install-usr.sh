#!/bin/sh

echo "this script will install j system on /usr"

[ "Linux" = "$(uname)" ] || [ "Darwin" = "$(uname)" ] || { echo "$(uname) not supported" ; exit 1; }

if [ "$(uname -m)" = "x86_64" ] ; then
 cpu="x86_64"
elif [ "$(uname -m)" = "i386" ] || [ "$(uname -m)" = "i686" ] ; then
 cpu="i686"
elif [ "$(uname -m)" = "aarch64" ] || [ "$(uname -m)" = "arm64" ] ; then
 cpu="arm64"
elif [ "$(uname -m)" = "armv6l" ] ; then
 cpu="arm32"
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
VEXT=9.04.dylib
if [ "arm64" = "$cpu" ]; then
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
VEXT=so.9.04
BIN=/usr/bin
ETC=/etc
SHR=/usr/share
if [ "arm64" = "$cpu" ]; then
 LIB=/usr/lib/aarch64-linux-gnu
elif [ "arm32" = "$cpu" ]; then
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
fi
mkdir -p $SHR/j/9.04/addons/ide || { echo "can not create directory" ; exit 1; }
chmod 755 $SHR/j || { echo "can not set permission" ; exit 1; }
mkdir -p $ETC/j/9.04 || { echo "can not create directory" ; exit 1; }
chmod 755 $ETC/j || { echo "can not set permission" ; exit 1; }
rm -rf $SHR/j/9.04/system
cp -r ../system $SHR/j/9.04/.
rm -rf $SHR/j/9.04/tools
cp -r ../tools $SHR/j/9.04/.
rm -rf $SHR/j/9.04/icons
cp -r icons $SHR/j/9.04/.
rm -rf $SHR/j/9.04/addons/ide/jhs
cp -r ../addons/ide/jhs $SHR/j/9.04/addons/ide/.
find $SHR/j/9.04 -type d -exec chmod a+rx {} \+
find $SHR/j/9.04 -type f -exec chmod a+r {} \+
cp profile.ijs $ETC/j/9.04/.
cp profilex_template.ijs $ETC/j/9.04/.
find $ETC/j/9.04 -type d -exec chmod a+rx {} \+
find $ETC/j/9.04 -type f -exec chmod a+r {} \+
echo "#!/bin/sh" > ijconsole.sh
echo "cd ~ && $BIN/ijconsole \"$@\"" >> ijconsole.sh
mv ijconsole.sh $BIN/.
chmod 755 $BIN/ijconsole.sh
if [ -f "$BIN/ijconsole-9.04" ] ; then
mv "$BIN/ijconsole-9.04" /tmp/ijconsole-9.04.old
fi
cp jconsole $BIN/ijconsole-9.04
chmod 755 $BIN/ijconsole-9.04
if [ -f "$BIN/ijconsole" ] ; then
mv "$BIN/ijconsole" /tmp/ijconsole.old
fi
if [ "Linux" = "$(uname)" ]; then
update-alternatives --install $BIN/ijconsole ijconsole $BIN/ijconsole-9.04 904
else
(cd $BIN && ln -sf ijconsole-9.04 ijconsole)
fi

if [ -d "$LIB" ] ; then
if [ -f "$LIB/libj.$VEXT" ] ; then
mv "$LIB/libj.$VEXT" /tmp/libj.$VEXT.old
fi
cp libj.$EXT "$LIB/libj.$VEXT"
chmod 755 "$LIB/libj.$VEXT"
fi

if [ "Linux" = "$(uname)" ]; then
ldconfig
fi

echo "done"
