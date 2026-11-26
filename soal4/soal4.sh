#Gendou
cat > /root/soal4.sh <<'EOS'
#!/bin/sh
# Soal 4 (Gendo) - DNS + NAT. MASQUERADE hanya prefix internal yang keluar lewat eth0 (NAT1).
printf 'nameserver 8.8.8.8\n' > /etc/resolv.conf
iptables -t nat -C POSTROUTING -s 10.80.0.0/16 -o eth0 -j MASQUERADE 2>/dev/null || \
  iptables -t nat -A POSTROUTING -s 10.80.0.0/16 -o eth0 -j MASQUERADE
EOS
chmod +x /root/soal4.sh
printf 'nameserver 8.8.8.8\n' > /etc/resolv.conf
if ! command -v iptables >/dev/null 2>&1; then
  echo "iptables belum ada, install..."; apt update && apt install -y iptables
fi
iptables -V
sh /root/soal4.sh
echo "== $(hostname) =="; cat /etc/resolv.conf; ls -l /root/soal4.sh
iptables -t nat -S POSTROUTING

#router selain Gendou
cat > /root/soal4.sh <<'EOS'
#!/bin/sh
# Soal 4 (router non-Gendo) - resolver tetap supaya node bisa resolve nama domain saat pasang paket.
printf 'nameserver 8.8.8.8\n' > /etc/resolv.conf
EOS
chmod +x /root/soal4.sh
sh /root/soal4.sh
echo "== $(hostname) =="; cat /etc/resolv.conf; ls -l /root/soal4.sh