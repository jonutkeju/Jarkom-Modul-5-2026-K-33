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

nft delete table ip nat
. /root/snap.sh; snap > /root/fixed10.txt
cl(){ awk -v s="### $2" '$0==s{f=1;next} /^### /{f=0} f' "$1" | grep -v '^#' | sed 's/ \[[0-9]*:[0-9]*\]//'; }
for s in route rule proc iptables; do cl /root/before10.txt $s > /tmp/a.$s; cl /root/fixed10.txt $s > /tmp/b.$s; if diff /tmp/a.$s /tmp/b.$s >/dev/null; then echo "SAMA  $s"; else echo "BEDA  $s"; diff /tmp/a.$s /tmp/b.$s; fi; done

#Gendo: cek DNS setelah resolv.conf dipulihkan
cat /etc/resolv.conf; ping -c2 -W2 deb.debian.org