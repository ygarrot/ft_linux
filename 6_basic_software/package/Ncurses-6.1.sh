#!/bin/bash
# Don't install a static library that is not handled by configure:

sed -i '/LIBTOOL_INSTALL/d' c++/Makefile.in
# Prepare Ncurses for compilation:

./configure --prefix=/usr           \
            --mandir=/usr/share/man \
            --with-shared           \
            --without-debug         \
            --without-normal        \
            --enable-pc-files       \
            --enable-widec
# The meaning of the new configure options:

# --enable-widec
# This switch causes wide-character libraries (e.g., libncursesw.so.6.1) to be built instead of normal ones (e.g., libncurses.so.6.1). These wide-character libraries are usable in both multibyte and traditional 8-bit locales, while normal libraries work properly only in 8-bit locales. Wide-character and normal libraries are source-compatible, but not binary-compatible.

# --enable-pc-files
# This switch generates and installs .pc files for pkg-config.

# --without-normal
# This switch disables building and installing most static libraries.

# Compile the package:

make
# This package has a test suite, but it can only be run after the package has been installed. The tests reside in the test/ directory. See the README file in that directory for further details.

# Install the package:

make install
# Move the shared libraries to the /lib directory, where they are expected to reside:

mv -v /usr/lib/libncursesw.so.6* /lib
# Because the libraries have been moved, one symlink points to a non-existent file. Recreate it:

ln -sfv ../../lib/$(readlink /usr/lib/libncursesw.so) /usr/lib/libncursesw.so
# Many applications still expect the linker to be able to find non-wide-character Ncurses libraries. Trick such applications into linking with wide-character libraries by means of symlinks and linker scripts:

for lib in ncurses form panel menu ; do
    rm -vf                    /usr/lib/lib${lib}.so
    echo "INPUT(-l${lib}w)" > /usr/lib/lib${lib}.so
    ln -sfv ${lib}w.pc        /usr/lib/pkgconfig/${lib}.pc
done
# Finally, make sure that old applications that look for -lcurses at build time are still buildable:

rm -vf                     /usr/lib/libcursesw.so
echo "INPUT(-lncursesw)" > /usr/lib/libcursesw.so
ln -sfv libncurses.so      /usr/lib/libcurses.so
# If desired, install the Ncurses documentation:

mkdir -v       /usr/share/doc/ncurses-6.1
cp -v -R doc/* /usr/share/doc/ncurses-6.1
# [Note] Note
# The instructions above don't create non-wide-character Ncurses libraries since no package installed by compiling from sources would link against them at runtime. However, the only known binary-only applications that link against non-wide-character Ncurses libraries require version 5. If you must have such libraries because of some binary-only application or to be compliant with LSB, build the package again with the following commands:

make distclean
./configure --prefix=/usr    \
            --with-shared    \
            --without-normal \
            --without-debug  \
            --without-cxx-binding \
            --with-abi-version=5 
make sources libs
cp -av lib/lib*.so.5* /usr/lib
