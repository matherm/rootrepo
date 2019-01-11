#!/bin/bash

#remove All
iptables -F


# Setting default policies:
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

#Disable ICMP
iptables -A OUTPUT -p icmp --icmp-type echo-request -j DROP

#Accept from public LAN
iptables -A INPUT -p tcp --dport 22 -j ACCEPT       # SSH

#Accept from private LAN
iptables -A INPUT -i eth1 -j ACCEPT                 
iptables -A OUTPUT -o eth1 -j ACCEPT

#Allow Inet
iptables -A OUTPUT -o eth0 -d 0.0.0.0/0 -j ACCEPT
iptables -A INPUT -i eth0 -m state --state ESTABLISHED,RELATED -j ACCEPT

#Allow private LAN
iptables -A OUTPUT -o eth1 -d 0.0.0.0/0 -j ACCEPT
iptables -A INPUT -i eth1 -m state --state ESTABLISHED,RELATED -j ACCEPT
