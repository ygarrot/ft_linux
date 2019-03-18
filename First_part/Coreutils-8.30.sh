# Prepare Coreutils for compilation:

./configure --prefix=/tools --enable-install-program=hostname
# The meaning of the configure options:

--enable-install-program=hostname
# This enables the hostname binary to be built and installed – it is disabled by default but is required by the Perl test suite.

# Compile the package:

make
# Compilation is now complete. As discussed earlier, running the test suite is not mandatory for the temporary tools here in this chapter. To run the Coreutils test suite anyway, issue the following command:

make RUN_EXPENSIVE_TESTS=yes check
# The RUN_EXPENSIVE_TESTS=yes parameter tells the test suite to run several additional tests that are considered relatively expensive (in terms of CPU power and memory usage) on some platforms, but generally are not a problem on Linux.

# Install the package:

make install
