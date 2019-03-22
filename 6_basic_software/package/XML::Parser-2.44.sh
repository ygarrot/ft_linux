# Prepare XML::Parser for compilation:

perl Makefile.PL
# Compile the package:

make
# To test the results, issue:

[ "$TESTING" == "True" ] && make test
# Install the package:

make install

