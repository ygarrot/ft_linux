# POSIX requires that programs from Coreutils recognize character boundaries correctly even in multibyte locales. The following patch fixes this non-compliance and other internationalization-related bugs.

patch -Np1 -i ../coreutils-8.30-i18n-1.patch
# [Note] Note
# In the past, many bugs were found in this patch. When reporting new bugs to Coreutils maintainers, please check first if they are reproducible without this patch.

# Suppress a test which on some machines can loop forever:

sed -i '/test.lock/s/^/#/' gnulib-tests/gnulib.mk
# Now prepare Coreutils for compilation:

autoreconf -fiv
FORCE_UNSAFE_CONFIGURE=1 ./configure \
            --prefix=/usr            \
            --enable-no-install-program=kill,uptime
# The meaning of the configure options:

# autoreconf
# # This command updates generated configuration files consistent with the latest version of automake.

# FORCE_UNSAFE_CONFIGURE=1
# This environment variable allows the package to be built as the root user.

# --enable-no-install-program=kill,uptime
# The purpose of this switch is to prevent Coreutils from installing binaries that will be installed by other packages later.

# Compile the package:

FORCE_UNSAFE_CONFIGURE=1 make
# Skip down to “Install the package” if not running the test suite.

# Now the test suite is ready to be run. First, run the tests that are meant to be run as user root:

make NON_ROOT_USERNAME=nobody check-root
# We're going to run the remainder of the tests as the nobody user. Certain tests, however, require that the user be a member of more than one group. So that these tests are not skipped we'll add a temporary group and make the user nobody a part of it:

echo "dummy:x:1000:nobody" >> /etc/group
# Fix some of the permissions so that the non-root user can compile and run the tests:

chown -Rv nobody . 
# Now run the tests. Make sure the PATH in the su environment includes /tools/bin.

su nobody -s /bin/bash \
          -c "PATH=$PATH make RUN_EXPENSIVE_TESTS=yes check"
# The test program test-getlogin is known to fail in a partially built system environment like the chroot environment here, but passes if run at the end of this chapter. The test program tty.sh is also known to fail.

# Remove the temporary group:

sed -i '/dummy/d' /etc/group
# Install the package:

make install
# Move programs to the locations specified by the FHS:

mv -v /usr/bin/{cat,chgrp,chmod,chown,cp,date,dd,df,echo} /bin
mv -v /usr/bin/{false,ln,ls,mkdir,mknod,mv,pwd,rm} /bin
mv -v /usr/bin/{rmdir,stty,sync,true,uname} /bin
mv -v /usr/bin/chroot /usr/sbin
mv -v /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8
sed -i s/\"1\"/\"8\"/1 /usr/share/man/man8/chroot.8
# Some of the scripts in the LFS-Bootscripts package depend on head, sleep, and nice. As /usr may not be available during the early stages of booting, those binaries need to be on the root partition:

mv -v /usr/bin/{head,sleep,nice} /bin
