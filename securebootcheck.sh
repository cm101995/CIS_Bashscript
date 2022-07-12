#!/bin/bash
chown root:root /boot/grub/grub.cfg
chmod og-rwx /boot/grub/grub.cfg
echo 'Ci$f0rLIf3\nCi$f0rLIf3' | grub-mkpasswd-pbkdf2 | awk '/grub.pbkdf/{print$NF}'

echo 'cat <<EOF' >> /boot/grub/grub.cfg
echo 'set superusers="<username>"' >> /boot/grub/grub.cfg
echo 'password_pbkdf2 <username> <encrypted-password>' >> /boot/grub/grub.cfg
echo 'EOF' >> /boot/grub/grub.cfg
update-grub

if grep ^root:[*\!]: /etc/shadow;then
        echo "root password is not set"
        echo -e "helloroot\nhelloroot" | passwd root
else
        echo "root passwd is already set"
fi
