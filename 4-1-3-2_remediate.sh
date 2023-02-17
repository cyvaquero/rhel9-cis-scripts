#!/usr/bin/env bash

# 4.1.3.2 Ensure actions as another user are always logged
# Filename: 4-1-3-2_remediate.sh

printf "
## 4.1.3.2 Ensure actions as another user are always logged
-a always,exit -F arch=b64 -C euid!=uid -F auid!=unset -S execve -k user_emulation
-a always,exit -F arch=b32 -C euid!=uid -F auid!=unset -S execve -k user_emulation
" > /etc/audit/rules.d/50-user_emulation.rules

augenrules --load

if [[ $(auditctl -s | grep "enabled") =~ "2" ]]; then
    printf "Reboot required to load rules\n"
fi