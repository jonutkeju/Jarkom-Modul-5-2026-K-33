F=/root/gendo.sh
[ -f "$F" ] || echo "ERROR: $F tidak ada"
sed -i '/^# --- Soal [345]/,$d; /^# --- tambahan per soal/,$d' "$F"
cat >> "$F" <<'EOS'
# --- Soal 3 (Gendo): routing statis ke bawah (default route dari DHCP NAT1) ---
ip route replace 10.80.0.0/23 via 10.80.4.110
ip route replace 10.80.3.0/25 via 10.80.4.110
ip route replace 10.80.4.0/27 via 10.80.4.110
ip route replace 10.80.4.32/28 via 10.80.4.110
ip route replace 10.80.4.136/29 via 10.80.4.110
ip route replace 10.80.4.144/30 via 10.80.4.110
ip route replace 10.80.2.0/24 via 10.80.4.114
ip route replace 10.80.3.224/27 via 10.80.4.114
ip route replace 10.80.4.148/30 via 10.80.4.114
ip route replace 10.80.3.128/26 via 10.80.4.118
ip route replace 10.80.4.48/29 via 10.80.4.118
ip route replace 10.80.4.96/30 via 10.80.4.118
ip route replace 10.80.4.152/29 via 10.80.4.118
ip route replace 10.80.4.100/30 via 10.80.4.122
ip route replace 10.80.4.64/29 via 10.80.4.126
ip route replace 10.80.4.80/28 via 10.80.4.130
ip route replace 10.80.4.160/30 via 10.80.4.130
ip route replace 10.80.3.192/27 via 10.80.4.134
ip route replace 10.80.4.56/29 via 10.80.4.134
ip route replace 10.80.4.72/29 via 10.80.4.134
ip route replace 10.80.4.164/30 via 10.80.4.134
ip route replace 10.80.4.168/30 via 10.80.4.134
# --- Soal 4: DNS + NAT (MASQUERADE hanya prefix internal yang keluar lewat eth0/NAT1) ---
printf 'nameserver 8.8.8.8\n' > /etc/resolv.conf
iptables -t nat -C POSTROUTING -s 10.80.0.0/16 -o eth0 -j MASQUERADE 2>/dev/null || \
  iptables -t nat -A POSTROUTING -s 10.80.0.0/16 -o eth0 -j MASQUERADE
# --- Soal 5: firewall (INPUT/FORWARD DROP; eth0 = sisi NAT1, eth1-eth8 = sisi internal) ---
IF_IN="eth1 eth2 eth3 eth4 eth5 eth6 eth7 eth8"
iptables -P INPUT ACCEPT; iptables -P FORWARD ACCEPT; iptables -P OUTPUT ACCEPT
iptables -F INPUT; iptables -F FORWARD
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -i eth0 -p udp --sport 67 --dport 68 -j ACCEPT
iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
for i in $IF_IN; do
  iptables -A INPUT -i $i -s 10.80.0.0/16 -j ACCEPT
  iptables -A FORWARD -i $i -s 10.80.0.0/16 -o eth0 -j ACCEPT
  iptables -A FORWARD -i $i -s 10.80.0.0/16 -d 10.80.0.0/16 -j ACCEPT
done
iptables -P INPUT DROP; iptables -P FORWARD DROP
# --- tambahan per soal: soal1.sh ... soal20.sh (otomatis ikut, urut angka) ---
for n in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20; do [ -f /root/soal$n.sh ] && sh /root/soal$n.sh; done; true
EOS
rm -f /root/soal3.sh /root/soal4.sh
sh "$F"
echo "== $(hostname) =="; tail -4 "$F"; ip route | wc -l; iptables -S