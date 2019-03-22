# First, suppress two invocations of test-lock which on some machines can loop forever:

sed -i '/^TESTS =/d' gettext-runtime/tests/Makefile.in &&
sed -i 's/test-lock..EXEEXT.//' gettext-tools/gnulib-tests/Makefile.in
# Now fix a configuration file:

sed -e '/AppData/{N;N;p;s/\.appdata\./.metainfo./}' \
    -i gettext-tools/its/appdata.loc
# Prepare Gettext for compilation:

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/gettext-0.19.8.1
# Compile the package:

make
# To test the results (this takes a long time, around 3 SBUs), issue:

[ "$TESTING" == "True" ] && make check
# Install the package:

make install
chmod -v 0755 /usr/lib/preloadable_libintl.so
