#!/bin/sh

echo "this script will install j system on /usr"

[ "Linux" = "$(uname)" ] || { echo "$(uname) not supported" ; exit 1; }

if [ "$(uname -m)" = "x86_64" ] ; then
 cpu="intel64"
else
 if [ "$(uname -m)" = "i386" ] || [ "$(uname -m)" = "i686" ] ; then
  cpu="intel32"
 else
  if [ "$(uname -m)" = "aarch64" ] ; then
   cpu="arm64"
  else
   if [ "$(uname -m)" = "armv6l" ] ; then
    cpu="arm32"
   else
    echo "platform $(uname -m) not supported"
    exit 1
   fi
  fi
 fi
fi

cd ..
[ "j901" = ${PWD##*/} ] || { echo "directory not j901" ; exit 1; }
cd -

[ "$(id -u)" = "0" ] || { echo "need sudo" ; exit 1; }

mkdir -p /usr/share/j/9.01/addons/ide || { echo "can not create directory" ; exit 1; }
chmod 755 /usr/share/j || { echo "can not set permission" ; exit 1; }
mkdir -p /etc/j/9.01 || { echo "can not create directory" ; exit 1; }
chmod 755 /etc/j || { echo "can not set permission" ; exit 1; }
rm -rf /usr/share/j/9.01/system
cp -r ../system /usr/share/j/9.01/.
rm -rf /usr/share/j/9.01/tools
cp -r ../tools /usr/share/j/9.01/.
rm -rf /usr/share/j/9.01/icons
cp -r icons /usr/share/j/9.01/.
rm -rf /usr/share/j/9.01/addons/ide/jhs
cp -r ../addons/ide/jhs /usr/share/j/9.01/addons/ide/.
find /usr/share/j/9.01 -type d -exec chmod a+rx {} \+
find /usr/share/j/9.01 -type f -exec chmod a+r {} \+
cp profile.ijs /etc/j/9.01/.
cp profilex_template.ijs /etc/j/9.01/.
find /etc/j/9.01 -type d -exec chmod a+rx {} \+
find /etc/j/9.01 -type f -exec chmod a+r {} \+
echo "#!/bin/bash" > ijconsole.sh
echo "cd ~ && /usr/bin/ijconsole \"$@\"" >> ijconsole.sh
mv ijconsole.sh /usr/bin/.
chmod 755 /usr/bin/ijconsole.sh
cp jconsole /usr/bin/ijconsole-9.01
chmod 755 /usr/bin/ijconsole-9.01
rm -f /usr/bin/ijconsole
update-alternatives --install /usr/bin/ijconsole ijconsole /usr/bin/ijconsole-9.01 901
# (cd /usr/bin && ln -sf ijconsole-9.01 ijconsole)

if [ "$cpu" = "intel64" ] ; then
 if [ -d "/usr/lib/x86_64-linux-gnu" ] ; then
  cp libj.so /usr/lib/x86_64-linux-gnu/libj.so.9.01
  chmod 755 /usr/lib/x86_64-linux-gnu/libj.so.9.01
 else
  if [ -d "/usr/lib64" ] ; then
   cp libj.so /usr/lib64/libj.so.9.01
   chmod 755 /usr/lib64/libj.so.9.01
  else
   echo "can not find lib directory"
   exit 1
  fi
 fi
fi
if [ "$cpu" = "arm64" ] ; then
 if [ -d "/usr/lib/aarch64-linux-gnu" ] ; then
  cp libj.so /usr/lib/aarch64-linux-gnu/libj.so.9.01
  chmod 755 /usr/lib/aarch64-linux-gnu/libj.so.9.01
 else
  if [ -d "/usr/lib64" ] ; then
   cp libj.so /usr/lib64/libj.so.9.01
   chmod 755 /usr/lib64/libj.so.9.01
  else
   echo "can not find lib directory"
   exit 1
  fi
 fi
fi
if [ "$cpu" = "intel32" ] ; then
 if [ -d "/usr/lib/i386-linux-gnu" ] ; then
  cp libj.so /usr/lib/i386-linux-gnu/libj.so.9.01
  chmod 755 /usr/lib/i386-linux-gnu/libj.so.9.01
 else
  if [ -d "/usr/lib" ] ; then
   cp libj.so /usr/lib/libj.so.9.01
   chmod 755 /usr/lib/libj.so.9.01
  else
   echo "can not find lib directory"
   exit 1
  fi
 fi
fi
if [ "$cpu" = "arm32" ] ; then
 if [ -d "/usr/lib/arm-linux-gnueabihf" ] ; then
  cp libj.so /usr/lib/arm-linux-gnueabihf/libj.so.9.01
  chmod 755 /usr/lib/arm-linux-gnueabihf/libj.so.9.01
 else
  if [ -d "/usr/lib" ] ; then
   cp libj.so /usr/lib/libj.so.9.01
   chmod 755 /usr/lib/libj.so.9.01
  else
   echo "can not find lib directory"
   exit 1
  fi
 fi
fi
ldconfig
echo "done"
