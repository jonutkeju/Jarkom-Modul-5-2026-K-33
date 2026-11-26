cat > /root/mari.sh <<'EOF'
#!/bin/sh
# Soal 2 - Mari
ip link set eth0 up; ip addr flush dev eth0; ip addr add 10.80.4.142/30 dev eth0   # Yui
ip link set eth1 up; ip addr flush dev eth1; ip addr add 10.80.4.33/28 dev eth1   # LAN Dock
sysctl -w net.ipv4.ip_forward=1 >/dev/null 2>&1 || echo 1 > /proc/sys/net/ipv4/ip_forward
EOF
chmod +x /root/mari.sh
{ echo 'auto lo'; echo 'iface lo inet loopback'; echo '  up echo 1 > /proc/sys/net/ipv4/ip_forward'
for x in "eth0 10.80.4.142 255.255.255.252" "eth1 10.80.4.33 255.255.255.240"; do set -- $x; printf 'auto %s\niface %s inet static\n  address %s\n  netmask %s\n' $1 $1 $2 $3; done; echo '  up sh /root/mari.sh'; } > /etc/network/interfaces
sh /root/mari.sh; echo "== Mari: ip_forward=$(cat /proc/sys/net/ipv4/ip_forward) =="; ip -br addr