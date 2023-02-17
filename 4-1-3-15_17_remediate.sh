#!/usr/bin/env bash

# 4.1.3.15 Ensure successful and unsuccessful attempts to use the chcon command are recorded
# 4.1.3.16 Ensure successful and unsuccessful attempts to use the setfacl command are recorded
# 4.1.3.17 Ensure successful and unsuccessful attempts to use the chacl command are recorded
# Filename: 4-1-3-15_17_remediate.sh

{
    UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)
    [ -n "${UID_MIN}" ] && printf "
## 4.1.3.15 Ensure successful and unsuccessful attempts to use the chcon command are recorded
-a always,exit -F path=/usr/bin/chcon -F perm=x -F auid>=${UID_MIN} -F auid!=unset -k perm_chng
" > /etc/audit/rules.d/50-perm_chng.rules || printf "ERROR: Variable 'UID_MIN' is unset.\n"
}
{
    UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)
    [ -n "${UID_MIN}" ] && printf "
# # 4.1.3.16 Ensure successful and unsuccessful attempts to use the setfacl command are recorded
-a always,exit -F path=/usr/bin/setfacl -F perm=x -F auid>=${UID_MIN} -F auid!=unset -k perm_chng
" >> /etc/audit/rules.d/50-perm_chng.rules || printf "ERROR: Variable 'UID_MIN' is unset.\n"
}
{
    UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)
    [ -n "${UID_MIN}" ] && printf "
## 4.1.3.17 Ensure successful and unsuccessful attempts to use the chacl command are recorded
-a always,exit -F path=/usr/bin/chacl -F perm=x -F auid>=${UID_MIN} -F auid!=unset -k perm_chng
" >> /etc/audit/rules.d/50-perm_chng.rules || printf "ERROR: Variable 'UID_MIN' is unset.\n"
}

augenrules --load

if [[ $(auditctl -s | grep "enabled") =~ "2" ]]; then
    printf "Reboot required to load rules\n"
fi
