# Prepare procps-ng for compilation:

./configure --prefix=/usr                            \
            --exec-prefix=                           \
            --libdir=/usr/lib                        \
            --docdir=/usr/share/doc/procps-ng-3.3.15 \
            --disable-static                         \
            --disable-kill
# The meaning of the configure options:

# --disable-kill
# This switch disables building the kill command that will be installed by the Util-linux package.

# Compile the package:

make
# The test suite needs some custom modifications for LFS. Remove a test that fails when scripting does not use a tty device and fix two others. To run the test suite, run the following commands:

sed -i -r 's|(pmap_initname)\\\$|\1|' testsuite/pmap.test/pmap.exp
sed -i '/set tty/d' testsuite/pkill.test/pkill.exp
rm testsuite/pgrep.test/pgrep.exp
make check
# Install the package:

make install
# Finally, move essential libraries to a location that can be found if /usr is not mounted.

mv -v /usr/lib/libprocps.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libprocps.so) /usr/lib/libprocps.so
