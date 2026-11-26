cat > /root/hikari.sh <<'EOF'
#!/bin/sh
# Soal 2 - Hikari
ip link set eth0 up; ip addr flush dev eth0; ip addr add 10.80.4.114/30 dev eth0   # Gendo
ip link set eth1 up; ip addr flush dev eth1; ip addr add 10.80.4.149/30 dev eth1   # Kaworu
ip link set eth2 up; ip addr flush dev eth2; ip addr add 10.80.2.1/24 dev eth2   # LAN Comm
sysctl -w net.ipv4.ip_forward=1 >/dev/null 2>&1 || echo 1 > /proc/sys/net/ipv4/ip_forward
EOF
chmod +x /root/hikari.sh
{ echo 'auto lo'; echo 'iface lo inet loopback'; echo '  up echo 1 > /proc/sys/net/ipv4/ip_forward'
for x in "eth0 10.80.4.114 255.255.255.252" "eth1 10.80.4.149 255.255.255.252" "eth2 10.80.2.1 255.255.255.0"; do set -- $x; printf 'auto %s\niface %s inet static\n  address %s\n  netmask %s\n' $1 $1 $2 $3; done; echo '  up sh /root/hikari.sh'; } > /etc/network/interfaces
sh /root/hikari.sh; echo "== Hikari: ip_forward=$(cat /proc/sys/net/ipv4/ip_forward) =="; ip -br addr