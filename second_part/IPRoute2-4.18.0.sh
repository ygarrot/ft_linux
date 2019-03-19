# The arpd program included in this package will not be built since it is dependent on Berkeley DB, which is not installed in LFS. However, a directory for arpd and a man page will still be installed. Prevent this by running the commands below. If the arpd binary is needed, instructions for compiling Berkeley DB can be found in the BLFS Book at http://www.linuxfromscratch.org/blfs/view/8.3/server/databases.html#db.

sed -i /ARPD/d Makefile
rm -fv man/man8/arpd.8
# It is also necessary to disable building two modules that requires http://www.linuxfromscratch.org/blfs/view/8.3/postlfs/iptables.html.

sed -i 's/.m_ipt.o//' tc/Makefile
# Compile the package:

make
# This package does not have a working test suite.

# Install the package:

make DOCDIR=/usr/share/doc/iproute2-4.18.0 install
