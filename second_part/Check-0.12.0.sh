# Prepare Check for compilation:

./configure --prefix=/usr
# Build the package:

make
# Compilation is now complete. To run the Check test suite, issue the following command:

make check
# Note that the Check test suite may take a relatively long (up to 4 SBU) time.

# Install the package and fix a script:

make install
sed -i '1 s/tools/usr/' /usr/bin/checkmk
