# Well done! The new LFS system is installed! We wish you much success with your shiny new custom-built Linux system.

# It may be a good idea to create an /etc/lfs-release file. By having this file, it is very easy for you (and for us if you need to ask for help at some point) to find out which LFS version is installed on the system. Create this file by running:

echo 8.3 > /etc/lfs-release
# It is also a good idea to create a file to show the status of your new system with respect to the Linux Standards Base (LSB). To create this file, run:

cat > /etc/lsb-release << "EOF"
DISTRIB_ID="Linux From Scratch"
DISTRIB_RELEASE="8.3"
DISTRIB_CODENAME="<your name here>"
DISTRIB_DESCRIPTION="Linux From Scratch"
EOF
# Be sure to put some sort of customization for the field 'DISTRIB_CODENAME' to make the system uniquely yours.
