# Konfigurasi node Magi-Casper (/root/soal11.sh)
cat << 'EOF' > /root/soal11.sh
#!/bin/sh

# Hapus rule lama jika ada agar idempoten saat dijalankan ulang
iptables -D INPUT -p icmp --icmp-type echo-request -j DROP 2>/dev/null || true

# Blokir semua ping masuk (ICMP echo-request) ke Magi-Casper
iptables -A INPUT -p icmp --icmp-type echo-request -j DROP
EOF

chmod +x /root/soal11.sh
sh /root/soal11.sh

# Test dari Casper
iptables -S
# Expected output
-P INPUT ACCEPT
-P FORWARD ACCEPT
-P OUTPUT ACCEPT
-A INPUT -p icmp -m icmp --icmp-type 8 -j DROP

# Test ping dari node lainnya
ping -c 3 10.80.4.58
# Exoected output: Gaada yang kekirim

# Test ping dari Casper keluar
ping -c 3 10.80.4.59
ping -c 3 10.80.4.74
# Ecpected output: Bisa ping keluar ke node lain

# Test port 5000 misal dari Lilith
echo "bebasla bagian ini yang penting ngasi pesan" | nc -w 2 10.80.4.58 5000
# Lanjut cek di Casper
cat /root/nc-5000.log
# Expected output: Pesannya muncul