#!/bin/bash
# Prepare Kmod for compilation:

./configure --prefix=/usr          \
            --bindir=/bin          \
            --sysconfdir=/etc      \
            --with-rootlibdir=/lib \
            --with-xz              \
            --with-zlib
# The meaning of the configure options:

# --with-xz, --with-zlib
# These options enable Kmod to handle compressed kernel modules.

# --with-rootlibdir=/lib
# This option ensures different library related files are placed in the correct directories.

# Compile the package:

make
# This package does not come with a test suite that can be run in the LFS chroot environment. At a minimum the git program is required and several tests will not run outside of a git repository.

# Install the package, and create symlinks for compatibility with Module-Init-Tools (the package that previously handled Linux kernel modules):

make install

for target in depmod insmod lsmod modinfo modprobe rmmod; do
  ln -sfv ../bin/kmod /sbin/$target
done

ln -sfv kmod /bin/lsmod
