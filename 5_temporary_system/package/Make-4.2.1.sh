#!/bin/bash
# First, work around an error caused by glibc-2.27:

sed -i '211,217 d; 219,229 d; 232 d' glob/glob.c
# Prepare Make for compilation:

./configure --prefix=/tools --without-guile
# The meaning of the configure option:

# --without-guile
# This ensures that Make-4.2.1 won't link against Guile libraries, which may be present on the host system, but won't be available within the chroot environment in the next chapter.

# Compile the package:

make
# Compilation is now complete. As discussed earlier, running the test suite is not mandatory for the temporary tools here in this chapter. To run the Make test suite anyway, issue the following command:

[ "$TESTING" == "True" ] && make check
# Install the package:

make install

