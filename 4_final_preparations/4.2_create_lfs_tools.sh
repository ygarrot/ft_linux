#!/bin/bash
# 4.2. Creating the $LFS/tools Directory
# All programs compiled in Chapter 5 will be installed under $LFS/tools to keep them separate from the programs compiled in Chapter 6. The programs compiled here are temporary tools and will not be a part of the final LFS system. By keeping these programs in a separate directory, they can easily be discarded later after their use. This also prevents these programs from ending up in the host production directories (easy to do by accident in Chapter 5).

# Create the required directory by running the following as root:

mkdir -v $LFS/tools
# The next step is to create a /tools symlink on the host system. This will point to the newly-created directory on the LFS partition. Run this command as root as well:

ln -sv $LFS/tools /
# [Note] Note
# The above command is correct. The ln command has a few syntactic variations, so be sure to check info coreutils ln and ln(1) before reporting what you may think is an error.

# The created symlink enables the toolchain to be compiled so that it always refers to /tools, meaning that the compiler, assembler, and linker will work both in Chapter 5 (when we are still using some tools from the host) and in the next (when we are “chrooted” to the LFS partition).
