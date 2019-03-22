#!/bin/bash
# Now that the final C libraries have been installed, it is time to adjust the toolchain so that it will link any newly compiled program against these new libraries.

# First, backup the /tools linker, and replace it with the adjusted linker we made in chapter 5. We'll also create a link to its counterpart in /tools/$(uname -m)-pc-linux-gnu/bin:

mv -v /tools/bin/{ld,ld-old}
mv -v /tools/$(uname -m)-pc-linux-gnu/bin/{ld,ld-old}
mv -v /tools/bin/{ld-new,ld}
ln -sv /tools/bin/ld /tools/$(uname -m)-pc-linux-gnu/bin/ld
# Next, amend the GCC specs file so that it points to the new dynamic linker. Simply deleting all instances of “/tools” should leave us with the correct path to the dynamic linker. Also adjust the specs file so that GCC knows where to find the correct headers and Glibc start files. A sed command accomplishes this:

gcc -dumpspecs | sed -e 's@/tools@@g'                   \
    -e '/\*startfile_prefix_spec:/{n;s@.*@/usr/lib/ @}' \
    -e '/\*cpp:/{n;s@$@ -isystem /usr/include@}' >      \
    `dirname $(gcc --print-libgcc-file-name)`/specs
# It is a good idea to visually inspect the specs file to verify the intended change was actually made.

# It is imperative at this point to ensure that the basic functions (compiling and linking) of the adjusted toolchain are working as expected. To do this, perform the following sanity checks:

echo 'int main(){}' > dummy.c
cc dummy.c -v -Wl,--verbose &> dummy.log
readelf -l a.out | grep ': /lib'
# There should be no errors, and the output of the last command will be (allowing for platform-specific differences in dynamic linker name):

# [Requesting program interpreter: /lib64/ld-linux-x86-64.so.2]
# Note that on 64-bit systems /lib is the location of our dynamic linker, but is accessed via a symbolic link in /lib64.

# [Note] Note
# On 32-bit systems the interpreter should be /lib/ld-linux.so.2.

# Now make sure that we're setup to use the correct start files:

grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log
# The output of the last command should be:

/usr/lib/../lib/crt1.o succeeded
/usr/lib/../lib/crti.o succeeded
/usr/lib/../lib/crtn.o succeeded
# Verify that the compiler is searching for the correct header files:

grep -B1 '^ /usr/include' dummy.log
# This command should return the following output:

#include <...> search starts here:
 /usr/include
# Next, verify that the new linker is being used with the correct search paths:

grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'
# References to paths that have components with '-linux-gnu' should be ignored, but otherwise the output of the last command should be:

SEARCH_DIR("/usr/lib")
SEARCH_DIR("/lib")
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
