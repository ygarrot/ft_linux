#!/bin/bash
# The E2fsprogs documentation recommends that the package be built in a subdirectory of the source tree:

mkdir -v build
cd build
# Prepare E2fsprogs for compilation:

../configure --prefix=/usr           \
             --bindir=/bin           \
             --with-root-prefix=""   \
             --enable-elf-shlibs     \
             --disable-libblkid      \
             --disable-libuuid       \
             --disable-uuidd         \
             --disable-fsck
# The meaning of the environment variable and configure options:

# --with-root-prefix="" and --bindir=/bin
# Certain programs (such as the e2fsck program) are considered essential programs. When, for example, /usr is not mounted, these programs still need to be available. They belong in directories like /lib and /sbin. If this option is not passed to E2fsprogs' configure, the programs are installed into the /usr directory.

# --enable-elf-shlibs
# This creates the shared libraries which some programs in this package use.

# --disable-*
# This prevents E2fsprogs from building and installing the libuuid and libblkid libraries, the uuidd daemon, and the fsck wrapper, as Util-Linux installs more recent versions.

# Compile the package:

make
# To set up and run the test suite we need to first link some libraries from /tools/lib to a location where the test programs look. To run the tests, issue:

ln -sfv /tools/lib/lib{blk,uu}id.so.1 lib
make LD_LIBRARY_PATH=/tools/lib check
# One of the E2fsprogs tests will attempt to allocate 256 MB of memory. If you do not have significantly more RAM than this, be sure to enable sufficient swap space for the test. See Section 2.5, “Creating a File System on the Partition” and Section 2.7, “Mounting the New Partition” for details on creating and enabling swap space. Two tests, f_bigalloc_badinode and f_bigalloc_orphan_list, are known ot fail.

# Install the binaries, documentation, and shared libraries:

make install
# Install the static libraries and headers:

make install-libs
# Make the installed static libraries writable so debugging symbols can be removed later:

chmod -v u+w /usr/lib/{libcom_err,libe2p,libext2fs,libss}.a
# This package installs a gzipped .info file but doesn't update the system-wide dir file. Unzip this file and then update the system dir file using the following commands:

gunzip -v /usr/share/info/libext2fs.info.gz
install-info --dir-file=/usr/share/info/dir /usr/share/info/libext2fs.info
# If desired, create and install some additional documentation by issuing the following commands:

makeinfo -o      doc/com_err.info ../lib/et/com_err.texinfo
install -v -m644 doc/com_err.info /usr/share/info
install-info --dir-file=/usr/share/info/dir /usr/share/info/com_err.info
