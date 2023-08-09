#!/usr/bin/env bash

# 4.1.3.4 Ensure events that modify date and time information are collected
# Filename: 4-1-3-4_remediate.sh

[ -f /etc/audit/rules.d/audit_time_rules.rules ] && rm /etc/audit/rules.d/audit_time_rules.rules
[ -f /etc/audit/rules.d/time-change.rules ] && rm /etc/audit/rules.d/time-change.rules
printf "
## 4.1.3.4 Ensure events that modify date and time information are collected
-a always,exit -F arch=b64 -S adjtimex,settimeofday,clock_settime -k time-change
-a always,exit -F arch=b32 -S adjtimex,settimeofday,clock_settime -k time-change
-w /etc/localtime -p wa -k time-change
" > /etc/audit/rules.d/50-time-change.rules

augenrules --load

if [[ $(auditctl -s | grep "enabled") =~ "2" ]]; then
    printf "Reboot required to load rules\n"
fi