#!/bin/bash
CISfile=/etc/modprobe.d/CIS.conf
if [[ $(modprobe -n -v cramfs | grep -v mtd) == *"install"* ]];
then
 echo "Mounting of cramfs is disabled and hence this is CIS compliant"
else
 echo "Mounting of cramfs is enabled and hence not CIS compliant"
 echo "Disabling cramfs mounting"
 echo "install cramfs /bin/true" >> $CISfile
fi
if [[ $(modprobe -n -v freevxfs | grep -v mtd) == *"install"* ]];
then
 echo "Mounting of freevxfs is disabled and hence this is CIS compliant"
else
 echo "Mounting of freevxfs is enabled and hence not CIS compliant"
 echo "Disabling freevxfs mounting"
 echo "install freevxfs /bin/true" >> $CISfile
fi
if [[ $(modprobe -n -v jffs2 | grep -v mtd) == *"install"* ]];
then
 echo "Mounting of jffs2 is disabled and hence this is CIS compliant"
else
 echo "Mounting of jffs2 is enabled and hence not CIS compliant"
 echo "Disabling jffs2 mounting"
 echo "install jffs2 /bin/true" >> $CISfile
fi
if [[ $(modprobe -n -v hfs | grep -v mtd) == *"install"* ]];
then
 echo "Mounting of hfs is disabled and hence this is CIS compliant"
else
 echo "Mounting of hfs is enabled and hence not CIS compliant"
 echo "Disabling hfs mounting"
 echo "install hfs /bin/true" >> $CISfile
fi
if [[ $(modprobe -n -v hfsplus | grep -v mtd) == *"install"* ]];
then
 echo "Mounting of hfsplus is disabled and hence this is CIS compliant"
else
 echo "Mounting of hfsplus is enabled and hence not CIS compliant"
 echo "Disabling hfsplus mounting"
 echo "install hfsplus /bin/true" >> $CISfile
fi
if [[ $(modprobe --showconfig | grep squashfs) == *"install"* ]];
then
 echo "Mounting of squashfs is disabled and hence this is CIS compliant"
else
 echo "Mounting of squashfs is enabled and hence not CIS compliant"
 echo "Disabling squashfs mounting"
 echo "install squashfs /bin/true" >> $CISfile
fi
if [[ $(modprobe -n -v udf | grep -v crc-itu-t) == *"install"* ]];
then
 echo "Mounting of udf is disabled and hence this is CIS compliant"
else
 echo "Mounting of udf is enabled and hence not CIS compliant"
 echo "Disabling udf mounting"
 echo "install udf /bin/true" >> $CISfile
fi
if [[ $(modprobe --showconfig | grep vfat) == *"install"* ]];
then
 echo "Mounting of vfat is disabled and hence this is CIS compliant"
else
 echo "Mounting of vfat is enabled and hence not CIS compliant"
 echo "Disabling vfat mounting"
 echo "install vfat /bin/true" >> $CISfile
fi