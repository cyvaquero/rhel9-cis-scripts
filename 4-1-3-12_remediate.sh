#!/usr/bin/env bash

# 4.1.3.12 Ensure login and logout events are collected
# Filename: 4-1-3-12_remediate.sh

printf "
# 4.1.3.12 Ensure login and logout events are collected
-w /var/log/lastlog -p wa -k logins
-w /var/run/faillock -p wa -k logins
" > /etc/audit/rules.d/50-login.rules

augenrules --load

if [[ $(auditctl -s | grep "enabled") =~ "2" ]]; then
    printf "Reboot required to load rules\n"
fi
