# Konfigurasi node Pen-Pen (/root/soal14.sh)
cat << 'EOF' > /root/soal14.sh
#!/bin/sh

# Variabel jadwal dalam UTC (WIB - 7 jam)
PILOT_START="01:00"
PILOT_STOP="09:00"
PILOT_DAYS="Mon,Tue,Wed,Thu,Fri"
STAF_START="10:00"
STAF_STOP="16:00"

# Bersihkan chain INPUT agar idempoten saat dijalankan ulang
iptables -P INPUT ACCEPT
iptables -F INPUT

# Izinkan loopback dan paket balasan dari koneksi keluar milik Pen-Pen sendiri
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Helper untuk menerapkan kebijakan akses pada ICMP echo-request (ping) dan TCP 80
allow_sched() {
    SRC=$1; START=$2; STOP=$3; DAYS=$4
    if [ -n "$DAYS" ]; then
        iptables -A INPUT -s "$SRC" -p icmp --icmp-type echo-request -m time --timestart "$START" --timestop "$STOP" --weekdays "$DAYS" -j ACCEPT
        iptables -A INPUT -s "$SRC" -p tcp --dport 80 -m time --timestart "$START" --timestop "$STOP" --weekdays "$DAYS" -j ACCEPT
    else
        iptables -A INPUT -s "$SRC" -p icmp --icmp-type echo-request -m time --timestart "$START" --timestop "$STOP" -j ACCEPT
        iptables -A INPUT -s "$SRC" -p tcp --dport 80 -m time --timestart "$START" --timestop "$STOP" -j ACCEPT
    fi
}

drop_target() {
    SRC=$1
    iptables -A INPUT -s "$SRC" -p icmp --icmp-type echo-request -j DROP
    iptables -A INPUT -s "$SRC" -p tcp --dport 80 -j DROP
}

# 1. Pilot: Unit-01 (.66), Unit-02 (.67), Unit-00 (.68), Sachiel (10.80.3.130)
for IP in 10.80.4.66 10.80.4.67 10.80.4.68 10.80.3.130; do
    allow_sched "$IP" "$PILOT_START" "$PILOT_STOP" "$PILOT_DAYS"
    drop_target "$IP"
done

# 2. Staf Geofront: Lilith (.74), Adam (.75)
for IP in 10.80.4.74 10.80.4.75; do
    allow_sched "$IP" "$STAF_START" "$STAF_STOP" ""
    drop_target "$IP"
done

# 3. Terduga Dummy System: Entry-Plug (.50), Dummy-Plug (.51), Spy (.102) -> Selalu ditolak
for IP in 10.80.4.50 10.80.4.51 10.80.4.102; do
    drop_target "$IP"
done

# 4. Lainnya: bebas (default policy INPUT ACCEPT)
EOF

chmod +x /root/soal14.sh
sh /root/soal14.sh

# Test Kondisi 1: Ubah variabel jadwal agar cocok dengan jam UTC saat pengujian (misal 13:00 - 16:00)
sed -i 's/^PILOT_START=.*/PILOT_START="13:00"/' /root/soal14.sh
sed -i 's/^PILOT_STOP=.*/PILOT_STOP="16:00"/' /root/soal14.sh
sh /root/soal14.sh
# Jalankan di Unit-01 (10.80.4.66), Lilith (10.80.4.74), dan Spy (10.80.4.102):
ping -c 2 10.80.3.194
# Expected output: Unit-01 & Lilith berhasil (0% loss), Spy gagal (100% loss)

# Test Kondisi 2: Ubah variabel jadwal agar tidak cocok dengan jam UTC saat pengujian (01:00 - 02:00)
sed -i 's/^PILOT_START=.*/PILOT_START="01:00"/' /root/soal14.sh
sed -i 's/^PILOT_STOP=.*/PILOT_STOP="02:00"/' /root/soal14.sh
sed -i 's/^STAF_START=.*/STAF_START="01:00"/' /root/soal14.sh
sed -i 's/^STAF_STOP=.*/STAF_STOP="02:00"/' /root/soal14.sh
sh /root/soal14.sh
# Jalankan kembali di Unit-01, Lilith, dan Spy:
ping -c 2 10.80.3.194
# Expected output: Ketiganya gagal (100% packet loss)

# Kembalikan variabel jadwal ke nilai resmi soal (08.00-16.00 WIB & 17.00-23.00 WIB)
sed -i 's/^PILOT_START=.*/PILOT_START="01:00"/' /root/soal14.sh
sed -i 's/^PILOT_STOP=.*/PILOT_STOP="09:00"/' /root/soal14.sh
sed -i 's/^STAF_START=.*/STAF_START="10:00"/' /root/soal14.sh
sed -i 's/^STAF_STOP=.*/STAF_STOP="16:00"/' /root/soal14.sh
sh /root/soal14.sh