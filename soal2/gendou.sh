cat > /root/gendo.sh <<'EOF'
#!/bin/sh
# Soal 2 - Gendo
ip link set eth0 up
if ! ip -4 addr show dev eth0 | grep -q 'inet '; then
  if command -v dhclient >/dev/null 2>&1; then dhclient eth0
  elif command -v udhcpc >/dev/null 2>&1; then udhcpc -i eth0 -n -q
  elif [ -x /gns3/bin/busybox ]; then /gns3/bin/busybox udhcpc -i eth0 -n -q
  else echo "ERROR: tidak ada DHCP client" >&2; fi
fi
ip link set eth1 up; ip addr flush dev eth1; ip addr add 10.80.4.109/30 dev eth1   # Yui
ip link set eth2 up; ip addr flush dev eth2; ip addr add 10.80.4.113/30 dev eth2   # Hikari
ip link set eth3 up; ip addr flush dev eth3; ip addr add 10.80.4.117/30 dev eth3   # Asuka
ip link set eth4 up; ip addr flush dev eth4; ip addr add 10.80.4.121/30 dev eth4   # Kaji
ip link set eth5 up; ip addr flush dev eth5; ip addr add 10.80.4.125/30 dev eth5   # Misato
ip link set eth6 up; ip addr flush dev eth6; ip addr add 10.80.4.129/30 dev eth6   # Shigeru
ip link set eth7 up; ip addr flush dev eth7; ip addr add 10.80.4.133/30 dev eth7   # Fuyutsuki
ip link set eth8 up; ip addr flush dev eth8; ip addr add 10.80.4.105/30 dev eth8   # LAN Cmd
sysctl -w net.ipv4.ip_forward=1 >/dev/null 2>&1 || echo 1 > /proc/sys/net/ipv4/ip_forward
EOF
chmod +x /root/gendo.sh
{ echo 'auto lo'; echo 'iface lo inet loopback'; echo '  up echo 1 > /proc/sys/net/ipv4/ip_forward'
echo 'auto eth0'; echo 'iface eth0 inet dhcp'
for x in "eth1 10.80.4.109 255.255.255.252" "eth2 10.80.4.113 255.255.255.252" "eth3 10.80.4.117 255.255.255.252" "eth4 10.80.4.121 255.255.255.252" "eth5 10.80.4.125 255.255.255.252" "eth6 10.80.4.129 255.255.255.252" "eth7 10.80.4.133 255.255.255.252" "eth8 10.80.4.105 255.255.255.252"; do set -- $x; printf 'auto %s\niface %s inet static\n  address %s\n  netmask %s\n' $1 $1 $2 $3; done; echo '  up sh /root/gendo.sh'; } > /etc/network/interfaces
sh /root/gendo.sh; echo "== Gendo: ip_forward=$(cat /proc/sys/net/ipv4/ip_forward) =="; ip -br addr; ip route | grep default