#!/usr/bin/env bash

# 4.1.3.19 Ensure kernel module loading unloading and modification is collected
# Filename: 4-1-3-19_remediate.sh

[ -f /etc/audit/rules.d/modules.rules ] && rm /etc/audit/rules.d/modules.rules
{
    UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)
    [ -n "${UID_MIN}" ] && printf "
## 4.1.3.19 Ensure kernel module loading unloading and modification is collected
-a always,exit -F arch=b64 -S init_module,finit_module,delete_module,create_module,query_module -F auid>=${UID_MIN} -F auid!=unset -k kernel_modules
-a always,exit -F path=/usr/bin/kmod -F perm=x -F auid>=${UID_MIN} -F auid!=unset -k kernel_modules
" > /etc/audit/rules.d/50-kernel_modules.rules || printf "ERROR: Variable 'UID_MIN' is unset.\n"
}

augenrules --load

if [[ $(auditctl -s | grep "enabled") =~ "2" ]]; then
    printf "Reboot required to load rules\n"
fi
