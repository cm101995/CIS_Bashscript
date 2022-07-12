#!/bin/bash

if journalctl | grep 'protection: active';then
        echo "NX/XD protection is active and your system is protected from most of the buffer overflow at>"
else
        echo "WARNING"
        echo "NX/XD protection is disabled"
        echo "please enable it to protect your system from buffer overflow attacks"
fi

if sysctl kernel.randomize_va_space | grep "2";then
        echo "Active kernel parameter is set"
else
        echo "Active kernel parameter is not set"
        echo "Setting the same"
        sysctl -w kernel.randomize_va_space=2
fi

if grep "kernel\.randomize_va_space" /etc/sysctl.conf; then
        echo "ASLR is set"
else
        echo "ASLR is not set"
        echo "Setting the ASLR"
        echo "kernel.randomize_va_space = 2" >> /etc/sysctl.conf
fi

if dpkg -s prelink | grep 'installed';then
	echo "prelink is enabled"
	echo "Disabling it"
	prelink -ua
	apt purge prelink
else
	echo "prelink is not installed"
fi

if grep "hard core" /etc/security/limits.conf;then
	echo "hard core limit is configured"
else
	echo "hard core limit is not configured"
	echo "configuring hard core limit"
	echo "* hard core 0" >> /etc/security/limits.conf
fi

if  sysctl fs.suid_dumpable | grep "0";then
	echo "fs.suid_dumpbale limit is configured in kernel"
else
	echo "fs.suid_dumpbale limit is not configured in kernel"
	echo "Configuring fs.suid_dumpbale limit"
	sysctl -w fs.suid_dumpable=0
fi

if  grep "fs\.suid_dumpable" /etc/sysctl.conf;then
        echo "fs.suid_dumpbale limit is configured"
else
        echo "fs.suid_dumpbale limit is not configured"
        echo "Configuring fs.suid_dumpbale limit"
	echo "fs.suid_dumpable = 0" >> /etc/sysctl.conf
fi

if systemctl is-enabled coredump.service; then
	echo 'Storage=none' >> /etc/systemd/coredump.conf
	echo 'ProcessSizeMax=0' >> /etc/systemd/coredump.conf
	systemctl daemon-reload
else
	echo 'coredump service is not installed'
fi