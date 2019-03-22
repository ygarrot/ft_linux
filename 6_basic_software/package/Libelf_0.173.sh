#!/bin/bash
# Libelf is part of elfutils-0.173 package. Use the elfutils-0.173.tar.xz as the source tarball.

# Prepare Libelf for compilation:

./configure --prefix=/usr
# Compile the package:

make
# To test the results, issue:

[ "$TESTING" == "True" ] && make check
# Install only Libelf:

make -C libelf install
install -vm644 config/libelf.pc /usr/lib/pkgconfig
