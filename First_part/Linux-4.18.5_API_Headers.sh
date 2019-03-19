# The Linux kernel needs to expose an Application Programming Interface (API) for the system's C library (Glibc in LFS) to use. This is done by way of sanitizing various C header files that are shipped in the Linux kernel source tarball.

# Make sure there are no stale files embedded in the package:

make mrproper
# Now extract the user-visible kernel headers from the source. They are placed in an intermediate local directory and copied to the needed location because the extraction process removes any existing files in the target directory.

make INSTALL_HDR_PATH=dest headers_install
cp -rv dest/include/* /tools/include
