#Pen-Pen dan Tokyo3-Core (tunggu ±60 detik setelah SETUP)
echo "== $(hostname) =="; nc.traditional -h 2>&1 | head -1
ss -ltn | grep -E ':(80|8080) '
tail -3 /root/soal8.log 2>/dev/null

#Lilith
NC=$(command -v nc.traditional || command -v nc)
echo "== $(hostname) == pakai: $NC"
t(){ s=$(date +%s); r=$(echo | $NC -w 3 $1 $2 2>&1); rc=$?; e=$(date +%s); echo "$3 $1:$2 -> [$r] exit=$rc durasi=$((e-s))s"; }
t 10.80.3.194 80 Pen-Pen
t 10.80.4.106 80 Tokyo3-Core
t 10.80.4.106 8080 Tokyo3-Core
t 10.80.3.194 22 Pen-Pen
t 10.80.4.106 22 Tokyo3-Core

#Pen-Pen dan Tokyo3-Core
echo "== $(hostname) =="; for f in /root/nc-80.log /root/nc-8080.log; do [ -f $f ] && { echo "--- $f"; cat $f; }; done