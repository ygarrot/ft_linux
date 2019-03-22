#!/bin/bash
# First, apply a patch that removes several programs installed by other packages, clarifies a message, and fixes a compiler warning:

patch -Np1 -i ../sysvinit-2.90-consolidated-1.patch
# Compile the package:

make -C src
# This package does not come with a test suite.

# Install the package:

make -C src install
