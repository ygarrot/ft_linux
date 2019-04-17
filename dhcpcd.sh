./configure --libexecdir=/lib/dhcpcd \
            --dbdir=/var/lib/dhcpcd  &&
make
make install
make install-service-dhcpcd

cat > /etc/sysconfig/ifconfig.enp0s3 << "EOF"
ONBOOT="yes"
IFACE="eth0"
SERVICE="dhcpcd"
DHCP_START="-b -q"
DHCP_STOP="-k"
EOF
