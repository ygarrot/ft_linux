# Prepare Python for compilation:

./configure --prefix=/usr       \
            --enable-shared     \
            --with-system-expat \
            --with-system-ffi   \
            --with-ensurepip=yes
# The meaning of the configure options:

# --with-system-expat
# This switch enables linking against system version of Expat.

# --with-system-ffi
# This switch enables linking against system version of libffi.

# --with-ensurepip=yes
# This switch enables building pip and setuptools packaging programs.

# Compile the package:

make
# The test suite requires TK and and X Windows session and cannot be run until Python 3 is reinstalled in BLFS.

# Install the package:

make install
chmod -v 755 /usr/lib/libpython3.7m.so
chmod -v 755 /usr/lib/libpython3.so
# The meaning of the install commands:

chmod -v 755 /usr/lib/libpython3.{7m.,}so
# Fix permissions for libraries to be consistent with other libraries.

# If desired, install the preformatted documentation:

install -v -dm755 /usr/share/doc/python-3.7.0/html 

tar --strip-components=1  \
    --no-same-owner       \
    --no-same-permissions \
    -C /usr/share/doc/python-3.7.0/html \
    -xvf ../python-3.7.0-docs-html.tar.bz2
# The meaning of the documentation install commands:

--no-same-owner and --no-same-permissions
# Ensure the installed files have the correct ownership and permissions. Without these options, using tar will install the package files with the upstream creator's values.
