#Node: Quarters, Comm-Net, Hangar-Crew, Sachiel, Pen-Pen, Medic-Bay, Relay-Node, Garden-Staff, Dock-Crew, Entry-Plug, Dummy-Plug, Magi-Casper, Magi-Balthasar, Magi-Melchior, Unit-01, Unit-02, Unit-00, Lilith, Adam, Zeruel, Armisael, Radar-Array, Archive-Vault, Spy, Tokyo3-Core.
H=$(hostname | tr 'A-Z' 'a-z')
A=
case "$H" in
  quarters*     ) A=10.80.0.2; P=23; M=255.255.254.0; G=10.80.0.1 ;;
  comm*         ) A=10.80.2.2; P=24; M=255.255.255.0; G=10.80.2.1 ;;
  hangar*       ) A=10.80.3.2; P=25; M=255.255.255.128; G=10.80.3.1 ;;
  sachiel*      ) A=10.80.3.130; P=26; M=255.255.255.192; G=10.80.3.129 ;;
  pen-pen*      ) A=10.80.3.194; P=27; M=255.255.255.224; G=10.80.3.193 ;;
  medic*        ) A=10.80.3.195; P=27; M=255.255.255.224; G=10.80.3.193 ;;
  relay*        ) A=10.80.3.226; P=27; M=255.255.255.224; G=10.80.3.225 ;;
  garden*       ) A=10.80.4.2; P=27; M=255.255.255.224; G=10.80.4.1 ;;
  dock*         ) A=10.80.4.34; P=28; M=255.255.255.240; G=10.80.4.33 ;;
  entry*        ) A=10.80.4.50; P=29; M=255.255.255.248; G=10.80.4.49 ;;
  dummy*        ) A=10.80.4.51; P=29; M=255.255.255.248; G=10.80.4.49 ;;
  *casper*      ) A=10.80.4.58; P=29; M=255.255.255.248; G=10.80.4.57 ;;
  *balthasar*   ) A=10.80.4.59; P=29; M=255.255.255.248; G=10.80.4.57 ;;
  *melchior*    ) A=10.80.4.60; P=29; M=255.255.255.248; G=10.80.4.57 ;;
  unit-01*      ) A=10.80.4.66; P=29; M=255.255.255.248; G=10.80.4.65 ;;
  unit-02*      ) A=10.80.4.67; P=29; M=255.255.255.248; G=10.80.4.65 ;;
  unit-00*      ) A=10.80.4.68; P=29; M=255.255.255.248; G=10.80.4.65 ;;
  lilith*       ) A=10.80.4.74; P=29; M=255.255.255.248; G=10.80.4.73 ;;
  adam*         ) A=10.80.4.75; P=29; M=255.255.255.248; G=10.80.4.73 ;;
  zeruel*       ) A=10.80.4.82; P=29; M=255.255.255.248; G=10.80.4.81 ;;
  armisael*     ) A=10.80.4.83; P=29; M=255.255.255.248; G=10.80.4.81 ;;
  radar*        ) A=10.80.4.90; P=29; M=255.255.255.248; G=10.80.4.89 ;;
  archive*      ) A=10.80.4.98; P=30; M=255.255.255.252; G=10.80.4.97 ;;
  spy*          ) A=10.80.4.102; P=30; M=255.255.255.252; G=10.80.4.101 ;;
  tokyo3*       ) A=10.80.4.106; P=30; M=255.255.255.252; G=10.80.4.105 ;;
esac
if [ -z "$A" ]; then
  echo "ERROR: hostname '$H' tidak dikenal, tidak ada yang diubah"
else
  cp -n /etc/network/interfaces /root/interfaces.orig 2>/dev/null
  cat > /etc/network/interfaces <<EOF
auto lo
iface lo inet loopback

# gateway $G dan DNS dipasang oleh /root/$H.sh
auto eth0
iface eth0 inet static
    address $A
    netmask $M
    up sh /root/$H.sh
EOF
  cat > /root/$H.sh <<EOF
#!/bin/sh
# Soal 6 - IP statis + gateway + DNS ($H)
ip link set eth0 up
ip addr flush dev eth0
ip addr add $A/$P dev eth0
ip route replace default via $G
echo nameserver 8.8.8.8 > /etc/resolv.conf
EOF
  cat >> /root/$H.sh <<'EOF'
# --- tambahan per soal: soal1.sh ... soal20.sh (otomatis ikut, urut angka) ---
for n in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20; do [ -f /root/soal$n.sh ] && sh /root/soal$n.sh; done; true
EOF
  chmod +x /root/$H.sh
  sh /root/$H.sh
  echo "== $(hostname) =="; cat /etc/network/interfaces; tail -3 /root/$H.sh; ip -br addr show eth0; ip route; cat /etc/resolv.conf
fi