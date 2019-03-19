# Prepare GRUB for compilation:

./configure --prefix=/usr          \
            --sbindir=/sbin        \
            --sysconfdir=/etc      \
            --disable-efiemu       \
            --disable-werror
# # The meaning of the new configure options:

# --disable-werror
# This allows the build to complete with warnings introduced by more recent Flex versions.

# --disable-efiemu
# This option minimizes what is built by disabling a feature and testing programs not needed for LFS.

# Compile the package:

make
# This package does not come with a test suite.

# Install the package:

make install
# Using GRUB to make your LFS system bootable will be discussed in Section 8.4, “Using GRUB to Set Up the Boot Process”.
