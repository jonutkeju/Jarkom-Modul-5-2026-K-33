#Node: Magi-Casper, Magi-Balthasar, Magi-Melchior (tunggu ±60 detik setelah SETUP).
echo "== $(hostname) =="
iptables -V; nc.traditional -h 2>&1 | head -1
ss -ltn | grep -E ':500[01] '
tail -3 /root/soal7.log 2>/dev/null

#Lilith
NC=$(command -v nc.traditional || command -v nc)
[ -n "$NC" ] || echo "nc tidak ada di Lilith: apt-get update; apt-get install -y netcat-traditional"
echo "== $(hostname) == pakai: $NC"
for t in "10.80.4.58 5000 Casper" "10.80.4.59 5000 Balthasar" "10.80.4.60 5000 Melchior" "10.80.4.59 5001 Balthasar"; do
  set -- $t
  echo "Halo $3, ini pesan dari Lilith ke port $2" | $NC -w 3 $1 $2
  echo "kirim ke $3 $1:$2 exit=$?"
done

#Node: Magi-Casper, Magi-Balthasar, Magi-Melchior.
echo "== $(hostname) =="; for f in /root/nc-*.log; do echo "--- $f"; cat $f; done