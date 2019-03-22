# When run, ninja normally runs a maximum number of processes in parallel. By default this is the number of cores on the system plus two. In some cases this can overheat a CPU or run a system out of memory. If run from the command line, passing a -jN parameter will limit the number of parallel processes, but some packages embed the execution of ninja and do not pass a -j parameter.

# Using the optional patch below allows a user to limit the number of parallel processes via an environment variable, NINJAJOBS. For example setting:

export NINJAJOBS=4
# will limit ninja to four parallel processes.

# If desired, install the patch by running:

patch -Np1 -i ../ninja-1.8.2-add_NINJAJOBS_var-1.patch
# Build Ninja with:

python3 configure.py --bootstrap
# The meaning of the build option:

# --bootstrap
# This parameter forces ninja to rebuild itself for the current system.

# To test the results, issue:

python3 configure.py
./ninja ninja_test
./ninja_test --gtest_filter=-SubprocessTest.SetWithLots
# Install the package:

install -vm755 ninja /usr/bin/
install -vDm644 misc/bash-completion /usr/share/bash-completion/completions/ninja
install -vDm644 misc/zsh-completion  /usr/share/zsh/site-functions/_ninja
