# Fix a file that creates a lot of failures in the regression checks:

sed -i '5481,5485 s/({/(\\{/' tp/Texinfo/Parser.pm
# Prepare Texinfo for compilation:

# ./configure --prefix=/usr --disable-static
# The meaning of the configure options:

# --disable-static
# In this case, the top-level configure script will complain that this is an unrecognized option, but the configure script for XSParagraph recognizes it and uses it to disable installing a static XSParagraph.a to /usr/lib/texinfo.

# Compile the package:

make
# To test the results, issue:

make check
# Install the package:

make install
# Optionally, install the components belonging in a TeX installation:

make TEXMF=/usr/share/texmf install-tex
# The meaning of the make parameter:

TEXMF=/usr/share/texmf
# The TEXMF makefile variable holds the location of the root of the TeX tree if, for example, a TeX package will be installed later.

# The Info documentation system uses a plain text file to hold its list of menu entries. The file is located at /usr/share/info/dir. Unfortunately, due to occasional problems in the Makefiles of various packages, it can sometimes get out of sync with the info pages installed on the system. If the /usr/share/info/dir file ever needs to be recreated, the following optional commands will accomplish the task:

pushd /usr/share/info
rm -v dir
for f in *
  do install-info $f dir 2>/dev/null
done
popd

