#!/bin/bash
SOURCES=`pwd`
PART6=$SOURCES/ft_linux/6_basic_software/package

SECOND_COMPIL=(
"Linux-4.18.5_API_Headers.sh:linux-4.18.5.tar.xz"
"Man-pages-4.16.sh:man-pages-4.16.tar.xz"
"Glibc-2.28.sh:glibc-2.28.tar.xz"
"Zlib-1.2.11.sh:zlib-1.2.11.tar.xz"
"File-5.34.sh:file-5.34.tar.gz"
"Readline-7.0.sh:readline-7.0.tar.gz"
"M4-1.4.18.sh:m4-1.4.18.tar.xz"
"Bc-1.07.1.sh:bc-1.07.1.tar.gz"
"Binutils-2.31.1.sh:binutils-2.31.1.tar.xz"
"GMP-6.1.2.sh:gmp-6.1.2.tar.xz"
"MPFR-4.0.1.sh:mpfr-4.0.1.tar.xz"
"MPC-1.1.0.sh:mpc-1.1.0.tar.gz"
"Shadow-4.6.sh:shadow-4.6.tar.xz"
"GCC-8.2.0.sh:gcc-8.2.0.tar.xz"
"Bzip2-1.0.6.sh:bzip2-1.0.6.tar.gz"
"Pkg-config-0.29.2.sh:pkg-config-0.29.2.tar.gz"
"Ncurses-6.1.sh:ncurses-6.1.tar.gz"
"Attr-2.4.48.sh:attr-2.4.48.tar.gz"
"Acl-2.2.53.sh:acl-2.2.53.tar.gz"
"Libcap-2.25.sh:libcap-2.25.tar.xz"
"Sed-4.5.sh:sed-4.5.tar.xz"
"Psmisc-23.1.sh:psmisc-23.1.tar.xz"
"Iana-Etc-2.30.sh:iana-etc-2.30.tar.bz2"
"Bison-3.0.5.sh:bison-3.0.5.tar.xz"
"Flex-2.6.4.sh:flex-2.6.4.tar.gz"
"Grep-3.1.sh:grep-3.1.tar.xz"
"Bash-4.4.18.sh:bash-4.4.18.tar.gz"
"Libtool-2.4.6.sh:libtool-2.4.6.tar.xz"
"GDBM-1.17.sh:gdbm-1.17.tar.gz"
"Gperf-3.1.sh:gperf-3.1.tar.gz"
"Expat-2.2.6.sh:expat-2.2.6.tar.bz2"
"Inetutils-1.9.4.sh:inetutils-1.9.4.tar.xz"
"Perl-5.28.0.sh:perl-5.28.0.tar.xz"
"XML::Parser-2.44.sh:XML-Parser-2.44.tar.gz"
"Intltool-0.51.0.sh:intltool-0.51.0.tar.gz"
"Autoconf-2.69.sh:autoconf-2.69.tar.xz"
"Automake-1.16.1.sh:automake-1.16.1.tar.xz"
"Xz-5.2.4.sh:xz-5.2.4.tar.xz"
"Kmod-25.sh:kmod-25.tar.xz"
"Gettext-0.19.8.1.sh:gettext-0.19.8.1.tar.xz"
"Libelf_0.173.sh:elfutils-0.173.tar.bz2"
"Libffi-3.2.1.sh:libffi-3.2.1.tar.gz"
"OpenSSL-1.1.0i.sh:openssl-1.1.0i.tar.gz"
"Python-3.7.0.sh:Python-3.7.0.tar.xz"
"Ninja-1.8.2.sh:ninja-1.8.2.tar.gz"
"Meson-0.47.1.sh:meson-0.47.1.tar.gz"
"Procps-ng-3.3.15.sh:procps-ng-3.3.15.tar.xz"
"E2fsprogs-1.44.3.sh:e2fsprogs-1.44.3.tar.gz"
"Coreutils-8.30.sh:coreutils-8.30.tar.xz"
"Check-0.12.0.sh:check-0.12.0.tar.gz"
"Diffutils-3.6.sh:diffutils-3.6.tar.xz"
"Gawk-4.2.1.sh:gawk-4.2.1.tar.xz"
"Findutils-4.6.0.sh:findutils-4.6.0.tar.gz"
"Groff-1.22.3.sh:groff-1.22.3.tar.gz"
"GRUB-2.02.sh:grub-2.02.tar.xz"
"Less-530.sh:less-530.tar.gz"
"Gzip-1.9.sh:gzip-1.9.tar.xz"
"IPRoute2-4.18.0.sh:iproute2-4.18.0.tar.xz"
"Kbd-2.0.4.sh:kbd-2.0.4.tar.xz"
"Libpipeline-1.5.0.sh:libpipeline-1.5.0.tar.gz"
"Make-4.2.1.sh:make-4.2.1.tar.bz2"
"Patch-2.7.6.sh:patch-2.7.6.tar.xz"
"Sysklogd-1.5.1.sh:sysklogd-1.5.1.tar.gz"
"Sysvinit-2.90.sh:sysvinit-2.90.tar.xz"
"Eudev-3.2.5.sh:eudev-3.2.5.tar.gz"
"Util-linux-2.32.1.sh:util-linux-2.32.1.tar.xz"
"Man-DB-2.8.4.sh:man-db-2.8.4.tar.xz"
"Tar-1.30.sh:tar-1.30.tar.xz"
"Texinfo-6.5.sh:texinfo-6.5.tar.xz"
"Vim-8.1.sh:vim-8.1.tar.bz2"
)

rm script_dones
for package in "${SECOND_COMPIL[@]}" ; do
	TAR="${package##*:}"
	SCRIPT="${package%%:*}"
	FOLDER=${TAR%.*.*}
	# VERSION=${SCRIPT##*-}
	# PACKAGE=${SCRIPT%-*}
	tar -xf $TAR
	cd $FOLDER
	sh $PART6/$SCRIPT
	cd $SOURCES
	echo $SCRIPT = $TAR >> script_dones
	rm -rf $FOLDER
done
