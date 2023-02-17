#!/usr/bin/env bash

# 4.1.3.11 Ensure session initiation information is collected
# Filename: 4-1-3-11_remediate.sh

[ -f /etc/audit/rules.d/session.rules ] && rm /etc/audit/rules.d/session.rules
printf "
# 4.1.3.11 Ensure session initiation information is collected
-w /var/run/utmp -p wa -k session
-w /var/log/wtmp -p wa -k session
-w /var/log/btmp -p wa -k session
" > /etc/audit/rules.d/50-session.rules

augenrules --load

if [[ $(auditctl -s | grep "enabled") =~ "2" ]]; then
    printf "Reboot required to load rules\n"
fi
