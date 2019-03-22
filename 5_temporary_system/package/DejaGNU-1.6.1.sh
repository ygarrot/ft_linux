#!/bin/bash
# Prepare DejaGNU for compilation:

./configure --prefix=/tools
# Build and install the package:

make install
# To test the results, issue:

make check
