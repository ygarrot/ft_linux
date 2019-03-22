#!/bin/bash
# Prepare Patch for compilation:

./configure --prefix=/usr
# Compile the package:

make
# To test the results, issue:

[ "$TESTING" == "True" ] && make check
# Install the package:

make install
