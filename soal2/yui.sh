cat > /root/yui.sh <<'EOF'
#!/bin/sh
# Soal 2 - Yui
ip link set eth0 up; ip addr flush dev eth0; ip addr add 10.80.4.110/30 dev eth0   # Gendo
ip link set eth1 up; ip addr flush dev eth1; ip addr add 10.80.4.145/30 dev eth1   # Shinji
ip link set eth2 up; ip addr flush dev eth2; ip addr add 10.80.4.137/30 dev eth2   # Rei
ip link set eth3 up; ip addr flush dev eth3; ip addr add 10.80.4.141/30 dev eth3   # Mari
ip link set eth4 up; ip addr flush dev eth4; ip addr add 10.80.3.1/25 dev eth4   # LAN Hangar
sysctl -w net.ipv4.ip_forward=1 >/dev/null 2>&1 || echo 1 > /proc/sys/net/ipv4/ip_forward
EOF
chmod +x /root/yui.sh
{ echo 'auto lo'; echo 'iface lo inet loopback'; echo '  up echo 1 > /proc/sys/net/ipv4/ip_forward'
for x in "eth0 10.80.4.110 255.255.255.252" "eth1 10.80.4.145 255.255.255.252" "eth2 10.80.4.137 255.255.255.252" "eth3 10.80.4.141 255.255.255.252" "eth4 10.80.3.1 255.255.255.128"; do set -- $x; printf 'auto %s\niface %s inet static\n  address %s\n  netmask %s\n' $1 $1 $2 $3; done; echo '  up sh /root/yui.sh'; } > /etc/network/interfaces
sh /root/yui.sh; echo "== Yui: ip_forward=$(cat /proc/sys/net/ipv4/ip_forward) =="; ip -br addr