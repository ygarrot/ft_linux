#!/bin/bash
#re Util-linux for compilation:

./configure --prefix=/tools                \
            --without-python               \
            --disable-makeinstall-chown    \
            --without-systemdsystemunitdir \
            --without-ncurses              \
            PKG_CONFIG=""
# The meaning of the configure option:

# --without-python
# This switch disables using Python if it is installed on the host system. It avoids trying to build unneeded bindings.

# --disable-makeinstall-chown
# This switch disables using the chown command during installation. This is not needed when installing into the /tools directory and avoids the necessity of installing as root.

# --without-ncurses
# This switch disables using the ncurses library for the build process. This is not needed when installing into the /tools directory and avoids problems on some host distros.

# --without-systemdsystemunitdir
# On systems that use systemd, the package tries to install a systemd specific file to a non-existent directory in /tools. This switch disables the unnecessary action.

# PKG_CONFIG=""
# Setting this environment variable prevents adding unneeded features that may be available on the host. Note that the location shown for setting this environment variable is different from other LFS sections where variables are set preceding the command. This location is shown to demonstrate an alternative way of setting an environment variable when using configure.

# Compile the package:

make
# Install the package:

make install
