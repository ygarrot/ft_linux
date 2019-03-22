#!/bin/bash
# Prepare Texinfo for compilation:

./configure --prefix=/tools
# [Note] Note
# As part of the configure process, a test is made that indicates an error for TestXS_la-TestXS.lo. This is not relevant for LFS and should be ignored.

# Compile the package:

make
# Compilation is now complete. As discussed earlier, running the test suite is not mandatory for the temporary tools here in this chapter. To run the Texinfo test suite anyway, issue the following command:

make check
# Install the package:

make install
