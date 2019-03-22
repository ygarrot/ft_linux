#!/bin/bash
# First, change an internal script to use sed instead of ed:

cat > bc/fix-libmath_h << "EOF"
#! /bin/bash
sed -e '1   s/^/{"/' \
    -e     's/$/",/' \
    -e '2,$ s/^/"/'  \
    -e   '$ d'       \
    -i libmath.h

sed -e '$ s/$/0}/' \
    -i libmath.h
EOF
# Create temporary symbolic links so the package can find the readline library and confirm that its required libncurses library is available. Even though the libraries are in /tools/lib at this point, the system will use /usr/lib at the end of this chapter.

ln -sv /tools/lib/libncursesw.so.6 /usr/lib/libncursesw.so.6
ln -sfv libncurses.so.6 /usr/lib/libncurses.so
# Fix an issue in configure due to missing files in the early stages of LFS:

sed -i -e '/flex/s/as_fn_error/: ;; # &/' configure
# Prepare Bc for compilation:

./configure --prefix=/usr           \
            --with-readline         \
            --mandir=/usr/share/man \
            --infodir=/usr/share/info
# # The meaning of the configure options:

# --with-readline
# # This option tells Bc to use the readline library that is already installed on the system rather than using its own readline version.

# Compile the package:

make
# To test bc, run the commands below. There is quite a bit of output, so you may want to redirect it to a file. There are a very small percentage of tests (10 of 12,144) that will indicate a round off error at the last digit.

echo "quit" | ./bc/bc -l Test/checklib.b
# Install the package:

make install
