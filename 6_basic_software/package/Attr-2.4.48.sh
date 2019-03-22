# Prepare Attr for compilation:

./configure --prefix=/usr     \
	--bindir=/bin     \
	--disable-static  \
	--sysconfdir=/etc \
	--docdir=/usr/share/doc/attr-2.4.48
# Compile the package:

make
# The tests need to be run on a filesystem that supports extended attributes such as the ext2, ext3, or ext4 filesystems. To test the results, issue:

[ "$TESTING" == "True" ] && make check
# Install the package:

make install
# The shared library needs to be moved to /lib, and as a result the .so file in /usr/lib will need to be recreated:

mv -v /usr/lib/libattr.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libattr.so) /usr/lib/libattr.so
