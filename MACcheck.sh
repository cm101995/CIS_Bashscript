#!/bin/bash
if dpkg -s apparmor apparmor-utils;then
        echo "apparmor is already installed"
else
        echo "apparmor is already not installed"
        echo "Installing apparmor"
        apt install apparmor apparmor-utils -y
fi

if grep "^\s*linux" /boot/grub/grub.cfg | grep -v "apparmor=1" | grep -v '/boot/memtest86+.bin'; then
        echo 'GRUB_CMDLINE_LINUX="apparmor=1 security=apparmor"' >> /etc/default/grub
        update-grub
else
        echo 'Apparmor is enabled at runtime'
fi

if grep "^\s*linux" /boot/grub/grub.cfg | grep -v "security=apparmor" | grep -v '/boot/memtest86+.bin'; then
        echo 'GRUB_CMDLINE_LINUX="apparmor=1 security=apparmor"' >> /etc/default/grub
        update-grub
else
        echo 'Apparmor is enabled at runtime'
fi
