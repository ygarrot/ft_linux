# Prepare Autoconf for compilation:

./configure --prefix=/usr
# Compile the package:

make
# To test the results, issue:

make check TESTSUITEFLAGS=-j4
# This takes a long time, about 3.5 SBUs. In addition, several tests are skipped that use Automake. For full test coverage, Autoconf can be re-tested after Automake has been installed. In addition, two tests fail due to changes in libtool-2.4.3 and later.

# [Note] Note
# The test time for autoconf can be reduced significantly on a system with multiple cores. To do this, append TESTSUITEFLAGS=-j<N> to the line above. For instance, using -j4 can reduce the test time by over 60 percent.

# Install the package:

make install
