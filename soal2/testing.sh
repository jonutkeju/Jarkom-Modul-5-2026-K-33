echo "===== TEST Gendo ====="; ip -br addr; echo "ip_forward=$(cat /proc/sys/net/ipv4/ip_forward)"; ls -l /root/gendo.sh; tail -2 /etc/network/interfaces
for t in 10.80.4.110 10.80.4.114 10.80.4.118 10.80.4.122 10.80.4.126 10.80.4.130 10.80.4.134; do if ping -c 2 -W 1 $t >/tmp/p 2>&1; then echo "PASS ping $t"; else echo "FAIL ping $t"; fi; tail -2 /tmp/p; done
ip route | grep default; ping -c 2 -W 2 8.8.8.8

echo "===== TEST Yui ====="; ip -br addr; echo "ip_forward=$(cat /proc/sys/net/ipv4/ip_forward)"; ls -l /root/yui.sh; tail -2 /etc/network/interfaces
for t in 10.80.4.109 10.80.4.146 10.80.4.138 10.80.4.142; do if ping -c 2 -W 1 $t >/tmp/p 2>&1; then echo "PASS ping $t"; else echo "FAIL ping $t"; fi; tail -2 /tmp/p; done

echo "===== TEST Shinji ====="; ip -br addr; echo "ip_forward=$(cat /proc/sys/net/ipv4/ip_forward)"; ls -l /root/shinji.sh; tail -2 /etc/network/interfaces
for t in 10.80.4.145; do if ping -c 2 -W 1 $t >/tmp/p 2>&1; then echo "PASS ping $t"; else echo "FAIL ping $t"; fi; tail -2 /tmp/p; done

echo "===== TEST Rei ====="; ip -br addr; echo "ip_forward=$(cat /proc/sys/net/ipv4/ip_forward)"; ls -l /root/rei.sh; tail -2 /etc/network/interfaces
for t in 10.80.4.137; do if ping -c 2 -W 1 $t >/tmp/p 2>&1; then echo "PASS ping $t"; else echo "FAIL ping $t"; fi; tail -2 /tmp/p; done

echo "===== TEST Mari ====="; ip -br addr; echo "ip_forward=$(cat /proc/sys/net/ipv4/ip_forward)"; ls -l /root/mari.sh; tail -2 /etc/network/interfaces
for t in 10.80.4.141; do if ping -c 2 -W 1 $t >/tmp/p 2>&1; then echo "PASS ping $t"; else echo "FAIL ping $t"; fi; tail -2 /tmp/p; done

echo "===== TEST Hikari ====="; ip -br addr; echo "ip_forward=$(cat /proc/sys/net/ipv4/ip_forward)"; ls -l /root/hikari.sh; tail -2 /etc/network/interfaces
for t in 10.80.4.113 10.80.4.150; do if ping -c 2 -W 1 $t >/tmp/p 2>&1; then echo "PASS ping $t"; else echo "FAIL ping $t"; fi; tail -2 /tmp/p; done

echo "===== TEST Kaworu ====="; ip -br addr; echo "ip_forward=$(cat /proc/sys/net/ipv4/ip_forward)"; ls -l /root/kaworu.sh; tail -2 /etc/network/interfaces
for t in 10.80.4.149; do if ping -c 2 -W 1 $t >/tmp/p 2>&1; then echo "PASS ping $t"; else echo "FAIL ping $t"; fi; tail -2 /tmp/p; done

echo "===== TEST Asuka ====="; ip -br addr; echo "ip_forward=$(cat /proc/sys/net/ipv4/ip_forward)"; ls -l /root/asuka.sh; tail -2 /etc/network/interfaces
for t in 10.80.4.117 10.80.4.154 10.80.4.158; do if ping -c 2 -W 1 $t >/tmp/p 2>&1; then echo "PASS ping $t"; else echo "FAIL ping $t"; fi; tail -2 /tmp/p; done

