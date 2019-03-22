# Prepare Inetutils for compilation:

./configure --prefix=/usr        \
            --localstatedir=/var \
            --disable-logger     \
            --disable-whois      \
            --disable-rcp        \
            --disable-rexec      \
            --disable-rlogin     \
            --disable-rsh        \
            --disable-servers
# The meaning of the configure options:

# --disable-logger
# This option prevents Inetutils from installing the logger program, which is used by scripts to pass messages to the System Log Daemon. Do not install it because Util-linux installs a more recent version.

# --disable-whois
# This option disables the building of the Inetutils whois client, which is out of date. Instructions for a better whois client are in the BLFS book.

# --disable-r*
# These parameters disable building obsolete programs that should not be used due to security issues. The functions provided by these programs can be provided by the openssh package in the BLFS book.

# --disable-servers
# This disables the installation of the various network servers included as part of the Inetutils package. These servers are deemed not appropriate in a basic LFS system. Some are insecure by nature and are only considered safe on trusted networks. Note that better replacements are available for many of these servers.

# Compile the package:

make
# To test the results, issue:

[ "$TESTING" == "True" ] && make check
# [Note] Note
# One test, libls.sh, may fail in the initial chroot environment but will pass if the test is rerun after the LFS system is complete. One test, ping-localhost.sh, will fail if the host system does not have ipv6 capability.

# Install the package:

make install
# Move some programs so they are available if /usr is not accessible:

mv -v /usr/bin/{hostname,ping,ping6,traceroute} /bin
mv -v /usr/bin/ifconfig /sbin
