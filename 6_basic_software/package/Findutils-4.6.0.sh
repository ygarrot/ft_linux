#!/bin/bash
# First, suppress a test which on some machines can loop forever:

sed -i 's/test-lock..EXEEXT.//' tests/Makefile.in
# Next, make some fixes required by glibc-2.28:

sed -i 's/IO_ftrylockfile/IO_EOF_SEEN/' gl/lib/*.c
sed -i '/unistd/a #include <sys/sysmacros.h>' gl/lib/mountlist.c
echo "#define _IO_IN_BACKUP 0x100" >> gl/lib/stdio-impl.h
# Prepare Findutils for compilation:

./configure --prefix=/usr --localstatedir=/var/lib/locate
# The meaning of the configure options:

# --localstatedir
# This option changes the location of the locate database to be in /var/lib/locate, which is FHS-compliant.

# # Compile the package:

make
# To test the results, issue:

[ "$TESTING" == "True" ] && make check
# Install the package:

make install
# Some of the scripts in the LFS-Bootscripts package depend on find. As /usr may not be available during the early stages of booting, this program needs to be on the root partition. The updatedb script also needs to be modified to correct an explicit path:

mv -v /usr/bin/find /bin
sed -i 's|find:=${BINDIR}|find:=/bin|' /usr/bin/updatedb
