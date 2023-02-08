#!/usr/bin/env bash

# 4.1.3.1 Ensure changes to system administration scope (sudoers) is collected
# Filename: 4-1-3-1_remediate.sh

[ -f /etc/audit/rules.d/actions.rules ] && rm /etc/audit/rules.d/actions.rules
printf "
-w /etc/sudoers -p wa -k actions
-w /etc/sudoers.d -p wa -k actions
" > /etc/audit/rules.d/50-scope.rules

augenrules --load

if [[ $(auditctl -s | grep "enabled") =~ "2" ]]; then
    printf "Reboot required to load rules\n"
fi