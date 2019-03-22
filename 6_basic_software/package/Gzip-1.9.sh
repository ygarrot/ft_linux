#!/bin/bash
# First, make some fixes required by glibc-2.28:

sed -i 's/IO_ftrylockfile/IO_EOF_SEEN/' lib/*.c
echo "#define _IO_IN_BACKUP 0x100" >> lib/stdio-impl.h
# Prepare Gzip for compilation:

./configure --prefix=/usr
# Compile the package:

make
# To test the results, issue:

[ "$TESTING" == "True" ] && make check
# Two tests are known to fail in the LFS environment: help-version and zmore.

# Install the package:

make install
# Move a program that needs to be on the root filesystem:

mv -v /usr/bin/gzip /bin
