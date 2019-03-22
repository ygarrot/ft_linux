# Prepare Tar for compilation:

FORCE_UNSAFE_CONFIGURE=1  \
./configure --prefix=/usr \
            --bindir=/bin
# The meaning of the configure options:

# FORCE_UNSAFE_CONFIGURE=1
# This forces the test for mknod to be run as root. It is generally considered dangerous to run this test as the root user, but as it is being run on a system that has only been partially built, overriding it is OK.

# Compile the package:

make
# To test the results (about 3 SBU), issue:

[ "$TESTING" == "True" ] && make check
# One test, link mismatch, is known to fail.

# Install the package:

make install
make -C doc install-html docdir=/usr/share/doc/tar-1.30
