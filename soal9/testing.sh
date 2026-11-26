#Shigeru
ls -l /root/break_routing.sh /root/soal9.sh /root/snap.sh
ip rule; cat /proc/sys/net/ipv4/ip_forward; ip route
#kalau belum ada break_routing.sh, unduh di Shigeru:
wget -O /root/break_routing.sh "https://drive.usercontent.google.com/download?id=1ub7LjL2BdZdVq6n_AbuqcO416Z8QJGVs&export=download&confirm=t"
ls -l /root/break_routing.sh; grep -c -i '<html' /root/break_routing.sh

#SNAPSHOT SEBELUM (Shigeru)
. /root/snap.sh
snap > /root/before.txt; wc -l /root/before.txt

#BASELINE (screenshot #1)
#Lilith
t(){ if "$@" >/dev/null 2>&1; then echo "PASS $*"; else echo "FAIL $*"; fi; }
echo "== $(hostname) =="; t ping -c3 -W2 10.80.4.83
#Armisael
t(){ if "$@" >/dev/null 2>&1; then echo "PASS $*"; else echo "FAIL $*"; fi; }
echo "== $(hostname) =="; t ping -c3 -W2 10.80.4.81; t ping -c3 -W2 10.80.4.74

#SABOTASE + DIFF (Shigeru)
sh /root/break_routing.sh
snap > /root/after.txt; diff /root/before.txt /root/after.txt

#tes gejala
#Lilith
t(){ if "$@" >/dev/null 2>&1; then echo "PASS $*"; else echo "FAIL $*"; fi; }
echo "== $(hostname) =="; t ping -c3 -W2 10.80.4.83
#Armisael
t(){ if "$@" >/dev/null 2>&1; then echo "PASS $*"; else echo "FAIL $*"; fi; }
echo "== $(hostname) =="; t ping -c3 -W2 10.80.4.81; t ping -c3 -W2 10.80.4.74

#Perbaikan (Shigeru)
echo "### SEBELUM"; ip rule; ip route show table 100; ip route
sh /root/soal9.sh
echo "### SESUDAH"; ip rule; ip route; cat /proc/sys/net/ipv4/ip_forward

#tes gejala
#Lilith
t(){ if "$@" >/dev/null 2>&1; then echo "PASS $*"; else echo "FAIL $*"; fi; }
echo "== $(hostname) =="; t ping -c3 -W2 10.80.4.83
#Armisael
t(){ if "$@" >/dev/null 2>&1; then echo "PASS $*"; else echo "FAIL $*"; fi; }
echo "== $(hostname) =="; t ping -c3 -W2 10.80.4.81; t ping -c3 -W2 10.80.4.74; t ping -c3 -W2 8.8.8.8

#bukti state kembali (Shigeru)
snap > /root/fixed.txt; diff /root/before.txt /root/fixed.txt