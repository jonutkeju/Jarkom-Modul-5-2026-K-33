# Konfigurasi router Shigeru (/root/soal18.sh)
cat << 'EOF' > /root/soal18.sh
#!/bin/sh

# Hapus rule lama jika ada agar skrip bersifat idempoten saat dijalankan ulang
iptables -D FORWARD -i eth0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT 2>/dev/null || true
iptables -D FORWARD -i eth0 -s 10.80.4.56/29 -p icmp --icmp-type echo-request -j ACCEPT 2>/dev/null || true
iptables -D FORWARD -i eth0 -j DROP 2>/dev/null || true

# 1. Izinkan paket balasan (ESTABLISHED,RELATED) untuk koneksi yang dimulai dari dalam zona Monolith & Radar
iptables -A FORWARD -i eth0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# 2. Pengecualian: izinkan ping (ICMP echo-request) masuk dari subnet Switch-Terminal (10.80.4.56/29)
iptables -A FORWARD -i eth0 -s 10.80.4.56/29 -p icmp --icmp-type echo-request -j ACCEPT

# 3. Tolak seluruh koneksi baru lainnya yang datang dari sisi Gendo (-i eth0) masuk ke zona sensitif
iptables -A FORWARD -i eth0 -j DROP
EOF

chmod +x /root/soal18.sh
sh /root/soal18.sh

# Cek urutan rule aktif pada rantai FORWARD di Shigeru
iptables -L FORWARD -n -v --line-numbers
# Expected output:
# Rule 1: ACCEPT all in eth0 ctstate RELATED,ESTABLISHED
# Rule 2: ACCEPT icmp in eth0 src 10.80.4.56/29 icmptype 8
# Rule 3: DROP all in eth0

# Test ping dari Magi-Casper (10.80.4.58) ke Zeruel (10.80.4.82)
ping -c 2 10.80.4.82
# Expected output: 2 packets transmitted, 2 received, 0% packet loss

# Test ping dari Lilith (10.80.4.74) ke Zeruel (10.80.4.82)
ping -c 2 10.80.4.82
# Expected output: 2 packets transmitted, 0 received, 100% packet loss

# Test ping dari Zeruel (10.80.4.82) keluar ke Lilith (10.80.4.74)
ping -c 2 10.80.4.74
# Expected output: 2 packets transmitted, 2 received, 0% packet loss