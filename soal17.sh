# Konfigurasi router Fuyutsuki (/root/soal17.sh)
cat << 'EOF' > /root/soal17.sh
#!/bin/sh

# Hapus rule lama jika ada agar skrip bersifat idempoten saat dijalankan ulang
iptables -t nat -D PREROUTING -s 10.80.4.58 -d 10.80.4.82 -p tcp -j DNAT --to-destination 10.80.3.194 2>/dev/null || true

# Alihkan seluruh koneksi TCP dari Magi-Casper (10.80.4.58) menuju Zeruel (10.80.4.82) ke Pen-Pen (10.80.3.194)
# Protokol ICMP (ping) tidak tercakup rule ini sehingga tetap menuju Zeruel
iptables -t nat -A PREROUTING -s 10.80.4.58 -d 10.80.4.82 -p tcp -j DNAT --to-destination 10.80.3.194
EOF

chmod +x /root/soal17.sh
sh /root/soal17.sh

# Cek rule NAT aktif di Fuyutsuki
iptables -t nat -S
# Expected output:
# -A PREROUTING -s 10.80.4.58/32 -d 10.80.4.82/32 -p tcp -j DNAT --to-destination 10.80.3.194

# Jalankan listener di Pen-Pen (10.80.3.194) dan Zeruel (10.80.4.82):
# nc -l -p 9000

# Test kirim pesan TCP dari Magi-Casper (10.80.4.58) ke IP Zeruel (10.80.4.82) port 9000
echo "halo-ini-casper-ke-zeruel" | nc -w 2 10.80.4.82 9000
# Expected output: Pesan muncul di Pen-Pen, sedangkan Zeruel tetap kosong

# Test ping dari Magi-Casper ke Zeruel (tidak dialihkan)
ping -c 2 10.80.4.82
# Expected output: 2 packets transmitted, 2 received, 0% packet loss

# Verifikasi translasi paket stateful (conntrack) di Fuyutsuki saat koneksi berlangsung
tcpdump -i any -nn tcp port 9000 -c 6
# Expected output: Paket masuk 10.80.4.58 -> 10.80.4.82 diterjemahkan ke 10.80.3.194, dan balasannya dikembalikan sebagai 10.80.4.82