#!/bin/bash
# The behaviour of the Backspace and Delete keys is not consistent across the keymaps in the Kbd package. The following patch fixes this issue for i386 keymaps:

patch -Np1 -i ../kbd-2.0.4-backspace-1.patch
# After patching, the Backspace key generates the character with code 127, and the Delete key generates a well-known escape sequence.

# Remove the redundant resizecons program (it requires the defunct svgalib to provide the video mode files - for normal use setfont sizes the console appropriately) together with its manpage.

sed -i 's/\(RESIZECONS_PROGS=\)yes/\1no/g' configure
sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in
# Prepare Kbd for compilation:

PKG_CONFIG_PATH=/tools/lib/pkgconfig ./configure --prefix=/usr --disable-vlock
# The meaning of the configure options:

# --disable-vlock
# This option prevents the vlock utility from being built, as it requires the PAM library, which isn't available in the chroot environment.

# Compile the package:

make
# To test the results, issue:

[ "$TESTING" == "True" ] && make check
# Install the package:

make install
# [Note] Note
# For some languages (e.g., Belarusian) the Kbd package doesn't provide a useful keymap where the stock “by” keymap assumes the ISO-8859-5 encoding, and the CP1251 keymap is normally used. Users of such languages have to download working keymaps separately.

# If desired, install the documentation:

mkdir -v       /usr/share/doc/kbd-2.0.4
cp -R -v docs/doc/* /usr/share/doc/kbd-2.0.4
