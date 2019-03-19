# Prepare OpenSSL for compilation:

./config --prefix=/usr         \
         --openssldir=/etc/ssl \
         --libdir=lib          \
         shared                \
         zlib-dynamic
# Compile the package:

make
# To test the results, issue:

make test
# One subtest in the test 40-test_rehash.t fails in the lfs chroot environment, but passes when run as a regular user.

# Install the package:

sed -i '/INSTALL_LIBS/s/libcrypto.a libssl.a//' Makefile
make MANSUFFIX=ssl install
# If desired, install the documentation:

mv -v /usr/share/doc/openssl /usr/share/doc/openssl-1.1.0i
cp -vfr doc/* /usr/share/doc/openssl-1.1.0i
