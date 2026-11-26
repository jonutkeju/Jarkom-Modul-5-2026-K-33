# 1. fix10.sh
cat > /root/fix10.sh <<'EOF'
#!/bin/sh
# Soal 10: bersihkan sabotase NAT untuk subnet Cage (10.80.4.64/29)
# Gendo : rule RETURN sebelum MASQUERADE  | Misato: rule SNAT ke 172.31.99.1
# Aman dijalankan berulang di Gendo maupun Misato.
while iptables -t nat -D POSTROUTING -s 10.80.4.64/29 -o eth0 -j RETURN 2>/dev/null; do :; done
while iptables -t nat -D POSTROUTING -s 10.80.4.64/29 ! -d 10.80.0.0/16 -o eth0 -j SNAT --to-source 172.31.99.1 2>/dev/null; do :; done
# Hanya Gendo (punya alamat NAT1 192.168.122.x): pastikan MASQUERADE ada dan DNS benar
if ip -o addr show 2>/dev/null | grep -q ' 192\.168\.122\.'; then
  iptables -t nat -C POSTROUTING -s 10.80.0.0/16 -o eth0 -j MASQUERADE 2>/dev/null || iptables -t nat -A POSTROUTING -s 10.80.0.0/16 -o eth0 -j MASQUERADE
  printf 'nameserver 8.8.8.8\n' > /etc/resolv.conf
fi
command -v conntrack >/dev/null 2>&1 && conntrack -F >/dev/null 2>&1
echo "fix10 selesai"
EOF
sh -n /root/fix10.sh && echo SYNTAX_OK

# 2. unduh + tcpdump (sebelum sabotase)
command -v wget >/dev/null || apt-get install -y wget ca-certificates
[ -s /root/break_nat.sh ] || wget -O /root/break_nat.sh "https://drive.usercontent.google.com/download?id=1oX7r9BmMPumqrIb71Vbk43Y6CQEOvDRJ&export=download&confirm=t"
command -v tcpdump >/dev/null || apt-get install -y tcpdump
ls -l /root/break_nat.sh; grep -c -i '<html' /root/break_nat.sh

# 3. snap.sh
cat > /root/snap.sh <<'EOF'
snap() {
  echo "### addr"; ip -br addr
  echo "### route"; ip route
  echo "### rule"; ip rule
  echo "### proc"; for f in /proc/sys/net/ipv4/ip_forward /proc/sys/net/ipv4/conf/*/rp_filter /proc/sys/net/ipv4/conf/*/forwarding /proc/sys/net/ipv4/conf/*/send_redirects; do echo "$f=$(cat $f 2>/dev/null)"; done
  echo "### iptables"; iptables-save 2>/dev/null
  echo "### nft"; nft list ruleset 2>/dev/null
  echo "### files"; md5sum /root/*.sh /etc/network/interfaces /etc/resolv.conf 2>/dev/null
}
EOF

# 4. pastikan sehat, lalu snapshot sebelum
sh /root/fix10.sh
. /root/snap.sh
snap > /root/before10.txt; wc -l /root/before10.txt

#Pengujian (PASS)
#Unit 01, Unit 02, Unit 00
t(){ if "$@" >/dev/null 2>&1; then echo "PASS $*"; else echo "FAIL $*"; fi; }
echo "== $(hostname) =="; t ping -c3 -W2 10.80.4.65; t ping -c3 -W2 10.80.4.74; t ping -c3 -W2 8.8.8.8
#SPY
t(){ if "$@" >/dev/null 2>&1; then echo "PASS $*"; else echo "FAIL $*"; fi; }
echo "== $(hostname) =="; t ping -c3 -W2 10.80.4.101; t ping -c3 -W2 8.8.8.8

#Misato
sh /root/break_nat.sh
. /root/snap.sh; snap > /root/after10.txt; diff /root/before10.txt /root/after10.txt

#Gendou
sh /root/break_nat.sh
. /root/snap.sh; snap > /root/after10.txt; diff /root/before10.txt /root/after10.txt

#Pengujian 
#Unit 01, Unit 02, Unit 00 (FAIL ke 8.8.8.8)
t(){ if "$@" >/dev/null 2>&1; then echo "PASS $*"; else echo "FAIL $*"; fi; }
echo "== $(hostname) =="; t ping -c3 -W2 10.80.4.65; t ping -c3 -W2 10.80.4.74; t ping -c3 -W2 8.8.8.8
#SPY (PASS)
t(){ if "$@" >/dev/null 2>&1; then echo "PASS $*"; else echo "FAIL $*"; fi; }
echo "== $(hostname) =="; t ping -c3 -W2 10.80.4.101; t ping -c3 -W2 8.8.8.8

#Perbaikan (Misato & Gendou)
sh /root/fix10.sh
iptables -t nat -S POSTROUTING

#Pengujian (PASS)
#Unit 01, Unit 02, Unit 00
t(){ if "$@" >/dev/null 2>&1; then echo "PASS $*"; else echo "FAIL $*"; fi; }
echo "== $(hostname) =="; t ping -c3 -W2 10.80.4.65; t ping -c3 -W2 10.80.4.74; t ping -c3 -W2 8.8.8.8
#SPY
t(){ if "$@" >/dev/null 2>&1; then echo "PASS $*"; else echo "FAIL $*"; fi; }
echo "== $(hostname) =="; t ping -c3 -W2 10.80.4.101; t ping -c3 -W2 8.8.8.8

#bukti di router mana alamat sumber diterjemahkan
#Misato
tcpdump -ni eth0 -c 6 icmp
#Gendou
tcpdump -ni any -c 12 'icmp and host 8.8.8.8'
#Unit 01
ping -c3 8.8.8.8

#Counter NAT di Gendou
iptables -t nat -L POSTROUTING -n -v

#Bukti state kembali (Misato dan Gendo):
. /root/snap.sh; snap > /root/fixed10.txt
cl(){ awk -v s="### $2" '$0==s{f=1;next} /^### /{f=0} f' "$1" | grep -v '^#' | sed 's/ \[[0-9]*:[0-9]*\]//'; }
for s in route rule proc iptables; do cl /root/before10.txt $s > /tmp/a.$s; cl /root/fixed10.txt $s > /tmp/b.$s; if diff /tmp/a.$s /tmp/b.$s >/dev/null; then echo "SAMA  $s"; else echo "BEDA  $s"; diff /tmp/a.$s /tmp/b.$s; fi; done

#Gendo: cek DNS setelah resolv.conf dipulihkan
cat /etc/resolv.conf; ping -c2 -W2 deb.debian.org