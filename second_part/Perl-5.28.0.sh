# First create a basic /etc/hosts file to be referenced in one of Perl's configuration files as well as the optional test suite:

echo "127.0.0.1 localhost $(hostname)" > /etc/hosts
# This version of Perl now builds the Compress::Raw::Zlib and Compress::Raw::BZip2 modules. By default Perl will use an internal copy of the sources for the build. Issue the following command so that Perl will use the libraries installed on the system:

export BUILD_ZLIB=False
export BUILD_BZIP2=0
# To have full control over the way Perl is set up, you can remove the “-des” options from the following command and hand-pick the way this package is built. Alternatively, use the command exactly as below to use the defaults that Perl auto-detects:

sh Configure -des -Dprefix=/usr                 \
                  -Dvendorprefix=/usr           \
                  -Dman1dir=/usr/share/man/man1 \
                  -Dman3dir=/usr/share/man/man3 \
                  -Dpager="/usr/bin/less -isR"  \
                  -Duseshrplib                  \
                  -Dusethreads
# The meaning of the configure options:

# -Dvendorprefix=/usr
# This ensures perl knows how to tell packages where they should install their perl modules.

# -Dpager="/usr/bin/less -isR"
# This ensures that less is used instead of more.

# -Dman1dir=/usr/share/man/man1 -Dman3dir=/usr/share/man/man3
# Since Groff is not installed yet, Configure thinks that we do not want man pages for Perl. Issuing these parameters overrides this decision.

# -Duseshrplib
# Build a shared libperl needed by some perl modules.

# -Dusethreads
# Build perl with support for threads.

# Compile the package:

make
# To test the results (approximately 11 SBU), issue:

make -k test
# [Note] Note
# One test fails due to using the most recent version of gdbm.

# Install the package and clean up:

make install
unset BUILD_ZLIB BUILD_BZIP2