echo "===== TEST Kensuke ====="; ip -br addr; echo "ip_forward=$(cat /proc/sys/net/ipv4/ip_forward)"; ls -l /root/kensuke.sh; tail -2 /etc/network/interfaces
for t in 10.80.4.153; do if ping -c 2 -W 1 $t >/tmp/p 2>&1; then echo "PASS ping $t"; else echo "FAIL ping $t"; fi; tail -2 /tmp/p; done

echo "===== TEST Ritsuko ====="; ip -br addr; echo "ip_forward=$(cat /proc/sys/net/ipv4/ip_forward)"; ls -l /root/ritsuko.sh; tail -2 /etc/network/interfaces
for t in 10.80.4.157; do if ping -c 2 -W 1 $t >/tmp/p 2>&1; then echo "PASS ping $t"; else echo "FAIL ping $t"; fi; tail -2 /tmp/p; done

echo "===== TEST Kaji ====="; ip -br addr; echo "ip_forward=$(cat /proc/sys/net/ipv4/ip_forward)"; ls -l /root/kaji.sh; tail -2 /etc/network/interfaces
for t in 10.80.4.121; do if ping -c 2 -W 1 $t >/tmp/p 2>&1; then echo "PASS ping $t"; else echo "FAIL ping $t"; fi; tail -2 /tmp/p; done

echo "===== TEST Misato ====="; ip -br addr; echo "ip_forward=$(cat /proc/sys/net/ipv4/ip_forward)"; ls -l /root/misato.sh; tail -2 /etc/network/interfaces
for t in 10.80.4.125; do if ping -c 2 -W 1 $t >/tmp/p 2>&1; then echo "PASS ping $t"; else echo "FAIL ping $t"; fi; tail -2 /tmp/p; done

echo "===== TEST Shigeru ====="; ip -br addr; echo "ip_forward=$(cat /proc/sys/net/ipv4/ip_forward)"; ls -l /root/shigeru.sh; tail -2 /etc/network/interfaces
for t in 10.80.4.129 10.80.4.162; do if ping -c 2 -W 1 $t >/tmp/p 2>&1; then echo "PASS ping $t"; else echo "FAIL ping $t"; fi; tail -2 /tmp/p; done

echo "===== TEST Makoto ====="; ip -br addr; echo "ip_forward=$(cat /proc/sys/net/ipv4/ip_forward)"; ls -l /root/makoto.sh; tail -2 /etc/network/interfaces
for t in 10.80.4.161; do if ping -c 2 -W 1 $t >/tmp/p 2>&1; then echo "PASS ping $t"; else echo "FAIL ping $t"; fi; tail -2 /tmp/p; done

echo "===== TEST Fuyutsuki ====="; ip -br addr; echo "ip_forward=$(cat /proc/sys/net/ipv4/ip_forward)"; ls -l /root/fuyutsuki.sh; tail -2 /etc/network/interfaces
for t in 10.80.4.133 10.80.4.166 10.80.4.170; do if ping -c 2 -W 1 $t >/tmp/p 2>&1; then echo "PASS ping $t"; else echo "FAIL ping $t"; fi; tail -2 /tmp/p; done

echo "===== TEST Toji ====="; ip -br addr; echo "ip_forward=$(cat /proc/sys/net/ipv4/ip_forward)"; ls -l /root/toji.sh; tail -2 /etc/network/interfaces
for t in 10.80.4.165; do if ping -c 2 -W 1 $t >/tmp/p 2>&1; then echo "PASS ping $t"; else echo "FAIL ping $t"; fi; tail -2 /tmp/p; done

echo "===== TEST Maya ====="; ip -br addr; echo "ip_forward=$(cat /proc/sys/net/ipv4/ip_forward)"; ls -l /root/maya.sh; tail -2 /etc/network/interfaces
for t in 10.80.4.169; do if ping -c 2 -W 1 $t >/tmp/p 2>&1; then echo "PASS ping $t"; else echo "FAIL ping $t"; fi; tail -2 /tmp/p; done