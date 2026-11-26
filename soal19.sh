# Konfigurasi router Shigeru (/root/soal19.sh)
cat << 'EOF' > /root/soal19.sh
#!/bin/sh

# Hentikan proses daemon lama jika ada
if [ -f /var/run/soal19_arp.pid ]; then
    kill "$(cat /var/run/soal19_arp.pid)" 2>/dev/null || true
    rm -f /var/run/soal19_arp.pid
fi

# Bersihkan rule iptables lama untuk Armisael (10.80.4.83) agar idempoten
for CHAIN in INPUT OUTPUT FORWARD; do
    iptables -D "$CHAIN" -s 10.80.4.83 -j DROP 2>/dev/null || true
    iptables -D "$CHAIN" -d 10.80.4.83 -j DROP 2>/dev/null || true
done

# Isolasi Layer-3 di Shigeru: Blokir seluruh lalu lintas masuk & keluar Armisael di posisi teratas (-I)
for CHAIN in INPUT OUTPUT FORWARD; do
    iptables -I "$CHAIN" 1 -s 10.80.4.83 -j DROP
    iptables -I "$CHAIN" 2 -d 10.80.4.83 -j DROP
done
EOF

chmod +x /root/soal19.sh
sh /root/soal19.sh

# Pastikan link Armisael <-> Switch-Monolith di GNS3 juga di-suspend untuk isolasi Layer-2

# Cek rule isolasi pada Shigeru
iptables -S
# Expected output:
# -A INPUT -s 10.80.4.83/32 -j DROP
# -A INPUT -d 10.80.4.83/32 -j DROP
# -A FORWARD -s 10.80.4.83/32 -j DROP
# -A FORWARD -d 10.80.4.83/32 -j DROP
# -A OUTPUT -s 10.80.4.83/32 -j DROP
# -A OUTPUT -d 10.80.4.83/32 -j DROP

# Test dari Armisael ke Gateway, Seele, Zeruel, dan Lilith
ping -c 2 -W 1 10.80.4.81
ping -c 2 -W 1 8.8.8.8
ping -c 2 -W 1 10.80.4.82
ping -c 2 -W 1 10.80.4.74
nc -zv -w 2 8.8.8.8 53; echo "exit_seele=$?"
nc -zv -w 2 10.80.4.82 9000; echo "exit_zeruel=$?"
nc -zv -w 2 10.80.4.74 9000; echo "exit_lilith=$?"
# Expected output: Semua ping 100% packet loss, semua nc exit=1

# Test dari Zeruel ke Seele dan Lilith
ping -c 2 8.8.8.8
ping -c 2 10.80.4.74
nc -zv -w 3 8.8.8.8 53; echo "exit_seele=$?"
echo "halo-dari-zeruel" | nc -w 2 10.80.4.74 9000; echo "exit_lilith=$?"
# Expected output: Semua ping 0% packet loss, semua nc exit=0