# Prepare Zlib for compilation:

./configure --prefix=/usr
# Compile the package:

make
# To test the results, issue:

[ "$TESTING" == "True" ] && make check
# Install the package:

make install
# The shared library needs to be moved to /lib, and as a result the .so file in /usr/lib will need to be recreated:

mv -v /usr/lib/libz.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libz.so) /usr/lib/libz.so
