#!/bin/bash
if dpkg -s tcpd; then
        echo "tcpd is already installed"
else
        echo "tcpd is not installed"
        echo "Installing"
        apt install tcpd
fi
chown root:root /etc/hosts.allow
chmod 644 /etc/hosts.allow
chown root:root /etc/hosts.deny
chmod 644 /etc/hosts.deny

if modprobe -n -v dccp | grep true;then
        echo "dccp is already disabled"
else
        echo "dccp is not disabled"
        echo "Disabling"
        touch /etc/modprobe.d/dccp.conf
        echo 'install dccp /bin/true' > /etc/modprobe.d/dccp.conf
fi

if modprobe -n -v sctp | grep true;then
        echo "sctp is already disabled"
else
        echo "sctp is not disabled"
        echo "Disabling"
        touch /etc/modprobe.d/sctp.conf
        echo "install sctp /bin/true" > /etc/modprobe.d/sctp.conf
fi

if modprobe -n -v rds | grep true;then
        echo "rds is already disabled"
else
        echo "rds is not disabled"
        echo "Disabling"
        touch /etc/modprobe.d/rds.conf
        echo "install rds /bin/true" > /etc/modprobe.d/rds.conf
fi

if modprobe -n -v tipc | grep true;then
        echo "tipc is already disabled"
else
        echo "tipc is not disabled"
        echo "Disabling"
        touch /etc/modprobe.d/tipc.conf
        echo "install tipc /bin/true" > /etc/modprobe.d/tipc.conf
fi

if dpkg -s ufw | grep installed;then
        echo "ufw is already installed"
else
        echo "ufw is not installed"
        echo "Installing"
        apt install ufw
fi

if dpkg -s nftables | grep installed;then
        echo "nftables is already installed"
else
        echo "nftables is not installed"
        echo "Installing"
        apt install nftables
fi

if dpkg -s iptables | grep installed;then
        echo "iptables is already installed"
else
        echo "iptables is not installed"
        echo "Installing"
        apt install iptables
fi

# ufw enable
# ufw default deny incoming
# ufw default deny outgoing
# ufw default deny routed
# ufw allow in on lo
# ufw deny in from 127.0.0.0/8
# ufw deny in from ::1
# nft create table inet filter
# nft create chain inet filter input { type filter hook input priority 0 \; }
# nft create chain inet filter forward { type filter hook forward priority 0 \; }
# nft create chain inet filter output { type filter hook output priority 0 \;}
# nft add rule inet filter input iif lo accept
# nft create rule inet filter input ip saddr 127.0.0.0/8 counter drop
# nft add rule inet filter input ip6 saddr ::1 counter drop
# nft add rule inet filter input ip protocol tcp ct state established accept
# nft add rule inet filter input ip protocol udp ct state established accept
# nft add rule inet filter input ip protocol icmp ct state established accept
# nft add rule inet filter output ip protocol tcp ct state new,related,established accept
# nft add rule inet filter output ip protocol udp ct state new,related,established accept
# nft add rule inet filter output ip protocol icmp ct state new,related,established accept
# nft chain inet filter input { policy drop \; }
# nft chain inet filter forward { policy drop \; }
# nft chain inet filter output { policy drop \; }
# systemctl enable nftables
echo 'include "/etc/nftables/nftables.rules"' >> /etc/nftables.conf
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT
iptables -A INPUT -s 127.0.0.0/8 -j DROP
ip6tables -P INPUT DROP
ip6tables -P OUTPUT DROP
ip6tables -P FORWARD DROP
ip6tables -A INPUT -i lo -j ACCEPT
ip6tables -A OUTPUT -o lo -j ACCEPT
ip6tables -A INPUT -s ::1 -j DROP
ip6tables -A OUTPUT -p tcp -m state --state NEW,ESTABLISHED -j ACCEPT
ip6tables -A OUTPUT -p udp -m state --state NEW,ESTABLISHED -j ACCEPT
ip6tables -A OUTPUT -p icmp -m state --state NEW,ESTABLISHED -j ACCEPT
ip6tables -A INPUT -p tcp -m state --state ESTABLISHED -j ACCEPT
ip6tables -A INPUT -p udp -m state --state ESTABLISHED -j ACCEPT
ip6tables -A INPUT -p icmp -m state --state ESTABLISHED -j ACCEPT
nmcli radio all off
sed -i '/GRUB_CMDLINE_LINUX=""/ c GRUB_CMDLINE_LINUX="ipv6.disable=1"' /etc/default/grub 

