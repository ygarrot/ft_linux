# Groff expects the environment variable PAGE to contain the default paper size. For users in the United States, PAGE=letter is appropriate. Elsewhere, PAGE=A4 may be more suitable. While the default paper size is configured during compilation, it can be overridden later by echoing either “A4” or “letter” to the /etc/papersize file.

# Prepare Groff for compilation:

PAGE=<paper_size> ./configure --prefix=/usr
# This package does not support parallel build. Compile the package:

make -j1
# This package does not come with a test suite.

# Install the package:

make install
