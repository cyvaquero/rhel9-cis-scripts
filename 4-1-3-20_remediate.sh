#!/usr/bin/env bash

# 4.1.3.20 Ensure the audit configuration is immutable
# Filename: 4-1-3-20_remediate.sh

[ -f /etc/audit/rules.d/immutable.rules ] && rm /etc/audit/rules.d/immutable.rules
printf -- "
## 4.1.3.20 Ensure the audit configuration is immutable
-e 2" >> /etc/audit/rules.d/99-finalize.rules

augenrules --load

if [[ $(auditctl -s | grep "enabled") =~ "2" ]]; then
    printf "Reboot required to load rules\n"
fi
