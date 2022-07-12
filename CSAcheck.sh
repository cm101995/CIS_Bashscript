#!/bin/bash
if dpkg -s auditd audispd-plugins; then
	echo "auditd is already installed"
else
	echo "auditd is not installed"
	echo "installing"
	apt install auditd audispd-plugins
fi

if systemctl is-enabled auditd | grep enabled; then
	echo "auditd is enabled"
else
	echo "auditd is not enabled"
	echo "enabling"
	systemctl --now enable auditd
fi

grep "^\s*linux" /boot/grub/grub.cfg | grep -v "audit=1" | grep -v '/boot/memtest86+.bin'

echo 'GRUB_CMDLINE_LINUX="audit=1"' >> /etc/default/grub

echo 'GRUB_CMDLINE_LINUX="audit_backlog_limit=8192"' >> /etc/default/grub

update grub

sed -i '/max_log_file_action/ c max_log_file_action = keep_logs' /etc/audit/auditd.conf

sed -i '/space_left_action = SYSLOG/ c space_left_action = email' /etc/audit/auditd.conf

sed -i '/admin_space_left_action/ c admin_space_left_action = halt' /etc/audit/auditd.conf

touch /etc/audit/rules.d/timely.rules
echo '-a always,exit -F arch=b64 -S adjtimex -S settimeofday -k time-change' > /etc/audit/rules.d/timely.rules
echo '-a always,exit -F arch=b32 -S adjtimex -S settimeofday -S stime -k time-change' >> /etc/audit/rules.d/timely.rules
echo '-a always,exit -F arch=b64 -S clock_settime -k time-change' >> /etc/audit/rules.d/timely.rules
echo '-a always,exit -F arch=b32 -S clock_settime -k time-change' >> /etc/audit/rules.d/timely.rules
echo '-w /etc/localtime -p wa -k time-change' >> /etc/audit/rules.d/timely.rules

touch /etc/audit/rules.d/identity.rules

echo '-w /etc/group -p wa -k identity' > /etc/audit/rules.d/identity.rules
echo '-w /etc/passwd -p wa -k identity' >> /etc/audit/rules.d/identity.rules
echo '-w etc/gshadow -p wa -k identity' >> /etc/audit/rules.d/identity.rules
echo '-w /etc/shadow -p wa -k identity' >> /etc/audit/rules.d/identity.rules
echo '-w /etc/security/opasswd -p wa -k identity' >> /etc/audit/rules.d/identity.rules

touch /etc/audit/rules.d/system-locale.rules

echo '-a always,exit -F arch=b64 -S sethostname -S setdomainname -k system-locale' > /etc/audit/rules.d/system-locale.rules
echo '-a always,exit -F arch=b32 -S sethostname -S setdomainname -k system-locale' >> /etc/audit/rules.d/system-locale.rules
echo '-w /etc/issue -p wa -k system-locale' >> /etc/audit/rules.d/system-locale.rules
echo '-w /etc/issue.net -p wa -k system-locale' >> /etc/audit/rules.d/system-locale.rules
echo '-/etc/hosts -p wa -k system-locale' >> /etc/audit/rules.d/system-locale.rules

touch /etc/audit/rules.d/MAC-policy.rules
echo '-w /etc/apparmor/ -p wa -k MAC-policy' > /etc/audit/rules.d/MAC-policy.rules
echo '-w /etc/apparmor.d/ -p wa -k MAC-policy' >> /etc/audit/rules.d/MAC-policy.rules

touch /etc/audit/rules.d/logins.rules
echo '-w /var/log/faillog -p wa -k logins' > /etc/audit/rules.d/logins.rules
echo '-w /var/log/lastlog -p wa -k logins' >> /etc/audit/rules.d/logins.rules
echo '-w /var/log/tallylog -p wa -k logins'>> /etc/audit/rules.d/logins.rules

touch /etc/audit/rules.d/session.rules
echo '-w /var/run/utmp -p wa -k session' > /etc/audit/rules.d/session.rules
echo '-w /var/log/wtmp -p wa -k logins' >> /etc/audit/rules.d/session.rules
echo '-w /var/log/btmp -p wa -k logins' >> /etc/audit/rules.d/session.rules

touch /etc/audit/rules.d/perm_mod.rules
echo '-a always,exit -F arch=b64 -S chmod -S fchmod -S fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_mod' > /etc/audit/rules.d/perm_mod.rules
echo '-a always,exit -F arch=b32 -S chmod -S fchmod -S fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_mod' >> /etc/audit/rules.d/perm_mod.rules
echo '-a always,exit -F arch=b64 -S chown -S fchown -S fchownat -S lchown -F auid>=1000 -F auid!=4294967295 -k perm_mod' >> /etc/audit/rules.d/perm_mod.rules
echo '-a always,exit -F arch=b32 -S chown -S fchown -S fchownat -S lchown -F auid>=1000 -F auid!=4294967295 -k perm_mod' >> /etc/audit/rules.d/perm_mod.rules 
echo '-a always,exit -F arch=b64 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=1000 -F auid!=4294967295 -k perm_mod' >> /etc/audit/rules.d/perm_mod.rules
echo '-a always,exit -F arch=b32 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=1000 -F auid!=4294967295 -k perm_mod' >> /etc/audit/rules.d/perm_mod.rules

touch /etc/audit/rules.d/mounts.rules
echo '-a always,exit -F arch=b64 -S mount -F auid>=1000 -F auid!=4294967295 -k mounts' > /etc/audit/rules.d/mounts.rules
echo '-a always,exit -F arch=b32 -S mount -F auid>=1000 -F auid!=4294967295 -k mounts' >> /etc/audit/rules.d/mounts.rules

touch /etc/audit/rules.d/delete.rules
echo '-a always,exit -F arch=b64 -S unlink -S unlinkat -S rename -S renameat -F auid>=1000 -F auid!=4294967295 -k delete' > /etc/audit/rules.d/delete.rules
echo '-a always,exit -F arch=b32 -S unlink -S unlinkat -S rename -S renameat -F auid>=1000 -F auid!=4294967295 -k delete' >> /etc/audit/rules.d/delete.rules

touch /etc/audit/rules.d/scope.rules
echo '-w /etc/sudoers -p wa -k scope' > /etc/audit/rules.d/scope.rules
echo '-w /etc/sudoers.d/ -p wa -k scope' >> /etc/audit/rules.d/scope.rules 

touch /etc/audit/rules.d/actions.rules
echo '-w /var/log/sudo.log -p wa -k actions' > /etc/audit/rules.d/actions.rules

touch /etc/audit/rules.d/modules.rules
echo '-w /sbin/insmod -p x -k modules' > /etc/audit/rules.d/modules.rules
echo '-w /sbin/rmmod -p x -k modules' >> /etc/audit/rules.d/modules.rules
echo '-w /sbin/modprobe -p x -k modules' >> /etc/audit/rules.d/modules.rules
echo '-a always,exit -F arch=b64 -S init_module -S delete_module -k modules' >> /etc/audit/rules.d/modules.rules 

if $(grep "^\s*[^#]" /etc/audit/audit.rules | tail -1) =  "-e 2"; then
	echo "hi"
else
	echo "hello"
fi