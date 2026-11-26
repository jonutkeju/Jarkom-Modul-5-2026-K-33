# Konfigurasi node Magi-Balthasar (/root/soal13.sh)
cat << 'EOF' > /root/soal13.sh
#!/bin/sh

# Hapus rule lama jika ada agar skrip bersifat idempoten saat dijalankan ulang
for PORT in 5000 5001; do
    for SRC in 10.80.4.58 10.80.4.66 10.80.4.67 10.80.4.68 10.80.3.130; do
        iptables -D INPUT -p tcp -s "$SRC" --dport "$PORT" -j ACCEPT 2>/dev/null || true
    done
    iptables -D INPUT -p tcp --dport "$PORT" -j REJECT --reject-with tcp-reset 2>/dev/null || true
done

# Izinkan akses ke TCP port 5000 dan 5001 hanya dari Magi-Casper dan seluruh Pilot
for PORT in 5000 5001; do
    # Magi-Casper (10.80.4.58)
    iptables -A INPUT -p tcp -s 10.80.4.58 --dport "$PORT" -j ACCEPT
    # Pilot: Unit-01 (10.80.4.66), Unit-02 (10.80.4.67), Unit-00 (10.80.4.68), Sachiel (10.80.3.130)
    iptables -A INPUT -p tcp -s 10.80.4.66 --dport "$PORT" -j ACCEPT
    iptables -A INPUT -p tcp -s 10.80.4.67 --dport "$PORT" -j ACCEPT
    iptables -A INPUT -p tcp -s 10.80.4.68 --dport "$PORT" -j ACCEPT
    iptables -A INPUT -p tcp -s 10.80.3.130 --dport "$PORT" -j ACCEPT

    # Tolak seketika seluruh koneksi lain ke port 5000 dan 5001 dengan TCP Reset
    iptables -A INPUT -p tcp --dport "$PORT" -j REJECT --reject-with tcp-reset
done
EOF

chmod +x /root/soal13.sh
sh /root/soal13.sh

# Test dari Magi-Balthasar (cek rule firewall & ping internet)
iptables -S
ping -c 3 8.8.8.8
# Expected output:
# Rule whitelist untuk Casper (10.80.4.58) dan Pilot (10.80.4.66-68, 10.80.3.130) + REJECT --reject-with tcp-reset terpasang, dan ping 8.8.8.8 0% packet loss

# Test akses port 5000 dan 5001 dari Unit-01 (10.80.4.66)
echo "tes-unit01-5000" | nc -w 2 10.80.4.59 5000
echo "tes-unit01-5001" | nc -w 2 10.80.4.59 5001
# Lanjut cek di Magi-Balthasar
cat /root/nc-5000.log
cat /root/nc-5001.log
# Expected output: Pesan dari Unit-01 masuk ke kedua file log

# Test penolakan seketika dari Lilith (10.80.4.74) dan Magi-Melchior (10.80.4.60)
time nc -zv -w 5 10.80.4.59 5000
time nc -zv -w 5 10.80.4.59 5001
# Expected output: Langsung ditolak seketika (< 0.1 detik, Connection refused), bukan menunggu timeout 5 detik