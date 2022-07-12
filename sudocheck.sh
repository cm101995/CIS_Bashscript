#!/bin/bash
if dpkg -s sudo | grep 'installed'; then
	echo 'sudo is installed'
else
	echo 'sudo is not installed'
	apt-get install sudo 
fi

if grep -Ei '^\s*Defaults\s+([^#]+,\s*)?use_pty(,\s+\S+\s*)*(\s+#.*)?$' /etc/sudoers; then
	echo 'sudo is configured to run under pesudo_pty'
else
	echo 'sudo is not configured to run under pseudo_pty'
	echo 'Defaults use_pty' >> /etc/sudoers
fi 

if grep -Ei '^\s*Defaults\s+logfile=\S+' /etc/sudoers ; then
	echo 'log file is configured for sudo'
else
	echo 'log file is not configured for sudo'
	echo 'Defaults logfile="/var/log/sudo.log"' >> /etc/sudoers
fi