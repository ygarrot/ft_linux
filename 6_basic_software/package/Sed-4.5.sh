# First fix an issue in the LFS environment and remove a failing test:

sed -i 's/usr/tools/'                 build-aux/help2man
sed -i 's/testsuite.panic-tests.sh//' Makefile.in
# Prepare Sed for compilation:

./configure --prefix=/usr --bindir=/bin
# Compile the package and generate the HTML documentation:

make
make html
# To test the results, issue:

[ "$TESTING" == "True" ] && make check
# Install the package and its documentation:

make install
install -d -m755           /usr/share/doc/sed-4.5
install -m644 doc/sed.html /usr/share/doc/sed-4.5
