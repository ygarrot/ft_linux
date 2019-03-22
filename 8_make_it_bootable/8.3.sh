#!/bin/bash
# 8.3.1. Installation of the kernel
# Building the kernel involves a few steps—configuration, compilation, and installation. Read the README file in the kernel source tree for alternative methods to the way this book configures the kernel.

# Prepare for compilation by running the following command:

make mrproper
# This ensures that the kernel tree is absolutely clean. The kernel team recommends that this command be issued prior to each kernel compilation. Do not rely on the source tree being clean after un-tarring.

# Configure the kernel via a menu-driven interface. For general information on kernel configuration see http://www.linuxfromscratch.org/hints/downloads/files/kernel-configuration.txt. BLFS has some information regarding particular kernel configuration requirements of packages outside of LFS at http://www.linuxfromscratch.org/blfs/view/8.3/longindex.html#kernel-config-index. Additional information about configuring and building the kernel can be found at http://www.kroah.com/lkn/

# [Note] Note
# A good starting place for setting up the kernel configuration is to run make defconfig. This will set the base configuration to a good state that takes your current system architecture into account.

# Be sure to enable/disable/set the following features or the system might not work correctly or boot at all:

# Device Drivers  --->
# Generic Driver Options  --->
# [ ] Support for uevent helper [CONFIG_UEVENT_HELPER]
# [*] Maintain a devtmpfs filesystem to mount at /dev [CONFIG_DEVTMPFS]

# Kernel hacking  --->
# Choose kernel unwinder (Frame pointer unwinder)  ---> [CONFIG_UNWINDER_FRAME_POINTER]
# There are several other options that may be desired depending on the requirements for the system. For a list of options needed for BLFS packages, see the BLFS Index of Kernel Settings (http://www.linuxfromscratch.org/blfs/view/8.3/longindex.html#kernel-config-index).

# [Note] Note
# If your host hardware is using UEFI, then the 'make defconfig' above should automatically add in some EFI-related kernel options.

# 	In order to allow your LFS kernel to be booted from within your host's UEFI boot environment, your kernel must have this option selected:

# 	Processor type and features  --->
# 	[*]   EFI stub support  [CONFIG_EFI_STUB]
# 	A fuller description of managing UEFI environments from within LFS is covered by the lfs-uefi.txt hint at http://www.linuxfromscratch.org/hints/downloads/files/lfs-uefi.txt.

# 	The rationale for the above configuration items:

# 	Support for uevent helper
# 	Having this option set may interfere with device management when using Udev/Eudev.

# 	Maintain a devtmpfs
# 	This will create automated device nodes which are populated by the kernel, even without Udev running. Udev then runs on top of this, managing permissions and adding symlinks. This configuration item is required for all users of Udev/Eudev.

make menuconfig
# 	The meaning of optional make environment variables:

# LANG=<host_LANG_value> LC_ALL=
# This establishes the locale setting to the one used on the host. This may be needed for a proper menuconfig ncurses interface line drawing on a UTF-8 linux text console.

# If used, be sure to replace <host_LANG_value> by the value of the $LANG variable from your host. You can alternatively use instead the host's value of $LC_ALL or $LC_CTYPE.

# 	Alternatively, make oldconfig may be more appropriate in some situations. See the README file for more information.

# 	If desired, skip kernel configuration by copying the kernel config file, .config, from the host system (assuming it is available) to the unpacked linux-4.18.5 directory. However, we do not recommend this option. It is often better to explore all the configuration menus and create the kernel configuration from scratch.

# 		Compile the kernel image and modules:

make
# 		If using kernel modules, module configuration in /etc/modprobe.d may be required. Information pertaining to modules and kernel configuration is located in Section 7.3, “Overview of Device and Module Handling” and in the kernel documentation in the linux-4.18.5/Documentation directory. Also, modprobe.d(5) may be of interest.

# 			Install the modules, if the kernel configuration uses them:

make modules_install
# 			After kernel compilation is complete, additional steps are required to complete the installation. Some files need to be copied to the /boot directory.

# 			[Caution] Caution
# 			If the host system has a separate /boot partition, the files copied below should go there. The easiest way to do that is to bind /boot on the host (outside chroot) to /mnt/lfs/boot before proceeding. As the root user in the host system:

mount --bind /boot /mnt/lfs/boot
# The path to the kernel image may vary depending on the platform being used. The filename below can be changed to suit your taste, but the stem of the filename should be vmlinuz to be compatible with the automatic setup of the boot process described in the next section. The following command assumes an x86 architecture:

cp -iv arch/x86/boot/bzImage /boot/vmlinuz-4.18.5-lfs-8.3
# System.map is a symbol file for the kernel. It maps the function entry points of every function in the kernel API, as well as the addresses of the kernel data structures for the running kernel. It is used as a resource when investigating kernel problems. Issue the following command to install the map file:

cp -iv System.map /boot/System.map-4.18.5
# The kernel configuration file .config produced by the make menuconfig step above contains all the configuration selections for the kernel that was just compiled. It is a good idea to keep this file for future reference:

cp -iv .config /boot/config-4.18.5
# Install the documentation for the Linux kernel:

install -d /usr/share/doc/linux-4.18.5
cp -r Documentation/* /usr/share/doc/linux-4.18.5
# It is important to note that the files in the kernel source directory are not owned by root. Whenever a package is unpacked as user root (like we did inside chroot), the files have the user and group IDs of whatever they were on the packager's computer. This is usually not a problem for any other package to be installed because the source tree is removed after the installation. However, the Linux source tree is often retained for a long time. Because of this, there is a chance that whatever user ID the packager used will be assigned to somebody on the machine. That person would then have write access to the kernel source.

# 					[Note] Note
# 					In many cases, the configuration of the kernel will need to be updated for packages that will be installed later in BLFS. Unlike other packages, it is not necessary to remove the kernel source tree after the newly built kernel is installed.

# 					If the kernel source tree is going to be retained, run chown -R 0:0 on the linux-4.18.5 directory to ensure all files are owned by user root.

# 						[Warning] Warning
# 						Some kernel documentation recommends creating a symlink from /usr/src/linux pointing to the kernel source directory. This is specific to kernels prior to the 2.6 series and must not be created on an LFS system as it can cause problems for packages you may wish to build once your base LFS system is complete.

# 						[Warning] Warning
# 						The headers in the system's include directory (/usr/include) should always be the ones against which Glibc was compiled, that is, the sanitised headers installed in Section 6.7, “Linux-4.18.5 API Headers”. Therefore, they should never be replaced by either the raw kernel headers or any other kernel sanitized headers.

# 						8.3.2. Configuring Linux Module Load Order
# 						Most of the time Linux modules are loaded automatically, but sometimes it needs some specific direction. The program that loads modules, modprobe or insmod, uses /etc/modprobe.d/usb.conf for this purpose. This file needs to be created so that if the USB drivers (ehci_hcd, ohci_hcd and uhci_hcd) have been built as modules, they will be loaded in the correct order; ehci_hcd needs to be loaded prior to ohci_hcd and uhci_hcd in order to avoid a warning being output at boot time.

# Create a new file /etc/modprobe.d/usb.conf by running the following:

install -v -m755 -d /etc/modprobe.d
cat > /etc/modprobe.d/usb.conf << "EOF"
# Begin /etc/modprobe.d/usb.conf

install ohci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i ohci_hcd ; true
install uhci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i uhci_hcd ; true

# End /etc/modprobe.d/usb.conf
EOF
