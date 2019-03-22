# Prepare Pkg-config for compilation:

./configure --prefix=/usr              \
            --with-internal-glib       \
            --disable-host-tool        \
            --docdir=/usr/share/doc/pkg-config-0.29.2
# The meaning of the new configure options:

# --with-internal-glib
# This will allow pkg-config to use its internal version of Glib because an external version is not available in LFS.

# --disable-host-tool
# This option disables the creation of an undesired hard link to the pkg-config program.

# Compile the package:

make
# To test the results, issue:

[ "$TESTING" == "True" ] && make check
# Install the package:

make install
