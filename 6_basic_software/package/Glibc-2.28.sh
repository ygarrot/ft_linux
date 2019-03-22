# # Note
# The Glibc build system is self-contained and will install perfectly, even though the compiler specs file and linker are still pointing to /tools. The specs and linker cannot be adjusted before the Glibc install because the Glibc autoconf tests would give false results and defeat the goal of achieving a clean build.

# Some of the Glibc programs use the non-FHS compilant /var/db directory to store their runtime data. Apply the following patch to make such programs store their runtime data in the FHS-compliant locations:

patch -Np1 -i ../glibc-2.28-fhs-1.patch
# First create a compatibility symlink to avoid references to /tools in our final glibc:

ln -sfv /tools/lib/gcc /usr/lib
# Determine the GCC include directory and create a symlink for LSB compliance. Additionally, for x86_64, create a compatibility symlink required for the dynamic loader to function correctly:

case $(uname -m) in
    i?86)    GCC_INCDIR=/usr/lib/gcc/$(uname -m)-pc-linux-gnu/8.2.0/include
            ln -sfv ld-linux.so.2 /lib/ld-lsb.so.3
    ;;
    x86_64) GCC_INCDIR=/usr/lib/gcc/x86_64-pc-linux-gnu/8.2.0/include
            ln -sfv ../lib/ld-linux-x86-64.so.2 /lib64
            ln -sfv ../lib/ld-linux-x86-64.so.2 /lib64/ld-lsb-x86-64.so.3
    ;;
esac
# Remove a file that may be left over from a previous build attempt:

rm -f /usr/include/limits.h
# The Glibc documentation recommends building Glibc in a dedicated build directory:

mkdir -v build
cd       build
# Prepare Glibc for compilation:

CC="gcc -isystem $GCC_INCDIR -isystem /usr/include" \
../configure --prefix=/usr                          \
             --disable-werror                       \
             --enable-kernel=3.2                    \
             --enable-stack-protector=strong        \
             libc_cv_slibdir=/lib
unset GCC_INCDIR
# The meaning of the options and new configure parameters:

# CC="gcc -isystem $GCC_INCDIR -isystem /usr/include"
# Setting the location of both gcc and system include directories avoids introduction of invalid paths in debugging symbols.

# --disable-werror
# This option disables the -Werror option passed to GCC. This is necessary for running the test suite.

# --enable-stack-protector=strong
# This option increases system security by adding extra code to check for buffer overflows, such as stack smashing attacks.

# libc_cv_slibdir=/lib
# This variable sets the correct library for all systems. We do not want lib64 to be used.

# Compile the package:

make
# [Important] Important
# In this section, the test suite for Glibc is considered critical. Do not skip it under any circumstance.

# Generally a few tests do not pass. The test failures listed below are usually safe to ignore.

[ "$TESTING" == "True" ] && make check
# You may see some test failures. The Glibc test suite is somewhat dependent on the host system. This is a list of the most common issues seen for some versions of LFS:

# misc/tst-ttyname is known to fail in the LFS chroot environment.

# inet/tst-idna_name_classify is known to fail in the LFS chroot environment.

# posix/tst-getaddrinfo4 and posix/tst-getaddrinfo5 may fail on some architectures.

# The nss/tst-nss-files-hosts-multi test may fail for reasons that have not been determined.

# The math tests sometimes fail when running on systems where the CPU is not a relatively new Intel or AMD processor.

# Though it is a harmless message, the install stage of Glibc will complain about the absence of /etc/ld.so.conf. Prevent this warning with:

touch /etc/ld.so.conf
# Fix the generated Makefile to skip an unneeded sanity check that fails in the LFS partial environment:

sed '/test-installation/s@$(PERL)@echo not running@' -i ../Makefile
# Install the package:

make install
# Install the configuration file and runtime directory for nscd:

cp -v ../nscd/nscd.conf /etc/nscd.conf
mkdir -pv /var/cache/nscd
# Next, install the locales that can make the system respond in a different language. None of the locales are required, but if some of them are missing, the test suites of future packages would skip important testcases.

# Individual locales can be installed using the localedef program. E.g., the first localedef command below combines the /usr/share/i18n/locales/cs_CZ charset-independent locale definition with the /usr/share/i18n/charmaps/UTF-8.gz charmap definition and appends the result to the /usr/lib/locale/locale-archive file. The following instructions will install the minimum set of locales necessary for the optimal coverage of tests:

