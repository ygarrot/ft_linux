#!/bin/bash
# First, make some fixes required by glibc-2.28:

sed -i 's/IO_ftrylockfile/IO_EOF_SEEN/' gl/lib/*.c
sed -i '/unistd/a #include <sys/sysmacros.h>' gl/lib/mountlist.c
echo "#define _IO_IN_BACKUP 0x100" >> gl/lib/stdio-impl.h
# Prepare Findutils for compilation:

./configure --prefix=/tools
# Compile the package:

make
# Compilation is now complete. As discussed earlier, running the test suite is not mandatory for the temporary tools here in this chapter. To run the Findutils test suite anyway, issue the following command:

make check
# Install the package:

make install
