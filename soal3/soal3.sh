cat > /root/soal3.sh <<'EOF'
#!/bin/sh
# Soal 3 - routing statis. SATU script untuk semua router: node mengenali dirinya dari IP-nya.
has() { ip -4 -o addr show | grep -q " $1/"; }
if   has 10.80.4.109; then
  echo "Soal 3: router Gendo"
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
elif has 10.80.4.110; then
  echo "Soal 3: router Yui"
  ip route replace 10.80.4.0/27 via 10.80.4.146
  ip route replace 10.80.0.0/23 via 10.80.4.138
  ip route replace 10.80.4.32/28 via 10.80.4.142
  ip route replace default via 10.80.4.109   # default ke atas
elif has 10.80.4.146; then
  echo "Soal 3: router Shinji"
  ip route replace default via 10.80.4.145   # default ke atas
elif has 10.80.4.138; then
  echo "Soal 3: router Rei"
  ip route replace default via 10.80.4.137   # default ke atas
elif has 10.80.4.142; then
  echo "Soal 3: router Mari"
  ip route replace default via 10.80.4.141   # default ke atas
elif has 10.80.4.114; then
  echo "Soal 3: router Hikari"
  ip route replace 10.80.3.224/27 via 10.80.4.150
  ip route replace default via 10.80.4.113   # default ke atas
elif has 10.80.4.150; then
  echo "Soal 3: router Kaworu"
  ip route replace default via 10.80.4.149   # default ke atas
elif has 10.80.4.118; then
  echo "Soal 3: router Asuka"
  ip route replace 10.80.3.128/26 via 10.80.4.154
  ip route replace 10.80.4.48/29 via 10.80.4.158
  ip route replace default via 10.80.4.117   # default ke atas
elif has 10.80.4.154; then
  echo "Soal 3: router Kensuke"
  ip route replace default via 10.80.4.153   # default ke atas
elif has 10.80.4.158; then
  echo "Soal 3: router Ritsuko"
  ip route replace default via 10.80.4.157   # default ke atas
elif has 10.80.4.122; then
  echo "Soal 3: router Kaji"
  ip route replace default via 10.80.4.121   # default ke atas
elif has 10.80.4.126; then
  echo "Soal 3: router Misato"
  ip route replace default via 10.80.4.125   # default ke atas
elif has 10.80.4.130; then
  echo "Soal 3: router Shigeru"
  ip route replace 10.80.4.88/29 via 10.80.4.162
  ip route replace default via 10.80.4.129   # default ke atas
elif has 10.80.4.162; then
  echo "Soal 3: router Makoto"
  ip route replace default via 10.80.4.161   # default ke atas
elif has 10.80.4.134; then
  echo "Soal 3: router Fuyutsuki"
  ip route replace 10.80.4.72/29 via 10.80.4.166
  ip route replace 10.80.3.192/27 via 10.80.4.170
  ip route replace default via 10.80.4.133   # default ke atas
elif has 10.80.4.166; then
  echo "Soal 3: router Toji"
  ip route replace default via 10.80.4.165   # default ke atas
elif has 10.80.4.170; then
  echo "Soal 3: router Maya"
  ip route replace default via 10.80.4.169   # default ke atas
else echo "Soal 3: node ini bukan router (IP Soal 2 belum terpasang?)" >&2; fi
EOF
chmod +x /root/soal3.sh
F=$(grep -o '/root/[a-z]*\.sh' /etc/network/interfaces | grep -v soal | head -1)
if [ -z "$F" ]; then echo "ERROR: /etc/network/interfaces belum punya hook /root/<nama>.sh (pasang Soal 2 dulu)"; else
  sed -i '/^# --- Soal 3/,$d; /^# --- tambahan per soal/,$d' "$F"; sed -i 's/^# Soal 2 + Soal 3 - /# Soal 2 - /' "$F"
  printf '%s\n' '# --- tambahan per soal: soal1.sh ... soal20.sh (otomatis ikut, urut angka) ---' 'for n in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20; do [ -f /root/soal$n.sh ] && sh /root/soal$n.sh; done; true' >> "$F"
fi
sh "${F:-/root/soal3.sh}"; echo "== $(hostname) =="; tail -2 "$F"; ip route