# Prepare Less for compilation:

./configure --prefix=/usr --sysconfdir=/etc
# The meaning of the configure options:

# --sysconfdir=/etc
# This option tells the programs created by the package to look in /etc for the configuration files.

# Compile the package:

make
# This package does not come with a test suite.

# Install the package:

make install
