#!/bin/bash
# [Note] Note
# Libstdc++ is part of the GCC sources. You should first unpack the GCC tarball and change to the gcc-8.2.0 directory.

# Create a separate build directory for Libstdc++ and enter it:

mkdir -v build
cd       build
# Prepare Libstdc++ for compilation:

../libstdc++-v3/configure           \
    --host=$LFS_TGT                 \
    --prefix=/tools                 \
    --disable-multilib              \
    --disable-nls                   \
    --disable-libstdcxx-threads     \
    --disable-libstdcxx-pch         \
    --with-gxx-include-dir=/tools/$LFS_TGT/include/c++/8.2.0
# The meaning of the configure options:

# --host=...
# Indicates to use the cross compiler we have just built instead of the one in /usr/bin.

# --disable-libstdcxx-threads
# Since we have not yet built the C threads library, the C++ one cannot be built either.

# --disable-libstdcxx-pch
# This switch prevents the installation of precompiled include files, which are not needed at this stage.

# --with-gxx-include-dir=/tools/$LFS_TGT/include/c++/8.2.0
# This is the location where the standard include files are searched by the C++ compiler. In a normal build, this information is automatically passed to the Libstdc++ configure options from the top level directory. In our case, this information must be explicitly given.

# Compile libstdc++ by running:

make
# Install the library:

make install
