#!/bin/sh

# Enable masquerading of host-only virtualbox network

VBOX_NETWORK='192.168.56.0/24'

# Might retur multiple routes (for wired and wifi)
# OUT_IF=$(ip route show to 0.0.0.0/0 | awk '{print $5}')
OUT_IF=$(ip route get 8.8.8.8 | awk '/8.8.8.8/ {print $5}')
LOCAL_IFS=$(ip link show up | grep -B1 'link/ether' | awk '/^[0-9]*:/ {print $2}' | sed 's/:$//')

if ! echo "$LOCAL_IFS" | grep -q "$OUT_IF"; then
  printf "$OUT_IF is invalid!\n"
  printf "Output interface should be one of:\n"
  printf "$LOCAL_IFS\n"
  exit 1
fi


# XXX OUT_IF should only contain one IP
# XXX Add a check for this

# Enable forwarding
sudo sysctl -q -w net.ipv4.ip_forward=1

# Activate Masquerading of host-only network
sudo iptables -A FORWARD -o "$OUT_IF" -i vboxnet0 -s "$VBOX_NETWORK" -m conntrack --ctstate NEW -j ACCEPT
sudo iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A POSTROUTING -t nat -j MASQUERADE
