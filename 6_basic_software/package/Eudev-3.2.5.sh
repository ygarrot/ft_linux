#!/bin/bash
# Next, add a workaround to prevent the /tools directory from being hard coded into Eudev binary files library locations:

cat > config.cache << "EOF"
HAVE_BLKID=1
BLKID_LIBS="-lblkid"
BLKID_CFLAGS="-I/tools/include"
EOF
# Prepare Eudev for compilation:

./configure --prefix=/usr           \
            --bindir=/sbin          \
            --sbindir=/sbin         \
            --libdir=/usr/lib       \
            --sysconfdir=/etc       \
            --libexecdir=/lib       \
            --with-rootprefix=      \
            --with-rootlibdir=/lib  \
            --enable-manpages       \
            --disable-static        \
            --config-cache
# Compile the package:

LIBRARY_PATH=/tools/lib make
# [Note] Note
# The LIBRARY_PATH variable here and the LD_LIBRARY_PATH variable below are needed to allow the use of libraries that were installed in /tools, but have not yet been installed in the main system. LIBRARY_PATH is used to find libraries during the linking process. LD_LIBRARY_PATH is used to find libraries during program execution.

# Create some directories now that are needed for tests, but will also be used as a part of installation:

mkdir -pv /lib/udev/rules.d
mkdir -pv /etc/udev/rules.d
# To test the results, issue:

make LD_LIBRARY_PATH=/tools/lib check
# Install the package:

make LD_LIBRARY_PATH=/tools/lib install
# Install some custom rules and support files useful in an LFS environment:

tar -xvf ../udev-lfs-20171102.tar.bz2
make -f udev-lfs-20171102/Makefile.lfs install
# 6.72.2. Configuring Eudev
# Information about hardware devices is maintained in the /etc/udev/hwdb.d and /lib/udev/hwdb.d directories. Eudev needs that information to be compiled into a binary database /etc/udev/hwdb.bin. Create the initial database:

LD_LIBRARY_PATH=/tools/lib udevadm hwdb --update
# This command needs to be run each time the hardware information is updated.
