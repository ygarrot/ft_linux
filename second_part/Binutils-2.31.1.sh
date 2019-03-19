# Verify that the PTYs are working properly inside the chroot environment by performing a simple test:

expect -c "spawn ls"
# This command should output the following:

spawn ls
# If, instead, the output includes the message below, then the environment is not set up for proper PTY operation. This issue needs to be resolved before running the test suites for Binutils and GCC:

# The system has no more ptys.
# Ask your system administrator to create more.
# The Binutils documentation recommends building Binutils in a dedicated build directory:

mkdir -v build
cd       build
# Prepare Binutils for compilation:

../configure --prefix=/usr       \
             --enable-gold       \
             --enable-ld=default \
             --enable-plugins    \
             --enable-shared     \
             --disable-werror    \
             --enable-64-bit-bfd \
             --with-system-zlib
# The meaning of the configure parameters:

# --enable-gold
# Build the gold linker and install it as ld.gold (along side the default linker).

# --enable-ld=default
# Build the original bdf linker and install it as both ld (the default linker) and ld.bfd.

# --enable-plugins
# Enables plugin support for the linker.

# --enable-64-bit-bfd
# Enables 64-bit support (on hosts with narrower word sizes). May not be needed on 64-bit systems, but does no harm.

# --with-system-zlib
# Use the installed zlib library rather than building the included version.

# Compile the package:

make tooldir=/usr
# The meaning of the make parameter:

# tooldir=/usr
# Normally, the tooldir (the directory where the executables will ultimately be located) is set to $(exec_prefix)/$(target_alias). For example, x86_64 machines would expand that to /usr/x86_64-unknown-linux-gnu. Because this is a custom system, this target-specific directory in /usr is not required. $(exec_prefix)/$(target_alias) would be used if the system was used to cross-compile (for example, compiling a package on an Intel machine that generates code that can be executed on PowerPC machines).

# [Important] Important
# The test suite for Binutils in this section is considered critical. Do not skip it under any circumstances.

# Test the results:

make -k check
# One test, debug_msg.sh, is known to fail.

# Install the package:

make tooldir=/usr install
