#!/usr/bin/env bash

# 4.1.3.18 Ensure successful and unsuccessful attempts to use the usermod command are recorded
# Filename: 4-1-3-18_remediate.sh

{
    UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)
    [ -n "${UID_MIN}" ] && printf "
#4.1.3.18 Ensure successful and unsuccessful attempts to use the usermod command are recorded
-a always,exit -F path=/usr/sbin/usermod -F perm=x -F auid>=${UID_MIN} -F auid!=unset -k usermod
" > /etc/audit/rules.d/50-usermod.rules || printf "ERROR: Variable 'UID_MIN' is unset.\n"
}

augenrules --load

if [[ $(auditctl -s | grep "enabled") =~ "2" ]]; then
    printf "Reboot required to load rules\n"
fi
