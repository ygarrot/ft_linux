#!/bin/bash
# Now that a file system has been created, the partition needs to be made accessible. In order to do this, the partition needs to be mounted at a chosen mount point. For the purposes of this book, it is assumed that the file system is mounted under the directory specified by the LFS environment variable as described in the previous section.

# Create the mount point and mount the LFS file system by running:

mkdir -pv $LFS
mount -v -t ext4 /dev/<xxx> $LFS
# Replace <xxx> with the designation of the LFS partition.

# If using multiple partitions for LFS (e.g., one for / and another for /usr), mount them using:

mkdir -pv $LFS
mount -v -t ext4 /dev/<xxx> $LFS
mkdir -v $LFS/usr
mount -v -t ext4 /dev/<yyy> $LFS/usr
Replace <xxx> and <yyy> with the appropriate partition names.

# Ensure that this new partition is not mounted with permissions that are too restrictive (such as the nosuid or nodev options). Run the mount command without any parameters to see what options are set for the mounted LFS partition. If nosuid and/or nodev are set, the partition will need to be remounted.

# [Warning] Warning
# The above instructions assume that you will not be restarting your computer throughout the LFS process. If you shut down your system, you will either need to remount the LFS partition each time you restart the build process or modify your host system's /etc/fstab file to automatically remount it upon boot. For example:

# /dev/<xxx>  /mnt/lfs ext4   defaults      1     1
# If you use additional optional partitions, be sure to add them also.

# 	If you are using a swap partition, ensure that it is enabled using the swapon command:

# 		/sbin/swapon -v /dev/<zzz>
# 		Replace <zzz> with the name of the swap partition.

# 		Now that there is an established place to work, it is time to download the packages.
