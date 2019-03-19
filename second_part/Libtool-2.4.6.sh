# Prepare Libtool for compilation:

./configure --prefix=/usr
# Compile the package:

make
# To test the results (about 11.0 SBU), issue:

make check TESTSUITEFLAGS=-j4
# [Note] Note
# The test time for libtool can be reduced significantly on a system with multiple cores. To do this, append TESTSUITEFLAGS=-j<N> to the line above. For instance, using -j4 can reduce the test time by over 60 percent.

# Five tests are known to fail in the LFS build environment due to a circular dependency, but all tests pass if rechecked after automake is installed.

# Install the package:

make install 
