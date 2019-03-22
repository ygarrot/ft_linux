# Prevent a static library from being installed:

sed -i '/install.*STALIBNAME/d' libcap/Makefile
# Compile the package:

make
# This package does not come with a test suite.

# Install the package:

make RAISE_SETFCAP=no lib=lib prefix=/usr install
chmod -v 755 /usr/lib/libcap.so
# The meaning of the make option:

RAISE_SETFCAP=no
# This parameter skips trying to use setcap on itself. This avoids an installation error if the kernel or file system does not support extended capabilities.

lib=lib
# This parameter installs the library in $prefix/lib rather than $prefix/lib64 on x86_64. It has no effect on x86.

# The shared library needs to be moved to /lib, and as a result the .so file in /usr/lib will need to be recreated:

mv -v /usr/lib/libcap.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libcap.so) /usr/lib/libcap.so
