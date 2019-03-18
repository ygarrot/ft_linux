# Prepare Bash for compilation:

./configure --prefix=/tools --without-bash-malloc
# The meaning of the configure options:

--without-bash-malloc
# This option turns off the use of Bash's memory allocation (malloc) function which is known to cause segmentation faults. By turning this option off, Bash will use the malloc functions from Glibc which are more stable.

# Compile the package:

make
# Compilation is now complete. As discussed earlier, running the test suite is not mandatory for the temporary tools here in this chapter. To run the Bash test suite anyway, issue the following command:

make tests
# Install the package:

make install
# Make a link for the programs that use sh for a shell:

ln -sv bash /tools/bin/sh
