# Prepare MPFR for compilation:

./configure --prefix=/usr        \
            --disable-static     \
            --enable-thread-safe \
            --docdir=/usr/share/doc/mpfr-4.0.1
# Compile the package and generate the HTML documentation:

make
make html
# [Important] Important
# The test suite for MPFR in this section is considered critical. Do not skip it under any circumstances.

# Test the results and ensure that all tests passed:

make check
# Install the package and its documentation:

make install
make install-html
