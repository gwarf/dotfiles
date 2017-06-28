#!/bin/sh

OUT_IF=enp0s31f6
#OUT_IF=wlp4s0

# Enable forwarding
sudo sysctl -q -w net.ipv4.ip_forward=1

# Activate Masquerading of host-only network
sudo iptables -A FORWARD -o $OUT_IF -i vboxnet0 -s 192.168.56.0/24 -m conntrack --ctstate NEW -j ACCEPT
sudo iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A POSTROUTING -t nat -j MASQUERADE
