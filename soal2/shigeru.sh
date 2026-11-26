cat > /root/shigeru.sh <<'EOF'
#!/bin/sh
# Soal 2 - Shigeru
ip link set eth0 up; ip addr flush dev eth0; ip addr add 10.80.4.130/30 dev eth0   # Gendo
ip link set eth1 up; ip addr flush dev eth1; ip addr add 10.80.4.161/30 dev eth1   # Makoto
ip link set eth2 up; ip addr flush dev eth2; ip addr add 10.80.4.81/29 dev eth2   # LAN Monolith
sysctl -w net.ipv4.ip_forward=1 >/dev/null 2>&1 || echo 1 > /proc/sys/net/ipv4/ip_forward
EOF
chmod +x /root/shigeru.sh
{ echo 'auto lo'; echo 'iface lo inet loopback'; echo '  up echo 1 > /proc/sys/net/ipv4/ip_forward'
for x in "eth0 10.80.4.130 255.255.255.252" "eth1 10.80.4.161 255.255.255.252" "eth2 10.80.4.81 255.255.255.248"; do set -- $x; printf 'auto %s\niface %s inet static\n  address %s\n  netmask %s\n' $1 $1 $2 $3; done; echo '  up sh /root/shigeru.sh'; } > /etc/network/interfaces
sh /root/shigeru.sh; echo "== Shigeru: ip_forward=$(cat /proc/sys/net/ipv4/ip_forward) =="; ip -br addr