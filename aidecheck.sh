#!/bin/bash
if dpkg -s aide | grep 'installed'; then
	echo 'aide is installed'
else
	echo 'aide is not installed'
	apt-get install aide aide-common
	echo 'Initializing aide'
	aideinit
	sleep 30
	kill -9 $(pgrep -f aideinit)
fi

if crontab -u root -l | grep aide; then
	echo 'cronjob is configured for aide'
else
	echo 'cronjob is not configured for aide'
	echo 'configuring cronjob for aide'
	0 5 * * * /usr/bin/aide --config /etc/aide/aide.conf --check >> /var/spool/cron/crontabs/root
fi
