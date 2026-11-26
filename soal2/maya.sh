cat > /root/maya.sh <<'EOF'
#!/bin/sh
# Soal 2 - Maya
ip link set eth0 up; ip addr flush dev eth0; ip addr add 10.80.4.170/30 dev eth0   # Fuyutsuki
ip link set eth1 up; ip addr flush dev eth1; ip addr add 10.80.3.193/27 dev eth1   # LAN Medic
sysctl -w net.ipv4.ip_forward=1 >/dev/null 2>&1 || echo 1 > /proc/sys/net/ipv4/ip_forward
EOF
chmod +x /root/maya.sh
{ echo 'auto lo'; echo 'iface lo inet loopback'; echo '  up echo 1 > /proc/sys/net/ipv4/ip_forward'
for x in "eth0 10.80.4.170 255.255.255.252" "eth1 10.80.3.193 255.255.255.224"; do set -- $x; printf 'auto %s\niface %s inet static\n  address %s\n  netmask %s\n' $1 $1 $2 $3; done; echo '  up sh /root/maya.sh'; } > /etc/network/interfaces
sh /root/maya.sh; echo "== Maya: ip_forward=$(cat /proc/sys/net/ipv4/ip_forward) =="; ip -br addr