#!/bin/bash
# First fix a warning that is caused by perl-5.22 and later:

sed -i 's:\\\${:\\\$\\{:' intltool-update.in
# Prepare Intltool for compilation:

./configure --prefix=/usr
# Compile the package:

make
# To test the results, issue:

[ "$TESTING" == "True" ] && make check
# Install the package:

make install
install -v -Dm644 doc/I18N-HOWTO /usr/share/doc/intltool-0.51.0/I18N-HOWTO
