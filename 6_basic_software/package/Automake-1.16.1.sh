#!/bin/bash
# Prepare Automake for compilation:

./configure --prefix=/usr --docdir=/usr/share/doc/automake-1.16.1
# Compile the package:

make
# Using the -j4 make option speeds up the tests, even on systems with only one processor, due to internal delays in individual tests. To test the results, issue:

make -j4 check
# One test is known to fail in the LFS environment: subobj.sh.

# Install the package:

make install
