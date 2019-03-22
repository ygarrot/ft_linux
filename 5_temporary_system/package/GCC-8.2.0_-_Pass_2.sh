#!/bin/bash
# Our first build of GCC has installed a couple of internal system headers. Normally one of them, limits.h, will in turn include the corresponding system limits.h header, in this case, /tools/include/limits.h. However, at the time of the first build of gcc /tools/include/limits.h did not exist, so the internal header that GCC installed is a partial, self-contained file and does not include the extended features of the system header. This was adequate for building the temporary libc, but this build of GCC now requires the full internal header. Create a full version of the internal header using a command that is identical to what the GCC build system does in normal circumstances:

cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
  `dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/include-fixed/limits.h
# Once again, change the location of GCC's default dynamic linker to use the one installed in /tools.

for file in gcc/config/{linux,i386/linux{,64}}.h
do
  cp -uv $file{,.orig}
  sed -e 's@/lib\(64\)\?\(32\)\?/ld@/tools&@g' \
      -e 's@/usr@/tools@g' $file.orig > $file
  echo '
#undef STANDARD_STARTFILE_PREFIX_1
#undef STANDARD_STARTFILE_PREFIX_2
#define STANDARD_STARTFILE_PREFIX_1 "/tools/lib/"
#define STANDARD_STARTFILE_PREFIX_2 ""' >> $file
  touch $file.orig
done
# If building on x86_64, change the default directory name for 64-bit libraries to “lib”:

case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
  ;;
esac
# As in the first build of GCC it requires the GMP, MPFR and MPC packages. Unpack the tarballs and move them into the required directory names:

tar -xf ../mpfr-4.0.1.tar.xz
mv -v mpfr-4.0.1 mpfr
tar -xf ../gmp-6.1.2.tar.xz
mv -v gmp-6.1.2 gmp
tar -xf ../mpc-1.1.0.tar.gz
mv -v mpc-1.1.0 mpc
# Create a separate build directory again:

mkdir -v build
cd       build
# Before starting to build GCC, remember to unset any environment variables that override the default optimization flags.

# Now prepare GCC for compilation:

CC=$LFS_TGT-gcc                                    \
CXX=$LFS_TGT-g++                                   \
AR=$LFS_TGT-ar                                     \
RANLIB=$LFS_TGT-ranlib                             \
../configure                                       \
    --prefix=/tools                                \
    --with-local-prefix=/tools                     \
    --with-native-system-header-dir=/tools/include \
    --enable-languages=c,c++                       \
    --disable-libstdcxx-pch                        \
    --disable-multilib                             \
    --disable-bootstrap                            \
    --disable-libgomp
# The meaning of the new configure options:

# --enable-languages=c,c++
# This option ensures that both the C and C++ compilers are built.

# --disable-libstdcxx-pch
# Do not build the pre-compiled header (PCH) for libstdc++. It takes up a lot of space, and we have no use for it.

# --disable-bootstrap
# For native builds of GCC, the default is to do a "bootstrap" build. This does not just compile GCC, but compiles it several times. It uses the programs compiled in a first round to compile itself a second time, and then again a third time. The second and third iterations are compared to make sure it can reproduce itself flawlessly. This also implies that it was compiled correctly. However, the LFS build method should provide a solid compiler without the need to bootstrap each time.

# Compile the package:

make
# Install the package:

make install
# As a finishing touch, create a symlink. Many programs and scripts run cc instead of gcc, which is used to keep programs generic and therefore usable on all kinds of UNIX systems where the GNU C compiler is not always installed. Running cc leaves the system administrator free to decide which C compiler to install:

ln -sv gcc /tools/bin/cc
# [Caution] Caution
# At this point, it is imperative to stop and ensure that the basic functions (compiling and linking) of the new toolchain are working as expected. To perform a sanity check, run the following commands:

echo 'int main(){}' > dummy.c
cc dummy.c
readelf -l a.out | grep ': /tools'
# If everything is working correctly, there should be no errors, and the output of the last command will be of the form:

# [Requesting program interpreter: /tools/lib64/ld-linux-x86-64.so.2]
# Note that the dynamic linker will be /tools/lib/ld-linux.so.2 for 32-bit machines.

# If the output is not shown as above or there was no output at all, then something is wrong. Investigate and retrace the steps to find out where the problem is and correct it. This issue must be resolved before continuing on. First, perform the sanity check again, using gcc instead of cc. If this works, then the /tools/bin/cc symlink is missing. Install the symlink as per above. Next, ensure that the PATH is correct. This can be checked by running echo $PATH and verifying that /tools/bin is at the head of the list. If the PATH is wrong it could mean that you are not logged in as user lfs or that something went wrong back in Section 4.4, “Setting Up the Environment.”

# Once all is well, clean up the test files:

rm -v dummy.c a.out
