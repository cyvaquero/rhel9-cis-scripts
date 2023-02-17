#!/usr/bin/env bash

# 4.1.3.9 Ensure discretionary access control permission modification events are collected
# Filename: 4-1-3-9_remediate.sh

[ -f /etc/audit/rules.d/perm_mod.rules ] && rm /etc/audit/rules.d/perm_mod.rules
{
UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)
[ -n "${UID_MIN}" ] && printf "
# 4.1.3.9 Ensure discretionary access control permission modification events are collected
-a always,exit -F arch=b64 -S chmod,fchmod,fchmodat -F auid>=${UID_MIN} -F auid!=unset -F key=perm_mod
-a always,exit -F arch=b64 -S chown,fchown,lchown,fchownat -F auid>=${UID_MIN} -F auid!=unset -F key=perm_mod
-a always,exit -F arch=b32 -S chmod,fchmod,fchmodat -F auid>=${UID_MIN} -F auid!=unset -F key=perm_mod
-a always,exit -F arch=b32 -S lchown,fchown,chown,fchownat -F auid>=${UID_MIN} -F auid!=unset -F key=perm_mod
-a always,exit -F arch=b64 -S setxattr,lsetxattr,fsetxattr,removexattr,lremovexattr,fremovexattr -F auid>=${UID_MIN} -F auid!=unset -F key=perm_mod
-a always,exit -F arch=b32 -S setxattr,lsetxattr,fsetxattr,removexattr,lremovexattr,fremovexattr -F auid>=${UID_MIN} -F auid!=unset -F key=perm_mod
" > /etc/audit/rules.d/50-perm_mod.rules || printf "ERROR: Variable 'UID_MIN' is unset.\n"
}

augenrules --load

if [[ $(auditctl -s | grep "enabled") =~ "2" ]]; then
    printf "Reboot required to load rules\n"
fi
