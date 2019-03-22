#!/bin/bash
# First, change the default location of the vimrc configuration file to /etc:

echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h
# Prepare Vim for compilation:

./configure --prefix=/usr
# Compile the package:

make
# To test the results, issue:

LANG=en_US.UTF-8 make -j1 test &> vim-test.log
# The test suite outputs a lot of binary data to the screen. This can cause issues with the settings of the current terminal. The problem can be avoided by redirecting the output to a log file as shown above. A successful test will result in the words "ALL DONE" in the log file at completion.

# Install the package:

make install
# Many users are used to using vi instead of vim. To allow execution of vim when users habitually enter vi, create a symlink for both the binary and the man page in the provided languages:

ln -sv vim /usr/bin/vi
for L in  /usr/share/man/{,*/}man1/vim.1; do
    ln -sv vim.1 $(dirname $L)/vi.1
done
# By default, Vim's documentation is installed in /usr/share/vim. The following symlink allows the documentation to be accessed via /usr/share/doc/vim-8.1, making it consistent with the location of documentation for other packages:

ln -sv ../vim/vim81/doc /usr/share/doc/vim-8.1
# If an X Window System is going to be installed on the LFS system, it may be necessary to recompile Vim after installing X. Vim comes with a GUI version of the editor that requires X and some additional libraries to be installed. For more information on this process, refer to the Vim documentation and the Vim installation page in the BLFS book at http://www.linuxfromscratch.org/blfs/view/8.3/postlfs/vim.html.

# 6.77.2. Configuring Vim
# By default, vim runs in vi-incompatible mode. This may be new to users who have used other editors in the past. The “nocompatible” setting is included below to highlight the fact that a new behavior is being used. It also reminds those who would change to “compatible” mode that it should be the first setting in the configuration file. This is necessary because it changes other settings, and overrides must come after this setting. Create a default vim configuration file by running the following:

cat > /etc/vimrc << "EOF"
" Begin /etc/vimrc

" Ensure defaults are set before customizing settings, not after
source $VIMRUNTIME/defaults.vim
let skip_defaults_vim=1 

set nocompatible
set backspace=2
set mouse=
syntax on
if (&term == "xterm") || (&term == "putty")
  set background=dark
endif

" End /etc/vimrc
EOF
# The set nocompatible setting makes vim behave in a more useful way (the default) than the vi-compatible manner. Remove the “no” to keep the old vi behavior. The set backspace=2 setting allows backspacing over line breaks, autoindents, and the start of insert. The syntax on parameter enables vim's syntax highlighting. The set mouse= setting enables proper pasting of text with the mouse when working in chroot or over a remote connection. Finally, the if statement with the set background=dark setting corrects vim's guess about the background color of some terminal emulators. This gives the highlighting a better color scheme for use on the black background of these programs.

# Documentation for other available options can be obtained by running the following command:

vim -c ':options'
# [Note] Note
# By default, Vim only installs spell files for the English language. To install spell files for your preferred language, download the *.spl and optionally, the *.sug files for your language and character encoding from ftp://ftp.vim.org/pub/vim/runtime/spell/ and save them to /usr/share/vim/vim81/spell/.

# To use these spell files, some configuration in /etc/vimrc is needed, e.g.:

set spelllang=en,ru
set spell
# For more information, see the appropriate README file located at the URL above.
