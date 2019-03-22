# This section is optional. If the intended user is not a programmer and does not plan to do any debugging on the system software, the system size can be decreased by about 90 MB by removing the debugging symbols from binaries and libraries. This causes no inconvenience other than not being able to debug the software fully anymore.

# Most people who use the commands mentioned below do not experience any difficulties. However, it is easy to make a typo and render the new system unusable, so before running the strip commands, it is a good idea to make a backup of the LFS system in its current state.

# First place the debugging symbols for selected libraries in separate files. This debugging information is needed if running regression tests that use valgrind or gdb later in BLFS.

save_lib="ld-2.28.so libc-2.28.so libpthread-2.28.so libthread_db-1.0.so"

cd /lib

for LIB in $save_lib; do
	objcopy --only-keep-debug $LIB $LIB.dbg 
	strip --strip-unneeded $LIB
	objcopy --add-gnu-debuglink=$LIB.dbg $LIB 
done    

save_usrlib="libquadmath.so.0.0.0 libstdc++.so.6.0.25
libitm.so.1.0.0 libatomic.so.1.2.0" 

cd /usr/lib

for LIB in $save_usrlib; do
	objcopy --only-keep-debug $LIB $LIB.dbg
	strip --strip-unneeded $LIB
	objcopy --add-gnu-debuglink=$LIB.dbg $LIB
done

unset LIB save_lib save_usrlib
# Before performing the stripping, take special care to ensure that none of the binaries that are about to be stripped are running:

exec /tools/bin/bash
# Now the binaries and libraries can be safely stripped:

/tools/bin/find /usr/lib -type f -name \*.a \
	-exec /tools/bin/strip --strip-debug {} ';'

/tools/bin/find /lib /usr/lib -type f \( -name \*.so* -a ! -name \*dbg \) \
	-exec /tools/bin/strip --strip-unneeded {} ';'

/tools/bin/find /{bin,sbin} /usr/{bin,sbin,libexec} -type f \
	-exec /tools/bin/strip --strip-all {} ';'
# A large number of files will be reported as having their file format not recognized. These warnings can be safely ignored. These warnings indicate that those files are scripts instead of binaries.
