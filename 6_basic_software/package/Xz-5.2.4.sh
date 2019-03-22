# Prepare Xz for compilation with:

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/xz-5.2.4
# Compile the package:

make
# To test the results, issue:

[ "$TESTING" == "True" ] && make check
# Install the package and make sure that all essential files are in the correct directory:

make install
mv -v   /usr/bin/{lzma,unlzma,lzcat,xz,unxz,xzcat} /bin
mv -v /usr/lib/liblzma.so.* /lib
ln -svf ../../lib/$(readlink /usr/lib/liblzma.so) /usr/lib/liblzma.so
