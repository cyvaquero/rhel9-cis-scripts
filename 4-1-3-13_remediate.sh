#!/usr/bin/env bash

# 4.1.3.13 Ensure file deletion events by users are collected
# Filename: 4-1-3-13_remediate.sh

[ -f /etc/audit/rules.d/delete.rules ] && rm /etc/audit/rules.d/delete.rules
{
    UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)
    [ -n "${UID_MIN}" ] && printf "
## 4.1.3.13 Ensure file deletion events by users are collected
-a always,exit -F arch=b64 -S rename,unlink,unlinkat,renameat -F auid>=${UID_MIN} -F auid!=unset -F key=delete
-a always,exit -F arch=b32 -S rename,unlink,unlinkat,renameat -F auid>=${UID_MIN} -F auid!=unset -F key=delete
" > /etc/audit/rules.d/50-delete.rules || printf "ERROR: Variable 'UID_MIN' is unset.\n"
}

augenrules --load

if [[ $(auditctl -s | grep "enabled") =~ "2" ]]; then
    printf "Reboot required to load rules\n"
fi
