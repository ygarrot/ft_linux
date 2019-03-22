#!/bin/bash
# Modify the Makefile to install headers into the standard /usr/include directory instead of /usr/lib/libffi-3.2.1/include.

sed -e '/^includesdir/ s/$(libdir).*$/$(includedir)/' \
    -i include/Makefile.in

sed -e '/^includedir/ s/=.*$/=@includedir@/' \
    -e 's/^Cflags: -I${includedir}/Cflags:/' \
    -i libffi.pc.in
# Prepare libffi for compilation:

./configure --prefix=/usr --disable-static --with-gcc-arch=native
# The meaning of the configure option:

# --with-gcc-arch=native
# Ensure gcc optimizes for the current system. If this is not specified, the system is guessed and the code generated may not be correct for some systems. If the generated code will be copied from the native system to a less capable system, use the less capable system as a parameter. For details about alternative system types, see the x86 options in the gcc manual.

# Compile the package:

make
# To test the results, issue:

[ "$TESTING" == "True" ] && make check
# Install the package:

make install
