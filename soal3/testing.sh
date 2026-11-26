#Langkah 1: IP sementara di 3 node uji (Lilith, Sachiel, Comm-Net, kemudian Armisael)
#Di node: Lilith, lalu Sachiel, lalu Comm-Net. Buka console masing-masing, paste blok yang sama:

H=$(hostname | tr 'A-Z' 'a-z'); A=
case "$H" in
  armisael*) A=10.80.4.83/29;  G=10.80.4.81;;
  lilith*)   A=10.80.4.74/29;  G=10.80.4.73;;
  sachiel*)  A=10.80.3.130/26; G=10.80.3.129;;
  comm*)     A=10.80.2.2/24;   G=10.80.2.1;;
  *) echo "hostname '$H' tidak dikenal, isi IP manual";;
esac
if [ -n "$A" ]; then ip link set eth0 up; ip addr flush dev eth0; ip addr add $A dev eth0; ip route replace default via $G; fi
echo "===== $H ====="; ip -br addr; ip route
case "$H" in armisael*) for t in 10.80.4.74 10.80.3.130 10.80.2.2; do if ping -c 3 -W 1 $t >/tmp/p 2>&1; then echo "PASS ping $t"; else echo "FAIL ping $t"; fi; tail -2 /tmp/p; done;; esac

#Gendou, Makoto, Kaworu, Shinji, Kensuke, dan Maya
echo "===== SAPU $(hostname) ====="; ok=0; bad=0; for t in 10.80.0.1 10.80.2.1 10.80.3.1 10.80.3.129 10.80.3.193 10.80.3.225 10.80.4.1 10.80.4.33 10.80.4.49 10.80.4.57 10.80.4.65 10.80.4.73 10.80.4.81 10.80.4.89 10.80.4.97 10.80.4.101 10.80.4.105 10.80.4.109 10.80.4.110 10.80.4.113 10.80.4.114 10.80.4.117 10.80.4.118 10.80.4.121 10.80.4.122 10.80.4.125 10.80.4.126 10.80.4.129 10.80.4.130 10.80.4.133 10.80.4.134 10.80.4.137 10.80.4.138 10.80.4.141 10.80.4.142 10.80.4.145 10.80.4.146 10.80.4.149 10.80.4.150 10.80.4.153 10.80.4.154 10.80.4.157 10.80.4.158 10.80.4.161 10.80.4.162 10.80.4.165 10.80.4.166 10.80.4.169 10.80.4.170; do if ping -c 1 -W 1 $t >/dev/null 2>&1; then ok=$((ok+1)); else bad=$((bad+1)); echo "FAIL $t"; fi; done; echo "REACHABLE=$ok UNREACHABLE=$bad"; ip route
if ip -4 -o addr show | grep -q ' 10.80.4.109/'; then echo "--- khusus Gendo: soal3.sh ---"; cat /root/soal3.sh; echo "--- rute statis ---"; ip route | grep -v 'proto kernel'; echo "jumlah rute statis (tanpa default): $(ip route | grep -v 'proto kernel' | grep -vc default)"; fi