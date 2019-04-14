# Some programs use hard-wired paths to programs which do not exist yet. In order to satisfy these programs, create a number of symbolic links which will be replaced by real files throughout the course of this chapter after the software has been installed:

ln -sv /tools/bin/{bash,cat,dd,echo,ln,pwd,rm,stty} /bin
ln -sv /tools/bin/{env,install,perl} /usr/bin
ln -sv /tools/lib/libgcc_s.so{,.1} /usr/lib
ln -sv /tools/lib/libstdc++.{a,so{,.6}} /usr/lib
for lib in blkid lzma mount uuid
do
    ln -sv /tools/lib/lib$lib.so* /usr/lib
done
ln -svf /tools/include/blkid    /usr/include
ln -svf /tools/include/libmount /usr/include
ln -svf /tools/include/uuid     /usr/include
install -vdm755 /usr/lib/pkgconfig
for pc in blkid mount uuid
do
    sed 's@tools@usr@g' /tools/lib/pkgconfig/${pc}.pc \
        > /usr/lib/pkgconfig/${pc}.pc
done
ln -sv bash /bin/sh
# The purpose of each link:

# /bin/bash
# Many bash scripts specify /bin/bash.

# /bin/cat
# This pathname is hard-coded into Glibc's configure script.

# /bin/dd
# The path to dd will be hard-coded into the /usr/bin/libtool utility.

# /bin/echo
# This is to satisfy one of the tests in Glibc's test suite, which expects /bin/echo.

# /usr/bin/install
# The path to install will be hard-coded into the /usr/lib/bash/Makefile.inc file.

# /bin/ln
# The path to ln will be hard-coded into the /usr/lib/perl5/5.28.0/<target-triplet>/Config_heavy.pl file.

# /bin/pwd
# Some configure scripts, particularly Glibc's, have this pathname hard-coded.

# /bin/rm
# The path to rm will be hard-coded into the /usr/lib/perl5/5.28.0/<target-triplet>/Config_heavy.pl file.

# /bin/stty
# This pathname is hard-coded into Expect, therefore it is needed for Binutils and GCC test suites to pass.

# /usr/bin/perl
# Many Perl scripts hard-code this path to the perl program.

# /usr/lib/libgcc_s.so{,.1}
# Glibc needs this for the pthreads library to work.

# /usr/lib/libstdc++{,.6}
# This is needed by several tests in Glibc's test suite, as well as for C++ support in GMP.

# /usr/lib/lib{blkid,lzma,mount,uuid}.{a,la,so*}
# These links prevent utilities from acquiring an unnecessary reference to the /tools directory.

# /bin/sh
# Many shell scripts hard-code /bin/sh.

# Historically, Linux maintains a list of the mounted file systems in the file /etc/mtab. Modern kernels maintain this list internally and exposes it to the user via the /proc filesystem. To satisfy utilities that expect the presence of /etc/mtab, create the following symbolic link:

ln -sv /proc/self/mounts /etc/mtab
# In order for user root to be able to login and for the name “root” to be recognized, there must be relevant entries in the /etc/passwd and /etc/group files.

# Create the /etc/passwd file by running the following command:

cat > /etc/passwd << "EOF"
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/dev/null:/bin/false
daemon:x:6:6:Daemon User:/dev/null:/bin/false
messagebus:x:18:18:D-Bus Message Daemon User:/var/run/dbus:/bin/false
nobody:x:99:99:Unprivileged User:/dev/null:/bin/false
EOF
# The actual password for root (the “x” used here is just a placeholder) will be set later.

# Create the /etc/group file by running the following command:

cat > /etc/group << "EOF"
root:x:0:
bin:x:1:daemon
sys:x:2:
kmem:x:3:
tape:x:4:
tty:x:5:
daemon:x:6:
floppy:x:7:
disk:x:8:
lp:x:9:
dialout:x:10:
audio:x:11:
video:x:12:
utmp:x:13:
usb:x:14:
cdrom:x:15:
adm:x:16:
messagebus:x:18:
systemd-journal:x:23:
input:x:24:
mail:x:34:
nogroup:x:99:
users:x:999:
EOF
# The created groups are not part of any standard—they are groups decided on in part by the requirements of the Udev configuration in this chapter, and in part by common convention employed by a number of existing Linux distributions. In addition, some test suites rely on specific users or groups. The Linux Standard Base (LSB, available at http://www.linuxbase.org) recommends only that, besides the group root with a Group ID (GID) of 0, a group bin with a GID of 1 be present. All other group names and GIDs can be chosen freely by the system administrator since well-written programs do not depend on GID numbers, but rather use the group's name.

# To remove the “I have no name!” prompt, start a new shell. Since a full Glibc was installed in Chapter 5 and the /etc/passwd and /etc/group files have been created, user name and group name resolution will now work:

exec /tools/bin/bash --login +h
# Note the use of the +h directive. This tells bash not to use its internal path hashing. Without this directive, bash would remember the paths to binaries it has executed. To ensure the use of the newly compiled binaries as soon as they are installed, the +h directive will be used for the duration of this chapter.

# The login, agetty, and init programs (and others) use a number of log files to record information such as who was logged into the system and when. However, these programs will not write to the log files if they do not already exist. Initialize the log files and give them proper permissions:

touch /var/log/{btmp,lastlog,faillog,wtmp}
chgrp -v utmp /var/log/lastlog
chmod -v 664  /var/log/lastlog
chmod -v 600  /var/log/btmp
# The /var/log/wtmp file records all logins and logouts. The /var/log/lastlog file records when each user last logged in. The /var/log/faillog file records failed login attempts. The /var/log/btmp file records the bad login attempts.

# [Note] Note
# The /run/utmp file records the users that are currently logged in. This file is created dynamically in the boot scripts.