mkdir -pv /usr/lib/locale
localedef -i cs_CZ -f UTF-8 cs_CZ.UTF-8
localedef -i de_DE -f ISO-8859-1 de_DE
localedef -i de_DE@euro -f ISO-8859-15 de_DE@euro
localedef -i de_DE -f UTF-8 de_DE.UTF-8
localedef -i en_GB -f UTF-8 en_GB.UTF-8
localedef -i en_HK -f ISO-8859-1 en_HK
localedef -i en_PH -f ISO-8859-1 en_PH
localedef -i en_US -f ISO-8859-1 en_US
localedef -i en_US -f UTF-8 en_US.UTF-8
localedef -i es_MX -f ISO-8859-1 es_MX
localedef -i fa_IR -f UTF-8 fa_IR
localedef -i fr_FR -f ISO-8859-1 fr_FR
localedef -i fr_FR@euro -f ISO-8859-15 fr_FR@euro
localedef -i fr_FR -f UTF-8 fr_FR.UTF-8
localedef -i it_IT -f ISO-8859-1 it_IT
localedef -i it_IT -f UTF-8 it_IT.UTF-8
localedef -i ja_JP -f EUC-JP ja_JP
localedef -i ru_RU -f KOI8-R ru_RU.KOI8-R
localedef -i ru_RU -f UTF-8 ru_RU.UTF-8
localedef -i tr_TR -f UTF-8 tr_TR.UTF-8
localedef -i zh_CN -f GB18030 zh_CN.GB18030
# In addition, install the locale for your own country, language and character set.

# Alternatively, install all locales listed in the glibc-2.28/localedata/SUPPORTED file (it includes every locale listed above and many more) at once with the following time-consuming command:

make localedata/install-locales
# Then use the localedef command to create and install locales not listed in the glibc-2.28/localedata/SUPPORTED file in the unlikely case you need them.

# [Note] Note
# Glibc now uses libidn2 when resolving internationalized domain names. This is a run time dependency. If this capability is needed, the instrucions for installing libidn2 are in the BLFS libidn2 page.

# 6.9.2. Configuring Glibc
# 6.9.2.1. Adding nsswitch.conf
# The /etc/nsswitch.conf file needs to be created because the Glibc defaults do not work well in a networked environment.

# Create a new file /etc/nsswitch.conf by running the following:

cat > /etc/nsswitch.conf << "EOF"
# Begin /etc/nsswitch.conf

passwd: files
group: files
shadow: files

hosts: files dns
networks: files

protocols: files
services: files
ethers: files
rpc: files

# End /etc/nsswitch.conf
EOF
# 6.9.2.2. Adding time zone data
# Install and set up the time zone data with the following:

tar -xf ../../tzdata2018e.tar.gz

ZONEINFO=/usr/share/zoneinfo
mkdir -pv $ZONEINFO/{posix,right}

for tz in etcetera southamerica northamerica europe africa antarctica  \
          asia australasia backward pacificnew systemv; do
    zic -L /dev/null   -d $ZONEINFO       -y "sh yearistype.sh" ${tz}
    zic -L /dev/null   -d $ZONEINFO/posix -y "sh yearistype.sh" ${tz}
    zic -L leapseconds -d $ZONEINFO/right -y "sh yearistype.sh" ${tz}
done

cp -v zone.tab zone1970.tab iso3166.tab $ZONEINFO
zic -d $ZONEINFO -p America/New_York
unset ZONEINFO
The meaning of the zic commands:

# zic -L /dev/null ...
# This creates posix time zones, without any leap seconds. It is conventional to put these in both zoneinfo and zoneinfo/posix. It is necessary to put the POSIX time zones in zoneinfo, otherwise various test-suites will report errors. On an embedded system, where space is tight and you do not intend to ever update the time zones, you could save 1.9MB by not using the posix directory, but some applications or test-suites might produce some failures.

# zic -L leapseconds ...
# This creates right time zones, including leap seconds. On an embedded system, where space is tight and you do not intend to ever update the time zones, or care about the correct time, you could save 1.9MB by omitting the right directory.

# zic ... -p ...
# This creates the posixrules file. We use New York because POSIX requires the daylight savings time rules to be in accordance with US rules.

# One way to determine the local time zone is to run the following script:

tzselect
# After answering a few questions about the location, the script will output the name of the time zone (e.g., America/Edmonton). There are also some other possible time zones listed in /usr/share/zoneinfo such as Canada/Eastern or EST5EDT that are not identified by the script but can be used.

# Then create the /etc/localtime file by running:

cp -v /usr/share/zoneinfo/<xxx> /etc/localtime
# cp -v /usr/share/zoneinfo/<xxx> /etc/localtime
# Replace <xxx> with the name of the time zone selected (e.g., Canada/Eastern).

# 6.9.2.3. Configuring the Dynamic Loader
# By default, the dynamic loader (/lib/ld-linux.so.2) searches through /lib and /usr/lib for dynamic libraries that are needed by programs as they are run. However, if there are libraries in directories other than /lib and /usr/lib, these need to be added to the /etc/ld.so.conf file in order for the dynamic loader to find them. Two directories that are commonly known to contain additional libraries are /usr/local/lib and /opt/lib, so add those directories to the dynamic loader's search path.

# Create a new file /etc/ld.so.conf by running the following:

cat > /etc/ld.so.conf << "EOF"
# Begin /etc/ld.so.conf
/usr/local/lib
/opt/lib

