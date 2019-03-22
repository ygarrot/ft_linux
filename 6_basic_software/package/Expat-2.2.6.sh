# First fix a problem with the regression tests in the LFS environment:

sed -i 's|usr/bin/env |bin/|' run.sh.in
# Prepare Expat for compilation:

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/expat-2.2.6
# Compile the package:

make
# To test the results, issue:

[ "$TESTING" == "True" ] && make check
# Install the package:

make install
# If desired, install the documentation:

install -v -m644 doc/*.{html,png,css} /usr/share/doc/expat-2.2.6
