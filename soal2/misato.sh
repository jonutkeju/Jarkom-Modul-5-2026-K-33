cat > /root/misato.sh <<'EOF'
#!/bin/sh
# Soal 2 - Misato
ip link set eth0 up; ip addr flush dev eth0; ip addr add 10.80.4.126/30 dev eth0   # Gendo
ip link set eth1 up; ip addr flush dev eth1; ip addr add 10.80.4.65/29 dev eth1   # LAN Cage
sysctl -w net.ipv4.ip_forward=1 >/dev/null 2>&1 || echo 1 > /proc/sys/net/ipv4/ip_forward
EOF
chmod +x /root/misato.sh
{ echo 'auto lo'; echo 'iface lo inet loopback'; echo '  up echo 1 > /proc/sys/net/ipv4/ip_forward'
for x in "eth0 10.80.4.126 255.255.255.252" "eth1 10.80.4.65 255.255.255.248"; do set -- $x; printf 'auto %s\niface %s inet static\n  address %s\n  netmask %s\n' $1 $1 $2 $3; done; echo '  up sh /root/misato.sh'; } > /etc/network/interfaces
sh /root/misato.sh; echo "== Misato: ip_forward=$(cat /proc/sys/net/ipv4/ip_forward) =="; ip -br addr