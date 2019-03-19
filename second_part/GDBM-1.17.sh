# Prepare GDBM for compilation:

./configure --prefix=/usr \
            --disable-static \
            --enable-libgdbm-compat
# The meaning of the configure option:

--enable-libgdbm-compat
# This switch enables the libgdbm compatibility library to be built, as some packages outside of LFS may require the older DBM routines it provides.

# Compile the package:

make
# To test the results, issue:

make check
# Install the package:

make install
