#!/bin/bash
# GCC now requires the GMP, MPFR and MPC packages. As these packages may not be included in your host distribution, they will be built with GCC. Unpack each package into the GCC source directory and rename the resulting directories so the GCC build procedures will automatically use them:

# [Note] Note
# There are frequent misunderstandings about this chapter. The procedures are the same as every other chapter as explained earlier (Package build instructions). First extract the gcc tarball from the sources directory and then change to the directory created. Only then should you proceed with the instructions below.

tar -xf ../mpfr-4.0.1.tar.xz
mv -v mpfr-4.0.1 mpfr
tar -xf ../gmp-6.1.2.tar.xz
mv -v gmp-6.1.2 gmp
tar -xf ../mpc-1.1.0.tar.gz
mv -v mpc-1.1.0 mpc
# The following command will change the location of GCC's default dynamic linker to use the one installed in /tools. It also removes /usr/include from GCC's include search path. Issue:

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
# In case the above seems hard to follow, let's break it down a bit. First we copy the files gcc/config/linux.h, gcc/config/i386/linux.h, and gcc/config/i368/linux64.h to a file of the same name but with an added suffix of “.orig”. Then the first sed expression prepends “/tools” to every instance of “/lib/ld”, “/lib64/ld” or “/lib32/ld”, while the second one replaces hard-coded instances of “/usr”. Next, we add our define statements which alter the default startfile prefix to the end of the file. Note that the trailing “/” in “/tools/lib/” is required. Finally, we use touch to update the timestamp on the copied files. When used in conjunction with cp -u, this prevents unexpected changes to the original files in case the commands are inadvertently run twice.

# Finally, on x86_64 hosts, set the default directory name for 64-bit libraries to “lib”:

case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
 ;;
esac
# The GCC documentation recommends building GCC in a dedicated build directory:

mkdir -v build
cd       build
# Prepare GCC for compilation:

../configure                                       \
    --target=$LFS_TGT                              \
    --prefix=/tools                                \
    --with-glibc-version=2.11                      \
    --with-sysroot=$LFS                            \
    --with-newlib                                  \
    --without-headers                              \
    --with-local-prefix=/tools                     \
    --with-native-system-header-dir=/tools/include \
    --disable-nls                                  \
    --disable-shared                               \
    --disable-multilib                             \
    --disable-decimal-float                        \
    --disable-threads                              \
    --disable-libatomic                            \
    --disable-libgomp                              \
    --disable-libmpx                               \
    --disable-libquadmath                          \
    --disable-libssp                               \
    --disable-libvtv                               \
    --disable-libstdcxx                            \
    --enable-languages=c,c++
# The meaning of the configure options:

# --with-newlib
# Since a working C library is not yet available, this ensures that the inhibit_libc constant is defined when building libgcc. This prevents the compiling of any code that requires libc support.

# --without-headers
# When creating a complete cross-compiler, GCC requires standard headers compatible with the target system. For our purposes these headers will not be needed. This switch prevents GCC from looking for them.

# --with-local-prefix=/tools
# The local prefix is the location in the system that GCC will search for locally installed include files. The default is /usr/local. Setting this to /tools helps keep the host location of /usr/local out of this GCC's search path.

# --with-native-system-header-dir=/tools/include
# By default GCC searches /usr/include for system headers. In conjunction with the sysroot switch, this would normally translate to $LFS/usr/include. However the headers that will be installed in the next two sections will go to $LFS/tools/include. This switch ensures that gcc will find them correctly. In the second pass of GCC, this same switch will ensure that no headers from the host system are found.

# --disable-shared
# This switch forces GCC to link its internal libraries statically. We do this to avoid possible issues with the host system.

# --disable-decimal-float, --disable-threads, --disable-libatomic, --disable-libgomp, --disable-libmpx, --disable-libquadmath, --disable-libssp, --disable-libvtv, --disable-libstdcxx
# These switches disable support for the decimal floating point extension, threading, libatomic, libgomp, libmpx, libquadmath, libssp, libvtv, and the C++ standard library respectively. These features will fail to compile when building a cross-compiler and are not necessary for the task of cross-compiling the temporary libc.

# --disable-multilib
# On x86_64, LFS does not yet support a multilib configuration. This switch is harmless for x86.

# --enable-languages=c,c++
# This option ensures that only the C and C++ compilers are built. These are the only languages needed now.

# Compile GCC by running:

make
# Compilation is now complete. At this point, the test suite would normally be run, but, as mentioned before, the test suite framework is not in place yet. The benefits of running the tests at this point are minimal since the programs from this first pass will soon be replaced.

# Install the package:

make install
