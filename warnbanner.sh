#!/bin/bash
if grep -E -i -s "(\\\v|\\\r|\\\m|\\\s|$(grep '^ID=' /etc/os-release | cut -d= -f2 | sed -e 's/"//g'))" /etc/motd;then
	echo "motd is configured"
else
	echo "motd is is not configured"
	echo "Configuring the same"
	echo "********************************" > /etc/motd
	echo "            WELCOME             " >> /etc/motd
	echo "********************************" >> /etc/motd
	apt install python
	echo "python ~/CIS/cis.py" >> /etc/motd.sh
	echo "sh /etc/motd.sh" >> /etc/profile
fi

if grep -E -i "(\\\v|\\\r|\\\m|\\\s|$(grep '^ID=' /etc/os-release | cut -d= -f2 | sed -e 's/"//g'))" /etc/issue;then
        echo "issue is configured"
else
        echo "issue is is not configured"
        echo "Configuring the same"
        echo "Authorized users only. All activity may be monitored and reported." > /etc/issue
fi

chown root:root /etc/motd
chmod u-x,go-wx /etc/motd
chown root:root /etc/issue
chmod u-x,go-wx /etc/issue
chown root:root /etc/issue.net
chmod u-x,go-wx /etc/issue.net

STRING2=$(cat /etc/gdm3/greeter.dconf-defaults | grep banner-message-enable)
if apt list --installed | grep 'gdm' ; then
	echo "gdm is installed"
	if [[ ${STRING2:0:1} == "#" ]]; then
		echo "gdm is configured"
	else
		echo "Configuring gdm"
		echo 'banner-message-enable=true' >> /etc/gdm3/greeter.dconf-defaults
		echo 'banner-message-text="Authorized users only. All activity may be monitored and reported."' >> /etc/gdm3/greeter.dconf-defaults
	fi
else
	echo "gdm is not insatlled"
	echo "installing gdm"
	apt install gdm
fi
