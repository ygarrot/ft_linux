# Prepare Bison for compilation:

./configure --prefix=/usr --docdir=/usr/share/doc/bison-3.0.5
# Compile the package:

make
# There is a circular dependency between bison and flex with regard to the checks. If desired, after installing flex in the next section, the bison can be rebuilt and the bison checks can be run with [ "$TESTING" == "True" ] && make check.

# Install the package:

make install
