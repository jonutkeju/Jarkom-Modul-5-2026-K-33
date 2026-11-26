# Uji pemulihan dua siklus pada Shigeru, Fuyutsuki, dan Tokyo3-Core (/root/soal20.sh)

# === 1. Node Router: Shigeru ===
iptables-save > /root/shigeru.rules

iptables -F; iptables -X; iptables -t nat -F; iptables -t nat -X; iptables -t mangle -F; iptables -t mangle -X
iptables -P INPUT ACCEPT; iptables -P FORWARD ACCEPT; iptables -P OUTPUT ACCEPT
ip route del default 2>/dev/null || true
ip route del 10.80.4.88/29 2>/dev/null || true
iptables-restore < /root/shigeru.rules
sh /root/shigeru.sh
RUN1_FILTER=$(iptables -S | wc -l)
RUN1_NAT=$(iptables -t nat -S | wc -l)

iptables -F; iptables -X; iptables -t nat -F; iptables -t nat -X; iptables -t mangle -F; iptables -t mangle -X
iptables -P INPUT ACCEPT; iptables -P FORWARD ACCEPT; iptables -P OUTPUT ACCEPT
ip route del default 2>/dev/null || true
ip route del 10.80.4.88/29 2>/dev/null || true
iptables-restore < /root/shigeru.rules
sh /root/shigeru.sh
RUN2_FILTER=$(iptables -S | wc -l)
RUN2_NAT=$(iptables -t nat -S | wc -l)

echo "Shigeru -> Run1: filter=$RUN1_FILTER nat=$RUN1_NAT | Run2: filter=$RUN2_FILTER nat=$RUN2_NAT"
# Expected output: Shigeru -> Run1: filter=12 nat=4 | Run2: filter=12 nat=4

# === 2. Node Router: Fuyutsuki ===
iptables-save > /root/fuyutsuki.rules

iptables -F; iptables -X; iptables -t nat -F; iptables -t nat -X; iptables -t mangle -F; iptables -t mangle -X
iptables -P INPUT ACCEPT; iptables -P FORWARD ACCEPT; iptables -P OUTPUT ACCEPT
ip route del default 2>/dev/null || true
ip route del 10.80.3.192/27 2>/dev/null || true
ip route del 10.80.4.72/29 2>/dev/null || true
iptables-restore < /root/fuyutsuki.rules
sh /root/fuyutsuki.sh
RUN1_FILTER=$(iptables -S | wc -l)
RUN1_NAT=$(iptables -t nat -S | wc -l)

iptables -F; iptables -X; iptables -t nat -F; iptables -t nat -X; iptables -t mangle -F; iptables -t mangle -X
iptables -P INPUT ACCEPT; iptables -P FORWARD ACCEPT; iptables -P OUTPUT ACCEPT
ip route del default 2>/dev/null || true
ip route del 10.80.3.192/27 2>/dev/null || true
ip route del 10.80.4.72/29 2>/dev/null || true
iptables-restore < /root/fuyutsuki.rules
sh /root/fuyutsuki.sh
RUN2_FILTER=$(iptables -S | wc -l)
RUN2_NAT=$(iptables -t nat -S | wc -l)

echo "Fuyutsuki -> Run1: filter=$RUN1_FILTER nat=$RUN1_NAT | Run2: filter=$RUN2_FILTER nat=$RUN2_NAT"
# Expected output: Fuyutsuki -> Run1: filter=3 nat=5 | Run2: filter=3 nat=5

# === 3. Node Server: Tokyo3-Core ===
iptables-save > /root/tokyo3-core.rules

iptables -F; iptables -X; iptables -t nat -F; iptables -t nat -X; iptables -t mangle -F; iptables -t mangle -X
iptables -P INPUT ACCEPT; iptables -P FORWARD ACCEPT; iptables -P OUTPUT ACCEPT
ip route del default 2>/dev/null || true
iptables-restore < /root/tokyo3-core.rules
sh /root/tokyo3-core.sh
RUN1_FILTER=$(iptables -S | wc -l)
RUN1_NAT=$(iptables -t nat -S | wc -l)

iptables -F; iptables -X; iptables -t nat -F; iptables -t nat -X; iptables -t mangle -F; iptables -t mangle -X
iptables -P INPUT ACCEPT; iptables -P FORWARD ACCEPT; iptables -P OUTPUT ACCEPT
ip route del default 2>/dev/null || true
iptables-restore < /root/tokyo3-core.rules
sh /root/tokyo3-core.sh
RUN2_FILTER=$(iptables -S | wc -l)
RUN2_NAT=$(iptables -t nat -S | wc -l)

echo "Tokyo3-Core -> Run1: filter=$RUN1_FILTER nat=$RUN1_NAT | Run2: filter=$RUN2_FILTER nat=$RUN2_NAT"
# Expected output: Tokyo3-Core -> Run1: filter=7 nat=4 | Run2: filter=7 nat=4

# === 4. Uji Fungsi Nyata Pasca-Pemulihan ===
# Dari Magi-Casper ke Zeruel
ping -c 2 10.80.4.82
# Expected output: 2 packets transmitted, 2 received, 0% packet loss

# Dari Zeruel ke Seele (8.8.8.8) dan Tokyo3-Core (10.80.4.106:8080)
ping -c 2 8.8.8.8
echo "" | nc -w 2 10.80.4.106 8080
# Expected output: 0% packet loss dan balasan "syifa imutz"