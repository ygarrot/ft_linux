#!/bin/bash
# 6.73.1. FHS compliance notes
# The FHS recommends using the /var/lib/hwclock directory instead of the usual /etc directory as the location for the adjtime file. First create a directory to enable storage for the hwclock program:

mkdir -pv /var/lib/hwclock
# 6.73.2. Installation of Util-linux
# Remove the earlier created symlinks:

rm -vf /usr/include/{blkid,libmount,uuid}
# Prepare Util-linux for compilation:

./configure ADJTIME_PATH=/var/lib/hwclock/adjtime   \
            --docdir=/usr/share/doc/util-linux-2.32.1 \
            --disable-chfn-chsh  \
            --disable-login      \
            --disable-nologin    \
            --disable-su         \
            --disable-setpriv    \
            --disable-runuser    \
            --disable-pylibmount \
            --disable-static     \
            --without-python     \
            --without-systemd    \
            --without-systemdsystemunitdir
# The --disable and --without options prevent warnings about building components that require packages not in LFS or are inconsistent with programs installed by other packages.

# Compile the package:

make
# If desired, run the test suite as a non-root user:

# [Warning] Warning
# Running the test suite as the root user can be harmful to your system. To run it, the CONFIG_SCSI_DEBUG option for the kernel must be available in the currently running system, and must be built as a module. Building it into the kernel will prevent booting. For complete coverage, other BLFS packages must be installed. If desired, this test can be run after rebooting into the completed LFS system and running:

bash tests/run.sh --srcdir=$PWD --builddir=$PWD
chown -Rv nobody .
su nobody -s /bin/bash -c "PATH=$PATH make -k check"
# Install the package:

make install
