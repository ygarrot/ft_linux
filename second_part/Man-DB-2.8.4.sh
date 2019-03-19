# Prepare Man-DB for compilation:

./configure --prefix=/usr                        \
            --docdir=/usr/share/doc/man-db-2.8.4 \
            --sysconfdir=/etc                    \
            --disable-setuid                     \
            --enable-cache-owner=bin             \
            --with-browser=/usr/bin/lynx         \
            --with-vgrind=/usr/bin/vgrind        \
            --with-grap=/usr/bin/grap            \
            --with-systemdtmpfilesdir=
# The meaning of the configure options:

# --disable-setuid
# This disables making the man program setuid to user man.

# --enable-cache-owner=bin
# This makes the system-wide cache files be owned by user bin.

# --with-...
# These three parameters are used to set some default programs. lynx is a text-based web browser (see BLFS for installation instructions), vgrind converts program sources to Groff input, and grap is useful for typesetting graphs in Groff documents. The vgrind and grap programs are not normally needed for viewing manual pages. They are not part of LFS or BLFS, but you should be able to install them yourself after finishing LFS if you wish to do so.

# Compile the package:

make
# To test the results, issue:

make check
# Install the package:

make install
