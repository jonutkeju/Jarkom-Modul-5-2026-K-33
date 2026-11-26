# Konfigurasi node Magi-Casper (/root/soal12.sh)
cat << 'EOF' > /root/soal12.sh
#!/bin/sh

# 1. Hapus rule sabotase DNS keluar pada OUTPUT
iptables -D OUTPUT -p udp --dport 53 -j DROP 2>/dev/null || true

# 2. Bersihkan dan bangun ulang chain INPUT agar idempoten & tetap hardened (DROP)
iptables -P INPUT ACCEPT
iptables -F INPUT

# Izinkan loopback
iptables -A INPUT -i lo -j ACCEPT

# Izinkan paket balasan dari koneksi yang dimulai Magi-Casper (termasuk ping reply & apt-get)
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Pertahankan aturan Soal 11: tolak semua ping masuk (ICMP echo-request)
iptables -A INPUT -p icmp --icmp-type echo-request -j DROP

# Izinkan akses masuk ke layanan MAGI (TCP port 5000)
iptables -A INPUT -p tcp --dport 5000 -j ACCEPT

# Pertahankan tujuan hardening: tolak semua lalu lintas masuk lain yang tidak diizinkan
iptables -P INPUT DROP
EOF

chmod +x /root/soal12.sh
sh /root/soal12.sh

# Test dari Casper (cek policy INPUT tetap DROP & rule aktif)
iptables -S
# Expected output:
# -P INPUT DROP
# -P FORWARD ACCEPT
# -P OUTPUT ACCEPT
# -A INPUT -i lo -j ACCEPT
# -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
# -A INPUT -p icmp -m icmp --icmp-type 8 -j DROP
# -A INPUT -p tcp -m tcp --dport 5000 -j ACCEPT

# Test ping internet & update paket dari Casper
ping -c 3 8.8.8.8
apt-get update
# Expected output: Ping 0% packet loss & apt-get update berhasil

# Test port 5000 dari Unit-00 (10.80.4.68) ke Casper (10.80.4.58)
echo "bebasla bagian ini yang penting ngasi pesan" | nc -w 2 10.80.4.58 5000
# Lanjut cek di Casper
cat /root/nc-5000.log
# Expected output: Pesannya muncul

# Test ping dari node lainnya (misal Unit-00 / Magi-Balthasar) ke Casper
ping -c 3 10.80.4.58
# Expected output: Gaada yang kekirim (100% packet loss)