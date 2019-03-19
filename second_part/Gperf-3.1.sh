# Prepare Gperf for compilation:

./configure --prefix=/usr --docdir=/usr/share/doc/gperf-3.1
# Compile the package:

make
# The tests are known to fail if running multiple simultaneous tests (-j option greater than 1). To test the results, issue:

make -j1 check
# Install the package:

make install
