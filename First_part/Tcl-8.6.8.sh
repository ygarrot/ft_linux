# This package and the next two (Expect and DejaGNU) are installed to support running the test suites for GCC and Binutils and other packages. Installing three packages for testing purposes may seem excessive, but it is very reassuring, if not essential, to know that the most important tools are working properly. Even if the test suites are not run in this chapter (they are not mandatory), these packages are required to run the test suites in Chapter 6.

# Note that the Tcl package used here is a minimal version needed to run the LFS tests. For the full package, see the BLFS Tcl procedures.

# Prepare Tcl for compilation:

cd unix
./configure --prefix=/tools
# Build the package:

make
# Compilation is now complete. As discussed earlier, running the test suite is not mandatory for the temporary tools here in this chapter. To run the Tcl test suite anyway, issue the following command:

TZ=UTC make test
# The Tcl test suite may experience failures under certain host conditions that are not fully understood. Therefore, test suite failures here are not surprising, and are not considered critical. The TZ=UTC parameter sets the time zone to Coordinated Universal Time (UTC), but only for the duration of the test suite run. This ensures that the clock tests are exercised correctly. Details on the TZ environment variable are provided in Chapter 7.

# Install the package:

make install
# Make the installed library writable so debugging symbols can be removed later:

chmod -v u+w /tools/lib/libtcl8.6.so
# Install Tcl's headers. The next package, Expect, requires them to build.

make install-private-headers
# Now make a necessary symbolic link:

ln -sv tclsh8.6 /tools/bin/tclsh
