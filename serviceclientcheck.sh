#!/bin/bash
if dpkg -s nis;then
        echo "nis is installed"
        echo "Uninstalling"
        apt purge nis
else
        echo "nis not installed"
fi

if dpkg -s rsh-client;then
        echo "rsh-client is installed"
        echo "Uninstalling"
        apt remove rsh-client
else
        echo "ris-client not installed"
fi

if dpkg -s talk;then
        echo "talk client is installed"
        echo "Uninstalling"
        apt remove talk
else
        echo "talk client not installed"
fi

if dpkg -s telnet;then
        echo "telnet is installed"
        echo "Uninstalling"
        apt purge telnet
else
        echo "telnet not installed"
fi

if dpkg -s ldap-utils;then
        echo "ldap-utils is installed"
        echo "Uninstalling"
        apt purge ldap-utils
else
        echo "ldap utils is not installed"
fi
