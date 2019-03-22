# Prepare MPC for compilation:

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/mpc-1.1.0
# Compile the package and generate the HTML documentation:

make
make html
# To test the results, issue:

[ "$TESTING" == "True" ] && make check
# Install the package and its documentation:

make install
make install-html
