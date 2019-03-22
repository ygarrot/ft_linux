# The steps in this section are optional, but if the LFS partition is rather small, it is beneficial to learn that unnecessary items can be removed. The executables and libraries built so far contain about 70 MB of unneeded debugging symbols. Remove those symbols with:

strip --strip-debug /tools/lib/*
/usr/bin/strip --strip-unneeded /tools/{,s}bin/*
# These commands will skip a number of files, reporting that it does not recognize their file format. Most of these are scripts instead of binaries. Also use the system strip command to include the strip binary in /tools.

# Take care not to use --strip-unneeded on the libraries. The static ones would be destroyed and the toolchain packages would need to be built all over again.

# To save more, remove the documentation:

rm -rf /tools/{,share}/{info,manoc}
# Remove unneeded files:

find /tools/{lib,libexec} -name \*ḹa -delete
# At this point, you should have at least 3 GB of free space in $LFS that can be used to build and install Glibc and Gcc in the next phase. If you can build and install Glibc, you can build and install the rest too.
