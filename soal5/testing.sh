#Gendou
t(){ if "$@" >/dev/null 2>&1; then echo "PASS $*"; else echo "FAIL $*"; fi; }
echo "== $(hostname) =="; iptables -S
echo "ip_forward=$(cat /proc/sys/net/ipv4/ip_forward)  rute_statis=$(ip route | grep -c ' via 10.80.4\.') (harus 22)"
ip -br addr show eth0; ip route | grep default
cat /etc/resolv.conf
iptables -t nat -S POSTROUTING
t ping -c2 -W3 8.8.8.8
t ping -c2 -W3 deb.debian.org

#Lilith -> Armisael
case "$(hostname | tr 'A-Z' 'a-z')" in
  armisael*) A=10.80.4.83/29; G=10.80.4.81 ;;
  lilith*)   A=10.80.4.74/29; G=10.80.4.73 ;;
  *) echo "hostname tidak dikenal: $(hostname)"; A=; G= ;;
esac
if [ -n "$A" ]; then
  ip link set eth0 up; ip addr replace $A dev eth0; ip route replace default via $G
  printf 'nameserver 8.8.8.8\n' > /etc/resolv.conf
fi
t(){ if "$@" >/dev/null 2>&1; then echo "PASS $*"; else echo "FAIL $*"; fi; }
echo "== $(hostname) =="; ip -br addr show eth0; ip route
t ping -c2 -W3 8.8.8.8
t ping -c2 -W3 deb.debian.org
t ping -c2 -W3 10.80.4.74
t ping -c2 -W3 10.80.4.129
ping -c3 8.8.8.8

#Gendou
iptables -L INPUT -n -v; iptables -L FORWARD -n -v