EOF
# If desired, the dynamic loader can also search a directory and include the contents of files found there. Generally the files in this include directory are one line specifying the desired library path. To add this capability run the following commands:

cat >> /etc/ld.so.conf << "EOF"
# Add an include directory
include /etc/ld.so.conf.d/*.conf

EOF
mkdir -pv /etc/ld.so.conf.d
# 6.9.3. Contents of Glibc
# # Installed programs:
# catchsegv, gencat, getconf, getent, iconv, iconvconfig, ldconfig, ldd, lddlibc4, locale, localedef, makedb, mtrace, nscd, pldd, sln, sotruss, sprof, tzselect, xtrace, zdump, and zic
# Installed libraries:
# ld-2.28.so, libBrokenLocale.{a,so}, libSegFault.so, libanl.{a,so}, libc.{a,so}, libc_nonshared.a, libcidn.so, libcrypt.{a,so}, libdl.{a,so}, libg.a, libieee.a, libm.{a,so}, libmcheck.a, libmemusage.so, libnsl.{a,so}, libnss_compat.so, libnss_dns.so, libnss_files.so, libnss_hesiod.so, libnss_nis.so, libnss_nisplus.so, libpthread.{a,so}, libpthread_nonshared.a, libresolv.{a,so}, librpcsvc.a, librt.{a,so}, libthread_db.so, and libutil.{a,so}
# Installed directories:
# /usr/include/arpa, /usr/include/bits, /usr/include/gnu, /usr/include/net, /usr/include/netash, /usr/include/netatalk, /usr/include/netax25, /usr/include/neteconet, /usr/include/netinet, /usr/include/netipx, /usr/include/netiucv, /usr/include/netpacket, /usr/include/netrom, /usr/include/netrose, /usr/include/nfs, /usr/include/protocols, /usr/include/rpc, /usr/include/rpcsvc, /usr/include/sys, /usr/lib/audit, /usr/lib/gconv, /usr/lib/locale, /usr/libexec/getconf, /usr/share/i18n, /usr/share/zoneinfo, /var/cache/nscd, and /var/lib/nss_db
# Short Descriptions
# catchsegv

# Can be used to create a stack trace when a program terminates with a segmentation fault

# gencat

# # Generates message catalogues

# getconf

# Displays the system configuration values for file system specific variables

# getent

# Gets entries from an administrative database

# iconv

# Performs character set conversion

# iconvconfig

# Creates fastloading iconv module configuration files

# ldconfig

# Configures the dynamic linker runtime bindings

# ldd

# Reports which shared libraries are required by each given program or shared library

# lddlibc4

# Assists ldd with object files

# locale

# Prints various information about the current locale

# localedef

# Compiles locale specifications

# makedb

# Creates a simple database from textual input

# mtrace

# Reads and interprets a memory trace file and displays a summary in human-readable format

# nscd

# A daemon that provides a cache for the most common name service requests

# pldd

# Lists dynamic shared objects used by running processes

# sln

# A statically linked ln program

# sotruss

# Traces shared library procedure calls of a specified command

# sprof

# Reads and displays shared object profiling data

# tzselect

# Asks the user about the location of the system and reports the corresponding time zone description

# xtrace

# Traces the execution of a program by printing the currently executed function

# zdump

# The time zone dumper

# zic

# The time zone compiler

# ld-2.28.so

# The helper program for shared library executables

# libBrokenLocale

# Used internally by Glibc as a gross hack to get broken programs (e.g., some Motif applications) running. See comments in glibc-2.28/locale/broken_cur_max.c for more information

# libSegFault

# The segmentation fault signal handler, used by catchsegv

# libanl

# An asynchronous name lookup library

# libc

# The main C library

# libcidn

# Used internally by Glibc for handling internationalized domain names in the getaddrinfo() function

# libcrypt

# The cryptography library

# libdl

# The dynamic linking interface library

# libg

# Dummy library containing no functions. Previously was a runtime library for g++

# libieee

# Linking in this module forces error handling rules for math functions as defined by the Institute of Electrical and Electronic Engineers (IEEE). The default is POSIX.1 error handling

# libm

# The mathematical library

# libmcheck

# Turns on memory allocation checking when linked to

# libmemusage

# Used by memusage to help collect information about the memory usage of a program

# libnsl

# The network services library

# libnss

# The Name Service Switch libraries, containing functions for resolving host names, user names, group names, aliases, services, protocols, etc.

# libpthread

# The POSIX threads library

# libresolv

# Contains functions for creating, sending, and interpreting packets to the Internet domain name servers

# librpcsvc

# Contains functions providing miscellaneous RPC services

# librt

# Contains functions providing most of the interfaces specified by the POSIX.1b Realtime Extension

# libthread_db

# Contains functions useful for building debuggers for multi-threaded programs

# libutil

# Contains code for “standard” functions used in many different Unix utilities
