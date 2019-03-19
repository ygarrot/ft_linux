# First, ensure some unneeded files are not installed:

sed -i 's/extras//' Makefile.in
# Prepare Gawk for compilation:

./configure --prefix=/usr
# Compile the package:

make
# To test the results, issue:

make check
# Install the package:

make install
# If desired, install the documentation:

mkdir -v /usr/share/doc/gawk-4.2.1
cp    -v doc/{awkforai.txt,*.{eps,pdf,jpg}} /usr/share/doc/gawk-4.2.1
