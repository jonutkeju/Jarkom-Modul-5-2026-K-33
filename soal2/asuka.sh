cat > /root/asuka.sh <<'EOF'
#!/bin/sh
# Soal 2 - Asuka
ip link set eth0 up; ip addr flush dev eth0; ip addr add 10.80.4.118/30 dev eth0   # Gendo
ip link set eth1 up; ip addr flush dev eth1; ip addr add 10.80.4.153/30 dev eth1   # Kensuke
ip link set eth2 up; ip addr flush dev eth2; ip addr add 10.80.4.157/30 dev eth2   # Ritsuko
ip link set eth3 up; ip addr flush dev eth3; ip addr add 10.80.4.97/30 dev eth3   # LAN Archive
sysctl -w net.ipv4.ip_forward=1 >/dev/null 2>&1 || echo 1 > /proc/sys/net/ipv4/ip_forward
EOF
chmod +x /root/asuka.sh
{ echo 'auto lo'; echo 'iface lo inet loopback'; echo '  up echo 1 > /proc/sys/net/ipv4/ip_forward'
for x in "eth0 10.80.4.118 255.255.255.252" "eth1 10.80.4.153 255.255.255.252" "eth2 10.80.4.157 255.255.255.252" "eth3 10.80.4.97 255.255.255.252"; do set -- $x; printf 'auto %s\niface %s inet static\n  address %s\n  netmask %s\n' $1 $1 $2 $3; done; echo '  up sh /root/asuka.sh'; } > /etc/network/interfaces
sh /root/asuka.sh; echo "== Asuka: ip_forward=$(cat /proc/sys/net/ipv4/ip_forward) =="; ip -br addr