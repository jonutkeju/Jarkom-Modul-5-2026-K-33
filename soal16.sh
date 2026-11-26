# Konfigurasi node Tokyo3-Core (/root/soal16.sh)
cat << 'EOF' > /root/soal16.sh
#!/bin/sh

# Hapus rule lama jika ada agar skrip bersifat idempoten saat dijalankan ulang
iptables -D INPUT -s 10.80.4.51 -p tcp -m multiport --dports 22,23,3306 -j LOG --log-prefix "SCAN-NERV:" 2>/dev/null || true
iptables -D INPUT -s 10.80.4.51 -p tcp -m multiport --dports 22,23,3306 -j REJECT --reject-with tcp-reset 2>/dev/null || true

# 1. Catat setiap percobaan koneksi TCP dari Dummy-Plug (10.80.4.51) ke port 22, 23, dan 3306
iptables -A INPUT -s 10.80.4.51 -p tcp -m multiport --dports 22,23,3306 -j LOG --log-prefix "SCAN-NERV:"

# 2. Tolak seketika koneksi tersebut menggunakan TCP Reset agar tidak menggantung
iptables -A INPUT -s 10.80.4.51 -p tcp -m multiport --dports 22,23,3306 -j REJECT --reject-with tcp-reset
EOF

chmod +x /root/soal16.sh
sh /root/soal16.sh

# Reset counter dan cek urutan rule di Tokyo3-Core
iptables -Z INPUT
iptables -L INPUT -n -v --line-numbers
# Expected output:
# Rule 3: LOG tcp 10.80.4.51 multiport dports 22,23,3306 prefix "SCAN-NERV:" (pkts = 0)
# Rule 4: REJECT tcp 10.80.4.51 multiport dports 22,23,3306 reject-with tcp-reset (pkts = 0)

# Test dari Dummy-Plug (10.80.4.51) ke port sensitif 22, 23, 3306
time nc -zv -w 5 10.80.4.106 22
time nc -zv -w 5 10.80.4.106 23
time nc -zv -w 5 10.80.4.106 3306
# Expected output: Langsung ditolak seketika (< 0.1 detik, Connection refused)

# Test dari Dummy-Plug (10.80.4.51) ke port 80 dan 8080
nc -w 2 10.80.4.106 80
nc -w 2 10.80.4.106 8080
# Expected output: Welcome to Tokyo3-Core dan syifa imutz

# Lanjut cek kenaikan counter pencatatan log di Tokyo3-Core
iptables -L INPUT -n -v --line-numbers
# Expected output: Counter pkts pada baris LOG ("SCAN-NERV:") dan REJECT naik menjadi 3 pkts