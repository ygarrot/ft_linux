#WARNING
# Prepare Bash for compilation:

./configure --prefix=/usr                       \
            --docdir=/usr/share/doc/bash-4.4.18 \
            --without-bash-malloc               \
            --with-installed-readline
# The meaning of the new configure option:

# --with-installed-readline
# This option tells Bash to use the readline library that is already installed on the system rather than using its own readline version.

# Compile the package:

make
# Skip down to “Install the package” if not running the test suite.

# To prepare the tests, ensure that the nobody user can write to the sources tree:

chown -Rv nobody .
# Now, run the tests as the nobody user:

su nobody -s /bin/bash -c "PATH=$PATH make tests"
# Install the package and move the main executable to /bin:

make install
mv -vf /usr/bin/bash /bin
# Run the newly compiled bash program (replacing the one that is currently being executed):

exec /bin/bash --login +h
# [Note] Note
# The parameters used make the bash process an interactive login shell and continue to disable hashing so that new programs are found as they become available.
