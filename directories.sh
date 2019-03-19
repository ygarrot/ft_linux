# It is time to create some structure in the LFS file system. Create a standard directory tree by issuing the following commands:

mkdir -pv /{bin,boot,etc/{opt,sysconfig},home,lib/firmware,mnt,opt}
mkdir -pv /{media/{floppy,cdrom},sbin,srv,var}
install -dv -m 0750 /root
install -dv -m 1777 /tmp /var/tmp
mkdir -pv /usr/{,local/}{bin,include,lib,sbin,src}
mkdir -pv /usr/{,local/}share/{color,dict,doc,info,locale,man}
mkdir -v  /usr/{,local/}share/{misc,terminfo,zoneinfo}
mkdir -v  /usr/libexec
mkdir -pv /usr/{,local/}share/man/man{1..8}

case $(uname -m) in
 x86_64) mkdir -v /lib64 ;;
esac

mkdir -v /var/{log,mail,spool}
ln -sv /run /var/run
ln -sv /run/lock /var/lock
mkdir -pv /var/{opt,cache,lib/{color,misc,locate},local}
# Directories are, by default, created with permission mode 755, but this is not desirable for all directories. In the commands above, two changes are made—one to the home directory of user root, and another to the directories for temporary files.

# The first mode change ensures that not just anybody can enter the /root directory—the same as a normal user would do with his or her home directory. The second mode change makes sure that any user can write to the /tmp and /var/tmp directories, but cannot remove another user's files from them. The latter is prohibited by the so-called “sticky bit,” the highest bit (1) in the 1777 bit mask.

# 6.5.1. FHS Compliance Note
# The directory tree is based on the Filesystem Hierarchy Standard (FHS) (available at https://wiki.linuxfoundation.org/en/FHS). The FHS also specifies the optional existence of some directories such as /usr/local/games and /usr/share/games. We create only the directories that are needed. However, feel free to create these directories.
