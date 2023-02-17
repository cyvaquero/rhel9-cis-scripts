#!/usr/bin/env bash

# 4.1.3.8 Ensure events that modify user/group information are collected
# Filename: 4-1-3-8_remediate.sh

[ -f /etc/audit/rules.d/audit_rules_usergroup_modification.rules ] && rm /etc/audit/rules.d/audit_rules_usergroup_modification.rules
printf "
## 4.1.3.8 Ensure events that modify user/group information are collected
-w /etc/group -p wa -k identity
-w /etc/passwd -p wa -k identity
-w /etc/gshadow -p wa -k identity
-w /etc/shadow -p wa -k identity
-w /etc/security/opasswd -p wa -k identity
" > /etc/audit/rules.d/50-identity.rules

augenrules --load

if [[ $(auditctl -s | grep "enabled") =~ "2" ]]; then
    printf "Reboot required to load rules\n"
fi
