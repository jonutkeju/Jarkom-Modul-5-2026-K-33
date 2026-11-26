# Konfigurasi node Tokyo3-Core (/root/soal15.sh)
cat << 'EOF' > /root/soal15.sh
#!/bin/sh

# Hapus rule lama jika ada agar skrip bersifat idempoten saat dijalankan ulang
iptables -D INPUT -p icmp --icmp-type echo-request -m limit --limit 5/sec --limit-burst 5 -j ACCEPT 2>/dev/null || true
iptables -D INPUT -p icmp --icmp-type echo-request -j DROP 2>/dev/null || true

# 1. Izinkan paket ICMP echo-request masuk maksimal 5 ping per detik
iptables -A INPUT -p icmp --icmp-type echo-request -m limit --limit 5/sec --limit-burst 5 -j ACCEPT

# 2. Buang (DROP) seluruh kelebihan ICMP echo-request di atas batas tersebut
iptables -A INPUT -p icmp --icmp-type echo-request -j DROP
EOF

chmod +x /root/soal15.sh
sh /root/soal15.sh

# Reset counter dan cek urutan rule di Tokyo3-Core
iptables -Z INPUT
iptables -L INPUT -n -v --line-numbers
# Expected output:
# Rule 1: ACCEPT icmp icmptype 8 limit: avg 5/sec burst 5 (pkts = 0)
# Rule 2: DROP icmp icmptype 8 (pkts = 0)

# Test banjir ping dari Lilith (10.80.4.74) ke Tokyo3-Core (10.80.4.106)
ping -i 0.1 -c 50 10.80.4.106
# Expected output: Sebagian paket hilang (~40% packet loss)

# Lanjut cek kenaikan counter pembuangan di Tokyo3-Core
iptables -L INPUT -n -v --line-numbers
# Expected output: Counter pkts pada baris DROP (icmptype 8) bertambah (misal 20 pkts)

# Test ping normal berjeda minimal 3 detik dari Lilith ke Tokyo3-Core
ping -i 3 -c 4 10.80.4.106
# Expected output: 4 packets transmitted, 4 received, 0% packet loss

# Test ping keluar dari Tokyo3-Core sendiri ke Lilith
ping -i 0.1 -c 15 10.80.4.74
# Expected output: 15 packets transmitted, 15 received, 0% packet loss