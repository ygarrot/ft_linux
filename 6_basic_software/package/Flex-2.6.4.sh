#!/bin/bash
# First, fix a problem introduced with glibc-2.26:

sed -i "/math.h/a #include <malloc.h>" src/flexdef.h
# The build procedure assumes the help2man program is available to create a man page from the executable --help option. This is not present, so we use an environment variable to skip this process. Now, prepare Flex for compilation:

HELP2MAN=/tools/bin/true \
./configure --prefix=/usr --docdir=/usr/share/doc/flex-2.6.4
# Compile the package:

make
# To test the results (about 0.5 SBU), issue:

[ "$TESTING" == "True" ] && make check
# Install the package:

make install
# A few programs do not know about flex yet and try to run its predecessor, lex. To support those programs, create a symbolic link named lex that runs flex in lex emulation mode:

ln -sv flex /usr/bin/lex
