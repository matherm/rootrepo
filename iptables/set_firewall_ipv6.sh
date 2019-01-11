#sudo su -c 'ip6tables-save > /etc/iptables/rules.v6'

#IPv6
ip6tables -N TCP
ip6tables -N UDP
ip6tables -P FORWARD DROP
ip6tables -P OUTPUT ACCEPT
ip6tables -P INPUT DROP
ip6tables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
ip6tables -A INPUT -i lo -j ACCEPT
ip6tables -A INPUT -m conntrack --ctstate INVALID -j DROP
ip6tables -A INPUT -s fe80::/10 -p icmpv6 -j ACCEPT
ip6tables -A INPUT -p ipv6-icmp --icmpv6-type 128 -m conntrack --ctstate NEW -j ACCEPT
ip6tables -A INPUT -p udp -m conntrack --ctstate NEW -j UDP
ip6tables -A INPUT -p tcp --syn -m conntrack --ctstate NEW -j TCP
ip6tables -A INPUT -p udp -j REJECT --reject-with icmp6-adm-prohibited
ip6tables -A INPUT -p tcp -j REJECT --reject-with tcp-reset
ip6tables -A INPUT -j REJECT --reject-with icmp6-adm-prohibited
# Kernel Reverse Path
ip6tables -t raw -A PREROUTING -m rpfilter -j ACCEPT
ip6tables -t raw -A PREROUTING -j DROP

#Opening TCP Ports
# ip6tables -A TCP -p tcp --dport 80 -j ACCEPT
# Block SYN Scans
ip6tables -I TCP -p tcp -m recent --update --seconds 60 --name TCP-PORTSCAN -j REJECT --reject-with tcp-reset
ip6tables -D INPUT -p tcp -j REJECT --reject-with tcp-reset
ip6tables -A INPUT -p tcp -m recent --set --name TCP-PORTSCAN -j REJECT --reject-with tcp-reset

# Block UDP Scans
ip6tables -I UDP -p udp -m recent --update --seconds 60 --name UDP-PORTSCAN -j REJECT --reject-with icmp6-adm-prohibited
ip6tables -D INPUT -p udp -j REJECT --reject-with icmp6-adm-prohibited
ip6tables -A INPUT -p udp -m recent --set --name UDP-PORTSCAN -j REJECT --reject-with icmp6-adm-prohibited

# Restore final rule
ip6tables -D INPUT -j REJECT --reject-with icmp6-adm-prohibited
ip6tables -A INPUT -j REJECT --reject-with icmp6-adm-prohibited
