#!/usr/bin/env bash

# 4.1.3.5 Ensure events that modify the system's network environment are collected
# Filename: 4-1-3-5_audit.sh

[ -f /etc/audit/rules.d/audit_rules_networkconfig_modification.rules ] && rm /etc/audit/rules.d/audit_rules_networkconfig_modification.rules
printf "
-a always,exit -F arch=b64 -S sethostname,setdomainname -k system-locale
-a always,exit -F arch=b32 -S sethostname,setdomainname -k system-locale
-w /etc/issue -p wa -k system-locale
-w /etc/issue.net -p wa -k system-locale
-w /etc/hosts -p wa -k system-locale
-w /etc/sysconfig/network -p wa -k system-locale
-w /etc/sysconfig/network-scripts/ -p wa -k system-locale
" > /etc/audit/rules.d/50-system_local.rules

augenrules --load

if [[ $(auditctl -s | grep "enabled") =~ "2" ]]; then
    printf "Reboot required to load rules\n"
fi