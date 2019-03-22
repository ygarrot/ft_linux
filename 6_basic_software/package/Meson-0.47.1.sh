#!/bin/bash
# Compile Meson with the following command:

python3 setup.py build
# This package does not come with a test suite.

# Install the package:

python3 setup.py install --root=dest
cp -rv dest/* /
# The meaning of the install parameters:

# --root=dest
# By default python3 setup.py install installs various files (such as man pages) into Python Eggs. With a specified root location, setup.py installs these files into a standard hierarchy. Then we can just copy the hierarchy so the files will be in the standard location.
