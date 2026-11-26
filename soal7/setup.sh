#Node: Magi-Casper, Magi-Balthasar, Magi-Melchior.
H=$(hostname | tr 'A-Z' 'a-z')
PORTS=
case "$H" in
  *casper*)    PORTS="5000" ;;
  *balthasar*) PORTS="5000 5001" ;;
  *melchior*)  PORTS="5000" ;;
esac
F=/root/$H.sh
if [ -z "$PORTS" ]; then
  echo "ERROR: hostname '$H' bukan Magi-Casper/Balthasar/Melchior, tidak ada yang diubah"
elif [ ! -f "$F" ]; then
  echo "ERROR: $F tidak ada (jalankan script Soal 6 dulu)"
else
  sed -i '/^# --- Soal 7/,$d; /^# --- tambahan per soal/,$d' "$F"
  echo "# --- Soal 7: pasang iptables + netcat-traditional, nyalakan listener nc ---" >> "$F"
  echo "PORTS=\"$PORTS\"" >> "$F"
  cat >> "$F" <<'EOF'
soal7() {
  i=0
  until command -v iptables >/dev/null 2>&1 && command -v nc.traditional >/dev/null 2>&1; do
    apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -y iptables netcat-traditional && break
    i=$((i+1)); [ $i -ge 30 ] && break; sleep 5
  done
  for p in $PORTS; do
    ss -ltn | grep -q ":$p " && continue
    ( while true; do
        nc.traditional -l -p $p </dev/null | while IFS= read -r l || [ -n "$l" ]; do echo "$(date '+%F %T') [port $p] $l" >> /root/nc-$p.log; done
        sleep 0.2 2>/dev/null || sleep 1
      done ) &
  done
}
( trap '' HUP; soal7 ) </dev/null >>/root/soal7.log 2>&1 &
# --- tambahan per soal: soal1.sh ... soal20.sh (otomatis ikut, urut angka) ---
for n in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20; do [ -f /root/soal$n.sh ] && sh /root/soal$n.sh; done; true
EOF
  sh "$F"
  echo "== $(hostname) == listener dan paket dipasang di background, tunggu sampai 60 detik lalu jalankan tes"; tail -5 "$F"
fi