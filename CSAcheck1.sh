#!/bin/bash
if dpkg -s rsyslog; then
	echo "rsyslog is already insatlled"
else
	echo "rsyslog is not installed"
	echo "Installing"
	apt install rsyslog
fi

systemctl --now enable rsyslog

sed -i '/FileCreateMode/ c $FileCreateMode 0640' /etc/rsyslog.conf

echo '*.* @@34.120.130.120' >> /etc/rsyslog.conf

sed -i '/ForwardToSyslog=yes/ c ForwardToSyslog=yes' /etc/systemd/journald.conf

sed -i '/Compress=yes/ c Compress=yes' /etc/systemd/journald.conf

sed -i '/Storage/ c Storage=peristent' /etc/systemd/journald.conf

find /var/log -type f -exec chmod g-wx,o-rwx "{}" + -o -type d -exec chmod g-w,o-rwx "{}" +

systemctl --now enable cron

chown root:root /etc/crontab

chmod og-rwx /etc/crontab

chown root:root /etc/cron.daily

chmod og-rwx /etc/cron.daily

chown root:root /etc/cron.weekly

chmod og-rwx /etc/cron.weekly

chown root:root /etc/cron.monthly
chmod og-rwx /etc/cron.monthly

chown root:root /etc/cron.d
chmod og-rwx /etc/cron.d

rm /etc/cron.deny
rm /etc/at.deny
touch /etc/cron.allow
touch /etc/at.allow
chmod o-rwx /etc/cron.allow
chmod o-rwx /etc/at.allow
chown root:root /etc/cron.allow
chown root:root /etc/at.allow

chown root:root /etc/ssh/sshd_config
chmod og-rwx /etc/ssh/sshd_config

find /etc/ssh -xdev -type f -name 'ssh_host_*_key' -exec chown root:root {} \;
find /etc/ssh -xdev -type f -name 'ssh_host_*_key' -exec chmod 0600 {} \;
find /etc/ssh -xdev -type f -name 'ssh_host_*_key.pub' -exec chmod 0644 {} \;
find /etc/ssh -xdev -type f -name 'ssh_host_*_key.pub' -exec chown root:root {} \;

sed -i '/X11Forwarding yes/ c X11Forwarding no' /etc/ssh/sshd_config 
sed -i '/LogLevel/ c LogLevel INFO' /etc/ssh/sshd_config 
sed -i '/MaxAuthTries 6/ c MaxAuthTries 4' /etc/ssh/sshd_config
sed -i '/IgnoreRhosts/ c IgnoreRhosts yes' /etc/ssh/sshd_config
sed -i '/HostbasedAuthentication yes/ c HostbasedAuthentication no' /etc/ssh/sshd_config
sed -i '/PermitRootLogin prohibit/ c PermitRootLogin no' /etc/ssh/sshd_config 
sed -i '/PermitEmptyPasswords/ c PermitEmptyPasswords no' /etc/ssh/sshd_config 
sed -i '/PermitUserEnvironment/ c PermitUserEnvironment no' /etc/ssh/sshd_config
sed -i '/ClientAliveInterval/ c ClientAliveInterval 300' /etc/ssh/sshd_config
sed -i '/ClientAliveCountMax/ c ClientAliveCountMax 0' /etc/ssh/sshd_config
sed -i '/LoginGraceTime/ c LoginGraceTime 60' /etc/ssh/sshd_config
sed -i '/HostbasedAuthentication no/ c HostbasedAuthentication no' /etc/ssh/sshd_config
echo "Protocol 2" >> /etc/ssh/sshd_config
echo 'AllowUsers ubuntu' >> /etc/ssh/sshd_config
sed -i '/Banner/ c Banner /etc/issue.net' /etc/ssh/sshd_config
sed -i '/UsePAM/ c UsePAM yes' /etc/ssh/sshd_config
sed -i '/AllowTcpForwarding yes/ c AllowTcpForwarding no' /etc/ssh/sshd_config
sed -i '/MaxStartups/ c MaxStartups 10:30:60' /etc/ssh/sshd_config
sed -i '/MaxSessions/ c MaxSessions 4' /etc/ssh/sshd_config
apt install libpam-pwquality
sed -i '/minlen/ c minlen 14' /etc/security/pwquality.conf
sed -i '/dcredit/ c dcredit = -1' /etc/security/pwquality.conf
sed -i '/ucredit/ c ucredit = -1' /etc/security/pwquality.conf
sed -i '/ocredit/ c ocredit = -1' /etc/security/pwquality.conf
sed -i '/lcredit/ c lcredit = -1' /etc/security/pwquality.conf
echo 'password requisite pam_pwquality.so retry=3' >> /etc/pam.d/common-password 
echo 'auth required pam_tally2.so onerr=fail audit silent deny=5 unlock_time=900' >> /etc/pam.d/common-auth
echo 'account required pam_tally.so' >> /etc/pam.d/common-account