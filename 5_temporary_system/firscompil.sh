#!/bin/bash
#!/bin/bash
SOURCES=`pwd`
PART5=$SOURCES/ft_linux/5_temporary_system/package

FIRST_COMPIL=(
"Binutils-2.31.1_-_Pass_1.sh:binutils-2.31.1.tar.xz"
"GCC-8.2.0_-_Pass_1.sh:gcc-8.2.0.tar.xz"
"Linux-4.18.5_API_Headers.sh:linux-4.18.5.tar.xz"
"Glibc-2.28.sh:glibc-2.28.tar.xz"
"Libstdc++_from_GCC-8.2.0.sh:gcc-8.2.0.tar.xz"
"Binutils-2.31.1_-_Pass_2.sh:binutils-2.31.1.tar.xz"
"GCC-8.2.0_-_Pass_2.sh:gcc-8.2.0.tar.xz"
"Tcl-8.6.8.sh:tcl8.6.8-src.tar.gz"
"Expect-5.45.4.sh:expect5.45.4.tar.gz"
"M4-1.4.18.sh:m4-1.4.18.tar.xz"
"DejaGNU-1.6.1.sh:dejagnu-1.6.1.tar.gz"
"Ncurses-6.1.sh:ncurses-6.1.tar.gz"
"Bash-4.4.18.sh:bash-4.4.18.tar.gz"
"Bison-3.0.5.sh:bison-3.0.5.tar.xz"
"Bzip2-1.0.6.sh:bzip2-1.0.6.tar.gz"
"Coreutils-8.30.sh:coreutils-8.30.tar.xz"
"Diffutils-3.6.sh:diffutils-3.6.tar.xz"
"File-5.34.sh:file-5.34.tar.gz"
"Findutils-4.6.0.sh:findutils-4.6.0.tar.gz"
"Gawk-4.2.1.sh:gawk-4.2.1.tar.xz"
"Gettext-0.19.8.1.sh:gettext-0.19.8.1.tar.xz"
"Grep-3.1.sh:grep-3.1.tar.xz"
"Gzip-1.9.sh:gzip-1.9.tar.xz"
"Make-4.2.1.sh:make-4.2.1.tar.bz2"
"Patch-2.7.6.sh:patch-2.7.6.tar.xz"
"Perl-5.28.0.sh:perl-5.28.0.tar.xz"
"Sed-4.5.sh:sed-4.5.tar.xz"
"Tar-1.30.sh:tar-1.30.tar.xz"
"Texinfo-6.5.sh:texinfo-6.5.tar.xz"
"Util-linux-2.32.1.sh:util-linux-2.32.1.tar.xz"
"Xz-5.2.4.sh:xz-5.2.4.tar.xz"
)

rm script_dones
for package in "${FIRST_COMPIL[@]}" ; do
	TAR="${package##*:}"
	SCRIPT="${package%%:*}"
	FOLDER=${TAR%.*.*}
	# VERSION=${SCRIPT##*-}
	# PACKAGE=${SCRIPT%-*}
	tar -xf $TAR
	cd $FOLDER
	sh $PART5/$SCRIPT
	cd $SOURCES
	echo $SCRIPT = $TAR >> script_dones
	rm -rf $FOLDER
done
