#!/bin/bash
echo 1 > /proc/sys/net/ipv4/ip_forward

iptables -F
iptables -t nat -F
iptables -X

iptables -A FORWARD -i tun0 -o eth0 -j ACCEPT
iptables -A FORWARD -i eth0 -o tun0 -j ACCEPT
iptables -A FORWARD -i eth0 -o tun0 -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i tun0 -o eth0 -m state --state ESTABLISHED,RELATED -j ACCEPT

## Send docker webservers
iptables -t nat -A PREROUTING -p tcp --dport 443 -j DNAT --to-destination 10.8.0.6:443
iptables -t nat -A POSTROUTING -p tcp -d 10.8.0.6 --dport 443 -j SNAT --to-source 10.8.0.1

## Send docker webservers
iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-destination 10.8.0.6:80
iptables -t nat -A POSTROUTING -p tcp -d 10.8.0.6 --dport 80 -j SNAT --to-source 10.8.0.1

## Emby
iptables -t nat -A PREROUTING -p tcp --dport 8920 -j DNAT --to-destination 10.8.0.6:8920
iptables -t nat -A POSTROUTING -p tcp -d 10.8.0.6 --dport 8920 -j SNAT --to-source 10.8.0.1

## openvpn
iptables -t nat -A PREROUTING -p udp --dport 1194 -j DNAT --to-destination 10.8.0.6:1194
iptables -t nat -A POSTROUTING -p udp -d 10.8.0.6 --dport 1194 -j SNAT --to-source 10.8.0.1

## minecraft PE
iptables -t nat -A PREROUTING -p udp --dport 19132 -j DNAT --to-destination 10.8.0.6:19132
iptables -t nat -A POSTROUTING -p udp -d 10.8.0.6 --dport 19132 -j SNAT --to-source 10.8.0.1

## RDP
iptables -t nat -A PREROUTING -p tcp --dport 3389 -j DNAT --to-destination 10.8.0.6:3389
iptables -t nat -A POSTROUTING -p tcp -d 10.8.0.6 --dport 3389 -j SNAT --to-source 10.8.0.1

## RDP
iptables -t nat -A PREROUTING -p udp --dport 3389 -j DNAT --to-destination 10.8.0.6:3389
iptables -t nat -A POSTROUTING -p udp -d 10.8.0.6 --dport 3389 -j SNAT --to-source 10.8.0.1


### Drop packets about pihole