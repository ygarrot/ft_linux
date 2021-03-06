#!/bin/bash
# Prepare Sed for compilation:

./configure --prefix=/tools
# Compile the package:

make
# Compilation is now complete. As discussed earlier, running the test suite is not mandatory for the temporary tools here in this chapter. To run the Sed test suite anyway, issue the following command:

[ "$TESTING" == "True" ] && make check
# Install the package:

make install
