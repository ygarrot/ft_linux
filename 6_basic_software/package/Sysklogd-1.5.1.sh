# First, fix problems that causes a segmentation fault under some conditions in klogd and fix an obsolete program construct:

sed -i '/Error loading kernel symbols/{n;n;d}' ksym_mod.c
sed -i 's/union wait/int/' syslogd.c
# Compile the package:

make
# This package does not come with a test suite.

# Install the package:

make BINDIR=/sbin install
