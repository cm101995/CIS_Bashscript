#!/bin/bash
if apt list --installed | grep 'xinetd' ; then
        echo "xinetd is installed"
        echo "removing it"
        apt purge xinetd
else
        echo "xinetd is not installed"
fi

if apt list --installed | grep 'openbsd-inetd' ; then
        echo "openbsd-inetd is installed"
        echo "removing it"
        apt purge openbsd-inetd
else
        echo "openbsd-inetd is not installed"
fi

if apt list --installed | grep 'ntp' ; then
        echo "ntp is installed"
else
        echo "ntp is not installed"
        apt install ntp
fi

# if apt list --installed | grep 'xserver-xorg*' ; then
#         echo "xserver-xorg* is installed"
#         echo "removing it"
#         apt purge xserver-xorg*
# else
#         echo "xserver-xorg* is not installed"
# fi

if [[ $(systemctl is-enabled avahi-daemon) == enabled ]]; then
        echo 'avahi service is enabled'
        systemctl --now disable avahi-daemon
else
        echo 'avahi service is disabled'
fi

if [[ $(systemctl is-enabled cups) == enabled ]]; then
        echo 'CUPS service is enabled'
        systemctl --now disable cups
else
        echo 'CUPS service is disabled'
fi

if [[ $(systemctl is-enabled isc-dhcp-server) == enabled ]]; then
        echo 'DHCP service is enabled'
        systemctl --now disable isc-dhcp-server
else
        echo 'DHCP service is disabled'
fi

if [[ $(systemctl is-enabled slapd) == enabled ]]; then
        echo 'LDAP service is enabled'
        systemctl --now disable slapd
else
        echo 'LDAP service is disabled'
fi

if [[ $(systemctl is-enabled nfs-server) == enabled ]]; then
        echo 'NFS service is enabled'
        systemctl --now disable nfs-server
else
        echo 'NFS service is disabled'
fi

if [[ $(systemctl is-enabled rpcbind) == enabled ]]; then
        echo 'RPC service is enabled'
        systemctl --now disable rpcbind
else
        echo 'RPC service is disabled'
fi

if [[ $(systemctl is-enabled bind9) == enabled ]]; then
        echo 'DNS service is enabled'
        systemctl --now disable bind9
else
        echo 'DNS service is disabled'
fi

if [[ $(systemctl is-enabled vsftpd) == enabled ]]; then
        echo 'FTP service is enabled'
        systemctl --now disable vsftpd
else
        echo 'FTP service is disabled'
fi

if [[ $(systemctl is-enabled apache2) == enabled ]]; then
        echo 'HTTP service is enabled'
        systemctl --now disable apache2
else
        echo 'HTTP service is disabled'
fi

if [[ $(systemctl is-enabled dovecot) == enabled ]]; then
        echo 'Mail service is enabled'
        systemctl --now disable dovecot
else
        echo 'Mail service is disabled'
fi

if [[ $(systemctl is-enabled smbd) == enabled ]]; then
        echo 'Samba service is enabled'
        systemctl --now disable smbd
else
        echo 'Samba service is disabled'
fi

if [[ $(systemctl is-enabled squid) == enabled ]]; then
        echo 'HTTP proxy service is enabled'
        systemctl --now disable squid
else
        echo 'HTTP proxy service is disabled'
fi

if [[ $(systemctl is-enabled snmpd) == enabled ]]; then
        echo 'SNMP proxy service is enabled'
        systemctl --now disable snmpd
else
        echo 'SNMP proxy service is disabled'
fi

if [[ $(systemctl is-enabled rsync) == enabled ]]; then
        echo 'rsync service is enabled'
        systemctl --now disable rsync
else
        echo 'rsync service is disabled'
fi

if [[ $(systemctl is-enabled nis) == enabled ]]; then
        echo 'NIS proxy service is enabled'
        systemctl --now disable nis
else
        echo 'NIS service is disabled'
fi

if $( ss -lntu | grep -E ':25\s' | grep -E -v '\s(127.0.0.1|::1):25\s' ); then
        echo "mail transfer agent is not configured for local only"
        echo "configuring"
        sed -i '/inet_interfaces/s/= .*/= loopback-only/' /etc/postfix/main.cf
else
        echo "mail transfer agent is configured for local only"
fi
