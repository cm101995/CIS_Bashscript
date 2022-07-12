#!/bin/bash
STRING=$(apparmor_status | head -n 2 | tail -n 1)
STRING1=$(apparmor_status | head -n 3 | tail -n 1)
if [ $((${STRING:0:2}-${STRING1:0:2})) -eq 0 ]; then
	echo "All apparmor profiles are in enforcing"
else
	echo "Some profiles are not in enforcing"
	echo "Changing them to enforcing"
	aa-enforce /etc/apparmor.d/*
fi

