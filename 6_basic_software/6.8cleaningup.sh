#!/bin/bash
# Finally, clean up some extra files left around from running tests:

#rm -rf /tmp/*
# Now log out and reenter the chroot environment with an updated chroot command. From now on, use this updated chroot command any time you need to reenter the chroot environment after exiting:

#logout

chroot "$LFS" /usr/bin/env -i          \
	HOME=/root TERM="$TERM"            \
	PS1='(lfs chroot) \u:\w\$ '        \
	PATH=/bin:/usr/bin:/sbin:/usr/sbin \
	/bin/bash --login
# The reason for this is that the programs in /tools are no longer needed. For this reason you can delete the /tools directory if so desired.

# [Note] Note
# Removing /tools will also remove the temporary copies of Tcl, Expect, and DejaGNU which were used for running the toolchain tests. If you need these programs later on, they will need to be recompiled and re-installed. The BLFS book has instructions for this (see http://www.linuxfromscratch.org/blfs/).

# If the virtual kernel file systems have been unmounted, either manually or through a reboot, ensure that the virtual kernel file systems are mounted when reentering the chroot. This process was explained in Section 6.2.2, “Mounting and Populating /dev” and Section 6.2.3, “Mounting Virtual Kernel File Systems”.

# There were several static libraries that were not suppressed earlier in the chapter in order to satisfy the regression tests in several packages. These libraries are from binutils, bzip2, e2fsprogs, flex, libtool, and zlib. If desired, remove them now:

#rm -f /usr/lib/lib{bfd,opcodes}.a
#rm -f /usr/lib/libbz2.a
#rm -f /usr/lib/lib{com_err,e2p,ext2fs,ss}.a
#rm -f /usr/lib/libltdl.a
#rm -f /usr/lib/libfl.a
#rm -f /usr/lib/libz.a
## There are also several files installed in the /usr/lib and /usr/libexec directories with a file name extention of .la. These are "libtool archive" files and generally unneeded on a linux system. None of these are necessary at this point. To remove them, run:

#find /usr/lib /usr/libexec -name \*.la -delete
# For more information about libtool archive files, see the BLFS section "About Libtool Archive (.la) files".
