#!/usr/bin/env bash

# 4.1.3.14 Ensure events that modify the system's Mandatory Access Controls are collected
# Filename: 4-1-3-14_remediate.sh

[ -f /etc/audit/rules.d/MAC-policy.rules ] && rm /etc/audit/rules.d/MAC-policy.rules
printf "
## 4.1.3.14 Ensure events that modify the system's Mandatory Access Controls are collected
-w /etc/selinux -p wa -k MAC-policy
-w /usr/share/selinux -p wa -k MAC-policy
" > /etc/audit/rules.d/50-MAC-policy.rules

augenrules --load

if [[ $(auditctl -s | grep "enabled") =~ "2" ]]; then
    printf "Reboot required to load rules\n"
fi
