#!/bin/bash
# The Glibc documentation recommends building Glibc in a dedicated build directory:

mkdir -v build
cd       build
# Next, prepare Glibc for compilation:

../configure                             \
      --prefix=/tools                    \
      --host=$LFS_TGT                    \
      --build=$(../scripts/config.guess) \
      --enable-kernel=3.2             \
      --with-headers=/tools/include      \
      libc_cv_forced_unwind=yes          \
      libc_cv_c_cleanup=yes
# The meaning of the configure options:

# --host=$LFS_TGT, --build=$(../scripts/config.guess)
# The combined effect of these switches is that Glibc's build system configures itself to cross-compile, using the cross-linker and cross-compiler in /tools.

# --enable-kernel=3.2
# This tells Glibc to compile the library with support for 3.2 and later Linux kernels. Workarounds for older kernels are not enabled.

# --with-headers=/tools/include
# This tells Glibc to compile itself against the headers recently installed to the tools directory, so that it knows exactly what features the kernel has and can optimize itself accordingly.

# libc_cv_forced_unwind=yes
# The linker installed during Section 5.4, “Binutils-2.31.1 - Pass 1” was cross-compiled and as such cannot be used until Glibc has been installed. This means that the configure test for force-unwind support will fail, as it relies on a working linker. The libc_cv_forced_unwind=yes variable is passed in order to inform configure that force-unwind support is available without it having to run the test.

# libc_cv_c_cleanup=yes
# Similarly, we pass libc_cv_c_cleanup=yes through to the configure script so that the test is skipped and C cleanup handling support is configured.

# During this stage the following warning might appear:

# configure: WARNING:
# *** These auxiliary programs are missing or
# *** incompatible versions: msgfmt
# *** some features will be disabled.
# *** Check the INSTALL file for required versions.
# The missing or incompatible msgfmt program is generally harmless. This msgfmt program is part of the Gettext package which the host distribution should provide.

# [Note] Note
# There have been reports that this package may fail when building as a "parallel make". If this occurs, rerun the make command with a "-j1" option.

# Compile the package:

make
# Install the package:

make install
# [Caution] Caution
# At this point, it is imperative to stop and ensure that the basic functions (compiling and linking) of the new toolchain are working as expected. To perform a sanity check, run the following commands:

echo 'int main(){}' > dummy.c
$LFS_TGT-gcc dummy.c
readelf -l a.out | grep ': /tools'
# If everything is working correctly, there should be no errors, and the output of the last command will be of the form:

# [Requesting program interpreter: /tools/lib64/ld-linux-x86-64.so.2]
# Note that for 32-bit machines, the interpreter name will be /tools/lib/ld-linux.so.2.

# If the output is not shown as above or there was no output at all, then something is wrong. Investigate and retrace the steps to find out where the problem is and correct it. This issue must be resolved before continuing on.

# Once all is well, clean up the test files:

rm -v dummy.c a.out
# [Note] Note
h Building Binutils in the section after next will serve as an additional check that the toolchain has been built properly. If Binutils fails to build, it is an indication that something has gone wrong with the previous Binutils, GCC, or Glibc installations.
