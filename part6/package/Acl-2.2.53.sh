# Prepare Acl for compilation:

./configure --prefix=/usr         \
            --bindir=/bin         \
            --disable-static      \
            --libexecdir=/usr/lib \
            --docdir=/usr/share/doc/acl-2.2.53
# Compile the package:

make
# The Acl tests need to be run on a filesystem that supports access controls after Coreutils has been built with the Acl libraries. If desired, return to this package and run make check after Coreutils has been built later in this chapter.

# Install the package:

make install
# The shared library needs to be moved to /lib, and as a result the .so file in /usr/lib will need to be recreated:

mv -v /usr/lib/libacl.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libacl.so) /usr/lib/libacl.so
