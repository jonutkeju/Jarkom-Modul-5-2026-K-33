#Armisael & Lilith
case "$(hostname | tr 'A-Z' 'a-z')" in
  armisael*) A=10.80.4.83/29; G=10.80.4.81 ;;
  lilith*)   A=10.80.4.74/29; G=10.80.4.73 ;;
  *) echo "hostname tidak dikenal: $(hostname)"; A=; G= ;;
esac
if [ -n "$A" ]; then
  ip link set eth0 up; ip addr replace $A dev eth0; ip route replace default via $G
  printf 'nameserver 8.8.8.8\n' > /etc/resolv.conf
fi
echo "== $(hostname) =="; ip -br addr show eth0; ip route; cat /etc/resolv.conf
for t in 8.8.8.8 deb.debian.org; do
  if ping -c3 -W3 $t >/dev/null 2>&1; then echo "PASS ping $t"; else echo "FAIL ping $t"; fi
done
ping -c3 8.8.8.8
ping -c3 deb.debian.org

#Gendou
echo "== $(hostname) =="; ip -br addr show eth0
iptables -t nat -L POSTROUTING -n -v --line-numbers
iptables -t nat -S POSTROUTING