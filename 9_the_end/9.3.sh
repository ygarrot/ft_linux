#!/bin/bash
# Now that all of the software has been installed, it is time to reboot your computer. However, you should be aware of a few things. The system you have created in this book is quite minimal, and most likely will not have the functionality you would need to be able to continue forward. By installing a few extra packages from the BLFS book while still in our current chroot environment, you can leave yourself in a much better position to continue on once you reboot into your new LFS installation. Here are some suggestions:

# A text mode browser such as Lynx will allow you to easily view the BLFS book in one virtual terminal, while building packages in another.

# The GPM package will allow you to perform copy/paste actions in your virtual terminals.

# If you are in a situation where static IP configuration does not meet your networking requirements, installing a package such as dhcpcd or the client portion of dhcp may be useful.

# 	Installing sudo may be useful for building packages as a non-root user and easily installing the resulting packages in your new system.

# 	If you want to access your new system from a remote system within a comfortable GUI environment, install openssh.

# 		To make fetching files over the internet easier, install wget.

# 		If one or more of your disk drives have a GUID partition table (GPT), either gptfdisk or parted will be useful.

# 			Finally, a review of the following configuration files is also appropriate at this point.

# 			/etc/bashrc

# 			/etc/dircolors

# 			/etc/fstab

# 			/etc/hosts

# 			/etc/inputrc

# 			/etc/profile

# 			/etc/resolv.conf

# 			/etc/vimrc

# 			/root/.bash_profile

# 			/root/.bashrc

# 			/etc/sysconfig/network

# 			/etc/sysconfig/ifconfig.eth0

# 			Now that we have said that, let's move on to booting our shiny new LFS installation for the first time! First exit from the chroot environment:

logout
# Then unmount the virtual file systems:

umount -v $LFS/dev/pts
umount -v $LFS/dev
umount -v $LFS/run
umount -v $LFS/proc
umount -v $LFS/sys
Unmount the LFS file system itself:

umount -v $LFS
# If multiple partitions were created, unmount the other partitions before unmounting the main one, like this:

umount -v $LFS/usr
umount -v $LFS/home
umount -v $LFS
# Now, reboot the system with:

shutdown -r now
# Assuming the GRUB boot loader was set up as outlined earlier, the menu is set to boot LFS 8.3 automatically.

# When the reboot is complete, the LFS system is ready for use and more software may be added to suit your needs.
