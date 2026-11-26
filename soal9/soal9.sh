#unduh
rm -f /root/break_routing.sh
wget -O /root/break_routing.sh "https://drive.usercontent.google.com/download?id=1ub7LjL2BdZdVq6n_AbuqcO416Z8QJGVs&export=download&confirm=t"
ls -l /root/break_routing.sh; grep -c -i '<html' /root/break_routing.sh

#snapshot sebelum (Shigeru)
snap() {
  echo "### addr"; ip -br addr
  echo "### link"; ip -d link | grep -E '^[0-9]|mtu|state'
  echo "### route"; ip route
  echo "### rule"; ip rule
  echo "### neigh"; ip neigh
  echo "### proc"; for f in /proc/sys/net/ipv4/ip_forward /proc/sys/net/ipv4/icmp_echo_ignore_all /proc/sys/net/ipv4/conf/*/rp_filter /proc/sys/net/ipv4/conf/*/forwarding /proc/sys/net/ipv4/conf/*/send_redirects /proc/sys/net/ipv4/conf/*/proxy_arp /proc/sys/net/ipv4/conf/*/arp_ignore; do echo "$f=$(cat $f 2>/dev/null)"; done
  echo "### iptables"; iptables-save 2>/dev/null
  echo "### nft"; nft list ruleset 2>/dev/null
  echo "### tc"; tc qdisc show 2>/dev/null
  echo "### files"; md5sum /root/*.sh /etc/network/interfaces /etc/resolv.conf 2>/dev/null
}
snap > /root/before.txt; wc -l /root/before.txt

#Baseline
#Lilith
t(){ if "$@" >/dev/null 2>&1; then echo "PASS $*"; else echo "FAIL $*"; fi; }
echo "== $(hostname) =="; t ping -c3 -W2 10.80.4.83

#Armisael
t(){ if "$@" >/dev/null 2>&1; then echo "PASS $*"; else echo "FAIL $*"; fi; }
echo "== $(hostname) =="; t ping -c3 -W2 10.80.4.81; t ping -c3 -W2 10.80.4.74

#Kalau semuanya PASS, kembali ke Shigeru dan jalankan sabotase:
sh /root/break_routing.sh
snap > /root/after.txt
diff /root/before.txt /root/after.txt

#baseline
#Lilith
t(){ if "$@" >/dev/null 2>&1; then echo "PASS $*"; else echo "FAIL $*"; fi; }
echo "== $(hostname) =="; t ping -c3 -W2 10.80.4.83

#Armisael
t(){ if "$@" >/dev/null 2>&1; then echo "PASS $*"; else echo "FAIL $*"; fi; }
echo "== $(hostname) =="; t ping -c3 -W2 10.80.4.81; t ping -c3 -W2 10.80.4.74

#Semua harus PASS

#Sabotase + diff Shigeru
sh /root/break_routing.sh
snap > /root/after.txt
diff /root/before.txt /root/after.txt

#tes gejala
#Lilith
t(){ if "$@" >/dev/null 2>&1; then echo "PASS $*"; else echo "FAIL $*"; fi; }
echo "== $(hostname) =="; t ping -c3 -W2 10.80.4.83
#Haeus FAIL

#Armisael
t(){ if "$@" >/dev/null 2>&1; then echo "PASS $*"; else echo "FAIL $*"; fi; }
echo "== $(hostname) =="; t ping -c3 -W2 10.80.4.81
#Harus PASS

#Perbaikan -Shigeru
echo "### SEBELUM DIBERSIHKAN"; ip rule; echo "-- table 100:"; ip route show table 100; echo "-- semua tabel:"; ip route show table all | grep -v -E '^(local|broadcast|multicast)|table local'

# 1. forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward
for i in all default eth0 eth1 eth2 eth3; do echo 1 > /proc/sys/net/ipv4/conf/$i/forwarding; done
# 2. blackhole
ip route del blackhole 10.80.4.72/29 2>/dev/null
# 3. policy rule + tabel 100
while ip rule del priority 90 2>/dev/null; do :; done
ip route flush table 100
# 4. default route
ip route replace default via 10.80.4.129 dev eth0

echo "### SESUDAH"; ip rule; ip route; cat /proc/sys/net/ipv4/ip_forward

#Lilith
t(){ if "$@" >/dev/null 2>&1; then echo "PASS $*"; else echo "FAIL $*"; fi; }
echo "== $(hostname) =="; t ping -c3 -W2 10.80.4.83

#Armisael
t(){ if "$@" >/dev/null 2>&1; then echo "PASS $*"; else echo "FAIL $*"; fi; }
echo "== $(hostname) =="; t ping -c3 -W2 10.80.4.81; t ping -c3 -W2 10.80.4.74; t ping -c3 -W2 8.8.8.8

#Shigeru
snap > /root/fixed.txt
diff /root/before.txt /root/fixed.txt

#Simpan di Shigeru
cat > /root/fix9.sh <<'EOF'
echo 1 > /proc/sys/net/ipv4/ip_forward
for i in all default eth0 eth1 eth2 eth3; do echo 1 > /proc/sys/net/ipv4/conf/$i/forwarding; done
ip route del blackhole 10.80.4.72/29 2>/dev/null
while ip rule del priority 90 2>/dev/null; do :; done
ip route flush table 100
ip route replace default via 10.80.4.129 dev eth0
EOF
ls -l /root/fix9.sh
