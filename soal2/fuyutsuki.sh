cat > /root/fuyutsuki.sh <<'EOF'
#!/bin/sh
# Soal 2 - Fuyutsuki
ip link set eth0 up; ip addr flush dev eth0; ip addr add 10.80.4.134/30 dev eth0   # Gendo
ip link set eth1 up; ip addr flush dev eth1; ip addr add 10.80.4.165/30 dev eth1   # Toji
ip link set eth2 up; ip addr flush dev eth2; ip addr add 10.80.4.169/30 dev eth2   # Maya
ip link set eth3 up; ip addr flush dev eth3; ip addr add 10.80.4.57/29 dev eth3   # LAN Terminal
sysctl -w net.ipv4.ip_forward=1 >/dev/null 2>&1 || echo 1 > /proc/sys/net/ipv4/ip_forward
EOF
chmod +x /root/fuyutsuki.sh
{ echo 'auto lo'; echo 'iface lo inet loopback'; echo '  up echo 1 > /proc/sys/net/ipv4/ip_forward'
for x in "eth0 10.80.4.134 255.255.255.252" "eth1 10.80.4.165 255.255.255.252" "eth2 10.80.4.169 255.255.255.252" "eth3 10.80.4.57 255.255.255.248"; do set -- $x; printf 'auto %s\niface %s inet static\n  address %s\n  netmask %s\n' $1 $1 $2 $3; done; echo '  up sh /root/fuyutsuki.sh'; } > /etc/network/interfaces
sh /root/fuyutsuki.sh; echo "== Fuyutsuki: ip_forward=$(cat /proc/sys/net/ipv4/ip_forward) =="; ip -br addr