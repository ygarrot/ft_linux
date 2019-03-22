# [Note] Note
# If you are building for 32-bit x86, but you have a CPU which is capable of running 64-bit code and you have specified CFLAGS in the environment, the configure script will attempt to configure for 64-bits and fail. Avoid this by invoking the configure command below with

# ABI=32 ./configure ...
# [Note] Note
# The default settings of GMP produce libraries optimized for the host processor. If libraries suitable for processors less capable than the host's CPU are desired, generic libraries can be created by running the following:

cp -v configfsf.guess config.guess
cp -v configfsf.sub   config.sub
# Prepare GMP for compilation:

./configure --prefix=/usr    \
            --enable-cxx     \
            --disable-static \
            --docdir=/usr/share/doc/gmp-6.1.2
# The meaning of the new configure options:

# --enable-cxx
# This parameter enables C++ support

# --docdir=/usr/share/doc/gmp-6.1.2
# This variable specifies the correct place for the documentation.

# Compile the package and generate the HTML documentation:

make
make html
# [Important] Important
# The test suite for GMP in this section is considered critical. Do not skip it under any circumstances.

# Test the results:

[ "$TESTING" == "True" ] && make check 2>&1 | tee gmp-check-log
# [Caution] Caution
# The code in gmp is highly optimized for the processor where it is built. Occasionally, the code that detects the processor misidentifies the system capabilities and there will be errors in the tests or other applications using the gmp libraries with the message "Illegal instruction". In this case, gmp should be reconfigured with the option --build=x86_64-unknown-linux-gnu and rebuilt.

# Ensure that all 190 tests in the test suite passed. Check the results by issuing the following command:

awk '/# PASS:/{total+=$3} ; END{print total}' gmp-check-log
# Install the package and its documentation:

make install
make install-html
