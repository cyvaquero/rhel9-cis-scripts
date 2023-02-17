#!/usr/bin/env bash

# 4.1.3.3 Ensure events that modify the sudo log file are collected
# Filename: 4-1-3-3_remediate.sh

SUDO_LOG_FILE=$(grep -r logfile /etc/sudoers* | sed -e 's/.*logfile=//;s/,? .*//' -e 's/"//g')
[ -n "${SUDO_LOG_FILE}" ] && printf "
## 4.1.3.3 Ensure events that modify the sudo log file are collected
-w ${SUDO_LOG_FILE} -p wa -k sudo_log_file
" > /etc/audit/rules.d/50-sudo.rules || printf "ERROR: Variable 'SUDO_LOG_FILE_ESCAPED' is unset.\n"

augenrules --load

if [[ $(auditctl -s | grep "enabled") =~ "2" ]]; then
    printf "Reboot required to load rules\n"
fi