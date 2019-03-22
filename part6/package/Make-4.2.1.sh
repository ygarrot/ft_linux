# Again, work around an error caused by glibc-2.27:

sed -i '211,217 d; 219,229 d; 232 d' glob/glob.c
# Prepare Make for compilation:

./configure --prefix=/usr
# Compile the package:

make
# The test suite needs to know where supporting perl files are located. We use an environment variable to accomplish this. To test the results, issue:

make PERL5LIB=$PWD/tests/ check
# Install the package:

make install
