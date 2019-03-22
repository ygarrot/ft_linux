#!/bin/bash
# First, make some fixes required by glibc-2.28:

sed -i 's/IO_ftrylockfile/IO_EOF_SEEN/' lib/*.c
echo "#define _IO_IN_BACKUP 0x100" >> lib/stdio-impl.h
# Prepare M4 for compilation:

./configure --prefix=/usr
# Compile the package:

make
# To test the results, issue:

[ "$TESTING" == "True" ] && make check
# Install the package:

make install
