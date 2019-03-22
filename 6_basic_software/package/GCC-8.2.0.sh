#!/bin/bash
# If building on x86_64, change the default directory name for 64-bit libraries to “lib”:

case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
  ;;
esac
# Remove the symlink created earlier as the final gcc includes will be installed here:

rm -f /usr/lib/gcc
# The GCC documentation recommends building GCC in a dedicated build directory:

mkdir -v build
cd       build
# Prepare GCC for compilation:

SED=sed                               \
../configure --prefix=/usr            \
             --enable-languages=c,c++ \
             --disable-multilib       \
             --disable-bootstrap      \
             --disable-libmpx         \
             --with-system-zlib
# Note that for other languages, there are some prerequisites that are not yet available. See the BLFS Book for instructions on how to build all of GCC's supported languages.

# The meaning of the new configure parameters:

SED=sed
# Setting this environment variable prevents a hard-coded path to /tools/bin/sed.

# --disable-libmpx
# This switch tells GCC to not build mpx (Memory Protection Extensions) that can cause problems on some processors. It has been removed from the next version of gcc.

# --with-system-zlib
# This switch tells GCC to link to the system installed copy of the Zlib library, rather than its own internal copy.

# Compile the package:

make
# [Important] Important
# In this section, the test suite for GCC is considered critical. Do not skip it under any circumstance.

# One set of tests in the GCC test suite is known to exhaust the stack, so increase the stack size prior to running the tests:

ulimit -s 32768
# Remove one test known to cause a problem:

rm ../gcc/testsuite/g++.dg/pr83239.C
# Test the results as a non-privileged user, but do not stop at errors:

chown -Rv nobody . 
su nobody -s /bin/bash -c "PATH=$PATH make -k check"
# To receive a summary of the test suite results, run:

../contrib/test_summary
# For only the summaries, pipe the output through grep -A7 Summ.

# Results can be compared with those located at http://www.linuxfromscratch.org/lfs/build-logs/8.3/ and https://gcc.gnu.org/ml/gcc-testresults/.

# A few unexpected failures cannot always be avoided. The GCC developers are usually aware of these issues, but have not resolved them yet. Unless the test results are vastly different from those at the above URL, it is safe to continue.

# [Note] Note
# On some combinations of kernel configuration and AMD processors there may be more than 1100 failures in the gcc.target/i386/mpx tests (which are designed to test the MPX option on recent Intel processors). These can safely be ignored on AMD processors. These tests will also fail on Intel processors if MPX support is not enabled in the kernel even though it is present on the CPU.

# Install the package:

make install
# Create a symlink required by the FHS for "historical" reasons.

ln -sv ../usr/bin/cpp /lib
# Many packages use the name cc to call the C compiler. To satisfy those packages, create a symlink:

ln -sv gcc /usr/bin/cc
# Add a compatibility symlink to enable building programs with Link Time Optimization (LTO):

install -v -dm755 /usr/lib/bfd-plugins
ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/8.2.0/liblto_plugin.so \
        /usr/lib/bfd-plugins/
# Now that our final toolchain is in place, it is important to again ensure that compiling and linking will work as expected. We do this by performing the same sanity checks as we did earlier in the chapter:

echo 'int main(){}' > dummy.c
cc dummy.c -v -Wl,--verbose &> dummy.log
readelf -l a.out | grep ': /lib'
# There should be no errors, and the output of the last command will be (allowing for platform-specific differences in dynamic linker name):

# [Requesting program interpreter: /lib64/ld-linux-x86-64.so.2]
# Now make sure that we're setup to use the correct start files:

grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log
# The output of the last command should be:

# /usr/lib/gcc/x86_64-pc-linux-gnu/8.2.0/../../../../lib/crt1.o succeeded
# /usr/lib/gcc/x86_64-pc-linux-gnu/8.2.0/../../../../lib/crti.o succeeded
# /usr/lib/gcc/x86_64-pc-linux-gnu/8.2.0/../../../../lib/crtn.o succeeded
# Depending on your machine architecture, the above may differ slightly, the difference usually being the name of the directory after /usr/lib/gcc. The important thing to look for here is that gcc has found all three crt*.o files under the /usr/lib directory.

# Verify that the compiler is searching for the correct header files:

grep -B4 '^ /usr/include' dummy.log
# This command should return the following output:

#include <...> search starts here:
 # /usr/lib/gcc/x86_64-pc-linux-gnu/8.2.0/include
 # /usr/local/include
 # /usr/lib/gcc/x86_64-pc-linux-gnu/8.2.0/include-fixed
 # /usr/include
# Again, note that the directory named after your target triplet may be different than the above, depending on your architecture.

# Next, verify that the new linker is being used with the correct search paths:

grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'
# References to paths that have components with '-linux-gnu' should be ignored, but otherwise the output of the last command should be:

# SEARCH_DIR("/usr/x86_64-pc-linux-gnu/lib64")
# SEARCH_DIR("/usr/local/lib64")
# SEARCH_DIR("/lib64")
# SEARCH_DIR("/usr/lib64")
# SEARCH_DIR("/usr/x86_64-pc-linux-gnu/lib")
# SEARCH_DIR("/usr/local/lib")
# SEARCH_DIR("/lib")
# SEARCH_DIR("/usr/lib");
# # A 32-bit system may see a few different directories. For example, here is the output from an i686 machine:

# SEARCH_DIR("/usr/i686-pc-linux-gnu/lib32")
# SEARCH_DIR("/usr/local/lib32")
# SEARCH_DIR("/lib32")
# SEARCH_DIR("/usr/lib32")
# SEARCH_DIR("/usr/i686-pc-linux-gnu/lib")
# SEARCH_DIR("/usr/local/lib")
# SEARCH_DIR("/lib")
# SEARCH_DIR("/usr/lib");
# Next make sure that we're using the correct libc:

grep "/lib.*/libc.so.6 " dummy.log
# The output of the last command should be:

# attempt to open /lib/libc.so.6 succeeded
# Lastly, make sure GCC is using the correct dynamic linker:

grep found dummy.log
# The output of the last command should be (allowing for platform-specific differences in dynamic linker name):

# found ld-linux-x86-64.so.2 at /lib/ld-linux-x86-64.so.2
# If the output does not appear as shown above or is not received at all, then something is seriously wrong. Investigate and retrace the steps to find out where the problem is and correct it. The most likely reason is that something went wrong with the specs file adjustment. Any issues will need to be resolved before continuing with the process.

# Once everything is working correctly, clean up the test files:

rm -v dummy.c a.out dummy.log
# Finally, move a misplaced file:

mkdir -pv /usr/share/gdb/auto-load/usr/lib
mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib
