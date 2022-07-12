#!/bin/bash
STRING=$(apparmor_status | grep unconfine)
echo "$STRING"
if [[ "$STRING" =~ ^[0]* ]]; then
	echo "All the profiles are in either enforcing mode or complain mode"
else
	echo "Some profiles are running in unconfine mode"
	echo "Changing them to enforcing mode"
	aa-enforce /etc/apparmor.d/*
fi
