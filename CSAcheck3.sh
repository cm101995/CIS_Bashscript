#!/bin/bash
echo 'password required pam_pwhistory.so remember=5' >> /etc/pam.d/common-password
sed -i '/sha512/ c password [success=1 default=ignore] pam_unix.so sha512' /etc/pam.d/common-password
sed -i '/^PASS_MAX_DAYS/ c PASS_MAX_DAYS 365' /etc/login.defs 
chage --maxdays 365 ubuntu
sed -i '/^PASS_MIN_DAYS/ c PASS_MIN_DAYS 7' /etc/login.defs
chage --mindays 7 ubuntu
sed -i '/^PASS_WARN_AGE/ c PASS_WARN_AGE 7' /etc/login.defs
chage --warndays 7 ubuntu
useradd -D | grep INACTIVE
useradd -D -f 30
chage --inactive 30 ubuntu
chage --inactive 30 root
usermod -g 0 root
if  grep "umask" /etc/bash.bashrc; then
        echo 'umask is configured'
else
        echo 'configuring umask'
        echo 'umask 027' >> /etc/bash.bashrc
fi
if  grep "umask" /etc/profile /etc/profile.d/*.sh; then
        echo 'umask is configured'
else
        echo 'configuring umask'
        echo 'umask 027' >> /etc/profile.d/*.sh
        echo 'umask 027' >> /etc/profile
fi
if grep -E -i "^\s*(\S+\s+)*TMOUT=(900|[1-8][0-9][0-9]|[1-9][0-9]|[1-9])\s*(\S+\s*)*(\s+#.*)?$" /etc/bash.bashrc; then
        echo 'TMOUT is configured'
else
        echo 'configuring TMOUT'
        echo 'readonly TMOUT=900 ; export TMOUT' >> /etc/bash.bashrc 
fi
if grep -E -i "^\s*(\S+\s+)*TMOUT=(900|[1-8][0-9][0-9]|[1-9][0-9]|[1-9])\s*(\S+\s*)*(\s+#.*)?$" /etc/profile /etc/profile.d/*.sh; then
        echo 'TMOUT is configured'
else
        echo 'configuring TMOUT'
        echo 'readonly TMOUT=900 ; export TMOUT' >> /etc/profile.d/*.sh
        echo 'readonly TMOUT=900 ; export TMOUT' >> /etc/profile
fi
chown root:root /etc/passwd
chmod u-x,go-wx /etc/passwd
chown root:shadow /etc/gshadow-
chmod g-wx,o-rwx /etc/gshadow-
chmod o-rwx,g-wx /etc/shadow
chown root:shadow /etc/shadow
chown root:root /etc/group
chmod 644 /etc/group
chown root:root /etc/passwd-
chmod u-x,go-rwx /etc/passwd-
chown root:shadow /etc/shadow-
chmod u-x,go-rwx /etc/shadow-
chown root:root /etc/group-
chmod u-x,go-wx /etc/group-
chown root:shadow /etc/gshadow
chmod o-rwx,g-wx /etc/gshadow