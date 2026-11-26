cat > /root/ritsuko.sh <<'EOF'
#!/bin/sh
# Soal 2 - Ritsuko
ip link set eth0 up; ip addr flush dev eth0; ip addr add 10.80.4.158/30 dev eth0   # Asuka
ip link set eth1 up; ip addr flush dev eth1; ip addr add 10.80.4.49/29 dev eth1   # LAN Lab
sysctl -w net.ipv4.ip_forward=1 >/dev/null 2>&1 || echo 1 > /proc/sys/net/ipv4/ip_forward
EOF
chmod +x /root/ritsuko.sh
{ echo 'auto lo'; echo 'iface lo inet loopback'; echo '  up echo 1 > /proc/sys/net/ipv4/ip_forward'
for x in "eth0 10.80.4.158 255.255.255.252" "eth1 10.80.4.49 255.255.255.248"; do set -- $x; printf 'auto %s\niface %s inet static\n  address %s\n  netmask %s\n' $1 $1 $2 $3; done; echo '  up sh /root/ritsuko.sh'; } > /etc/network/interfaces
sh /root/ritsuko.sh; echo "== Ritsuko: ip_forward=$(cat /proc/sys/net/ipv4/ip_forward) =="; ip -br addr