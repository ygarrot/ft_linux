#!/bin/bash
# Prepare Bison for compilation:

./configure --prefix=/tools
# Compile the package:

make
# To test the results, issue:

[ "$TESTING" == "True" ] && make check
# Install the package:

make install
