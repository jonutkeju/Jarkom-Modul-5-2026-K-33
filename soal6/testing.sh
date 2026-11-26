#Unit 01
t(){ if "$@" >/dev/null 2>&1; then echo "PASS $*"; else echo "FAIL $*"; fi; }
G=$(ip route | awk '/^default/{print $3}')
echo "== $(hostname) =="; ip -br addr show eth0; ip route | grep default
t ping -c2 -W3 $G
t ping -c2 -W3 8.8.8.8
t ping -c2 -W3 deb.debian.org
ping -c3 $G

#Gendou
ok=0; bad=0
for ip in 10.80.0.2 10.80.2.2 10.80.3.2 10.80.3.130 10.80.3.194 10.80.3.195 10.80.3.226 10.80.4.2 10.80.4.34 10.80.4.50 10.80.4.51 10.80.4.58 10.80.4.59 10.80.4.60 10.80.4.66 10.80.4.67 10.80.4.68 10.80.4.74 10.80.4.75 10.80.4.82 10.80.4.83 10.80.4.90 10.80.4.98 10.80.4.102 10.80.4.106; do
  if ping -c1 -W2 $ip >/dev/null 2>&1; then ok=$((ok+1)); else bad=$((bad+1)); echo "FAIL $ip"; fi
done
echo "== $(hostname) == HOST_REACHABLE=$ok HOST_UNREACHABLE=$bad (harus 25 / 0)"