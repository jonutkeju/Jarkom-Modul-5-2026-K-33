#Pen-Pen dan Tokyo3-Core
for d in /proc/[0-9]*; do p=${d#/proc/}; [ "$p" = "$$" ] && continue; tr '\0' ' ' < $d/cmdline 2>/dev/null | grep -q -E 'sh /root/(pen-pen|tokyo3-core)\.sh' && kill $p 2>/dev/null; done
H=$(hostname | tr 'A-Z' 'a-z')
HN=$(hostname)
case "$H" in
  pen-pen*|tokyo3*) OK=1 ;;
  *) OK= ;;
esac
F=/root/$H.sh
if [ -z "$OK" ]; then
  echo "ERROR: hostname '$H' bukan Pen-Pen/Tokyo3-Core, tidak ada yang diubah"
elif [ ! -f "$F" ]; then
  echo "ERROR: $F tidak ada (jalankan script Soal 6 dulu)"
else
  sed -i '/^# --- Soal 8/,$d; /^# --- tambahan per soal/,$d' "$F"
  echo "# --- Soal 8: pasang netcat-traditional, layani port 80 (dan 8080 di Tokyo3-Core) ---" >> "$F"
  echo "soal8_svcs() {" >> "$F"
  echo "  svc 80 \"Welcome to $HN\"" >> "$F"
  case "$H" in tokyo3*) echo "  svc 8080 \"syifa imutz\"" >> "$F" ;; esac
  echo "}" >> "$F"
  cat >> "$F" <<'EOF'
svc() {
  p=$1; m=$2
  ss -ltn | grep -q ":$p " && return
  ( while true; do
      echo "$m" | nc.traditional -v -l -p $p -q 1 2>&1 >/dev/null | while IFS= read -r l; do echo "$(date '+%F %T') [port $p] $l" >> /root/nc-$p.log; done
      sleep 0.2 2>/dev/null || sleep 1
    done ) &
}
soal8() {
  i=0
  until command -v nc.traditional >/dev/null 2>&1; do
    apt-get update -qq
    DEBIAN_FRONTEND=noninteractive apt-get install -y iptables netcat-traditional && break
    i=$((i+1)); [ $i -ge 30 ] && break; sleep 5
  done
  command -v nc.traditional >/dev/null 2>&1 || { echo "ERROR: nc.traditional tidak terpasang, layanan tidak dinyalakan"; return 1; }
  soal8_svcs
}
( trap '' HUP; soal8 ) </dev/null >>/root/soal8.log 2>&1 &
# --- tambahan per soal: soal1.sh ... soal20.sh (otomatis ikut, urut angka) ---
for n in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20; do [ -f /root/soal$n.sh ] && sh /root/soal$n.sh; done; true
EOF
  sh "$F"
  echo "== $(hostname) == paket dan layanan dipasang di background, tunggu sampai 60 detik lalu jalankan tes"; tail -5 "$F"
fi