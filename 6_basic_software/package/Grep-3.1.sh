#!/bin/bash
# Prepare Grep for compilation:

./configure --prefix=/usr --bindir=/bin
# Compile the package:

make
# To test the results, issue:

make -k check
# Install the package:

make install
