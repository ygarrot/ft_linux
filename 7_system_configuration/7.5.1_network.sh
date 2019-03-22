#!/bin/bash
# 7.5.1. Creating Network Interface Configuration Files
# Which interfaces are brought up and down by the network script usually depends on the files in /etc/sysconfig/. This directory should contain a file for each interface to be configured, such as ifconfig.xyz, where “xyz” should describe the network card. The interface name (e.g. eth0) is usually appropriate. Inside this file are attributes to this interface, such as its IP address(es), subnet masks, and so forth. It is necessary that the stem of the filename be ifconfig.

# [Note] Note
# If the procedure in the previous section was not used, Udev will assign network card interface names based on system physical characteristics such as enp2s1. If you are not sure what your interface name is, you can always run ip link or ls /sys/class/net after you have booted your system.

# 	The following command creates a sample file for the eth0 device with a static IP address:

cd /etc/sysconfig/
cat > ifconfig.eth0 << "EOF"
ONBOOT=yes
IFACE=eth0
SERVICE=ipv4-static
IP=192.168.1.2
GATEWAY=192.168.1.1
PREFIX=24
BROADCAST=192.168.1.255
EOF
# The values of these variables must be changed in every file to match the proper setup.

# If the ONBOOT variable is set to “yes” the System V network script will bring up the Network Interface Card (NIC) during booting of the system. If set to anything but “yes” the NIC will be ignored by the network script and not be automatically brought up. The interface can be manually started or stopped with the ifup and ifdown commands.

# 	The IFACE variable defines the interface name, for example, eth0. It is required for all network device configuration files.

# 	The SERVICE variable defines the method used for obtaining the IP address. The LFS-Bootscripts package has a modular IP assignment format, and creating additional files in the /lib/services/ directory allows other IP assignment methods. This is commonly used for Dynamic Host Configuration Protocol (DHCP), which is addressed in the BLFS book.

# 	The GATEWAY variable should contain the default gateway IP address, if one is present. If not, then comment out the variable entirely.

# 	The PREFIX variable contains the number of bits used in the subnet. Each octet in an IP address is 8 bits. If the subnet's netmask is 255.255.255.0, then it is using the first three octets (24 bits) to specify the network number. If the netmask is 255.255.255.240, it would be using the first 28 bits. Prefixes longer than 24 bits are commonly used by DSL and cable-based Internet Service Providers (ISPs). In this example (PREFIX=24), the netmask is 255.255.255.0. Adjust the PREFIX variable according to your specific subnet. If omitted, the PREFIX defaults to 24.

# 	For more information see the ifup man page.

# 		7.5.2. Creating the /etc/resolv.conf File
# 		The system will need some means of obtaining Domain Name Service (DNS) name resolution to resolve Internet domain names to IP addresses, and vice versa. This is best achieved by placing the IP address of the DNS server, available from the ISP or network administrator, into /etc/resolv.conf. Create the file by running the following:

cat > /etc/resolv.conf << "EOF"
# Begin /etc/resolv.conf

domain google.com
nameserver 8.8.8.8
nameserver 8.8.8.4

# End /etc/resolv.conf
EOF
# The domain statement can be omitted or replaced with a search statement. See the man page for resolv.conf for more details.

# Replace <IP address of the nameserver> with the IP address of the DNS most appropriate for the setup. There will often be more than one entry (requirements demand secondary servers for fallback capability). If you only need or want one DNS server, remove the second nameserver line from the file. The IP address may also be a router on the local network.

# [Note] Note
# The Google Public IPv4 DNS addresses are 8.8.8.8 and 8.8.4.4.

# 7.5.3. Configuring the system hostname
# During the boot process, the file /etc/hostname is used for establishing the system's hostname.

# Create the /etc/hostname file and enter a hostname by running:

echo "ygarrot" > /etc/hostname
# echo "<lfs>" > /etc/hostname
# <lfs> needs to be replaced with the name given to the computer. Do not enter the Fully Qualified Domain Name (FQDN) here. That information is put in the /etc/hosts file.

# 7.5.4. Customizing the /etc/hosts File
# Decide on the IP address, fully-qualified domain name (FQDN), and possible aliases for use in the /etc/hosts file. The syntax is:

# IP_address myhost.example.org aliases
# Unless the computer is to be visible to the Internet (i.e., there is a registered domain and a valid block of assigned IP addresses—most users do not have this), make sure that the IP address is in the private network IP address range. Valid ranges are:

# Private Network Address Range      Normal Prefix
# 10.0.0.1 - 10.255.255.254           8
# 172.x.0.1 - 172.x.255.254           16
# 192.168.y.1 - 192.168.y.254         24
# x can be any number in the range 16-31. y can be any number in the range 0-255.

# A valid private IP address could be 192.168.1.1. A valid FQDN for this IP could be lfs.example.org.

# Even if not using a network card, a valid FQDN is still required. This is necessary for certain programs to operate correctly.

# Create the /etc/hosts file by running:

cat > /etc/hosts << "EOF"
# Begin /etc/hosts

127.0.0.1 localhost
# 127.0.1.1 <FQDN> <HOSTNAME>
# <192.168.1.1> <FQDN> <HOSTNAME> [alias1] [alias2 ...]
::1       localhost ip6-localhost ip6-loopback
ff02::1   ip6-allnodes
ff02::2   ip6-allrouters

# End /etc/hosts
EOF
# The <192.168.1.1>, <FQDN>, and <HOSTNAME> values need to be changed for specific uses or requirements (if assigned an IP address by a network/system administrator and the machine will be connected to an existing network). The optional alias name(s) can be omitted.
