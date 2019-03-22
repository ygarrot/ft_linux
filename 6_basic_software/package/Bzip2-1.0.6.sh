# Apply a patch that will install the documentation for this package:

patch -Np1 -i ../bzip2-1.0.6-install_docs-1.patch
# The following command ensures installation of symbolic links are relative:

sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile
# Ensure the man pages are installed into the correct location:

sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile
# Prepare Bzip2 for compilation with:

make -f Makefile-libbz2_so
make clean
# The meaning of the make parameter:

-f Makefile-libbz2_so
# This will cause Bzip2 to be built using a different Makefile file, in this case the Makefile-libbz2_so file, which creates a dynamic libbz2.so library and links the Bzip2 utilities against it.

# Compile and test the package:

make
# Install the programs:

make PREFIX=/usr install
# Install the shared bzip2 binary into the /bin directory, make some necessary symbolic links, and clean up:

cp -v bzip2-shared /bin/bzip2
cp -av libbz2.so* /lib
ln -sv ../../lib/libbz2.so.1.0 /usr/lib/libbz2.so
rm -v /usr/bin/{bunzip2,bzcat,bzip2}
ln -sv bzip2 /bin/bunzip2
ln -sv bzip2 /bin/bzcat

