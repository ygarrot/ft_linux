# For our temporary set of tools, we only need to build and install three programs from Gettext.

# Prepare Gettext for compilation:

cd gettext-tools
EMACS="no" ./configure --prefix=/tools --disable-shared
# The meaning of the configure option:

# EMACS="no"
# This prevents the configure script from determining where to install Emacs Lisp files as the test is known to hang on some hosts.

# --disable-shared
# We do not need to install any of the shared Gettext libraries at this time, therefore there is no need to build them.

# Compile the package:

make -C gnulib-lib
make -C intl pluralx.c
make -C src msgfmt
make -C src msgmerge
make -C src xgettext
# As only three programs have been compiled, it is not possible to run the test suite without compiling additional support libraries from the Gettext package. It is therefore not recommended to attempt to run the test suite at this stage.

# Install the msgfmt, msgmerge and xgettext programs:

cp -v src/{msgfmt,msgmerge,xgettext} /tools/bin
