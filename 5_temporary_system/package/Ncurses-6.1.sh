#!/bin/bash
# First, ensure that gawk is found first during configuration:

sed -i s/mawk// configure
# Prepare Ncurses for compilation:

./configure --prefix=/tools \
            --with-shared   \
            --without-debug \
            --without-ada   \
            --enable-widec  \
            --enable-overwrite
# The meaning of the configure options:

# --without-ada
# This ensures that Ncurses does not build support for the Ada compiler which may be present on the host but will not be available once we enter the chroot environment.

# --enable-overwrite
# This tells Ncurses to install its header files into /tools/include, instead of /tools/include/ncurses, to ensure that other packages can find the Ncurses headers successfully.

# --enable-widec
# This switch causes wide-character libraries (e.g., libncursesw.so.6.1) to be built instead of normal ones (e.g., libncurses.so.6.1). These wide-character libraries are usable in both multibyte and traditional 8-bit locales, while normal libraries work properly only in 8-bit locales. Wide-character and normal libraries are source-compatible, but not binary-compatible.

# Compile the package:

make
# This package has a test suite, but it can only be run after the package has been installed. The tests reside in the test/ directory. See the README file in that directory for further details.

# Install the package:

make install
