#!/bin/bash
# Prepare Psmisc for compilation:

./configure --prefix=/usr
# Compile the package:

make
# This package does not come with a test suite.

# Install the package:

make install
# Finally, move the killall and fuser programs to the location specified by the FHS:

mv -v /usr/bin/fuser   /bin
mv -v /usr/bin/killall /bin
