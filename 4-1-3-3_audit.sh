#!/usr/bin/env bash

# 4.1.3.4 Ensure events that modify date and time information are collected
# Filename: 4-1-3-4_audit.sh

echo "On disk configuration:"
{
    SUDO_LOG_FILE_ESCAPED=$(grep -r logfile /etc/sudoers* | sed -e 's/.*logfile=//;s/,? .*//' -e 's/"//g' -e 's|/|\\/|g')
    [ -n "${SUDO_LOG_FILE_ESCAPED}" ] && awk "/^ *-w/ \
    &&/"${SUDO_LOG_FILE_ESCAPED}"/ \
    &&/ +-p *wa/ \
    &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)" /etc/audit/rules.d/*.rules \
    || printf "ERROR: Variable 'SUDO_LOG_FILE_ESCAPED' is unset.\n"
}
echo "Running configuration:"
{
    SUDO_LOG_FILE_ESCAPED=$(grep -r logfile /etc/sudoers* | sed -e 's/.*logfile=//;s/,? .*//' -e 's/"//g' -e 's|/|\\/|g')
    [ -n "${SUDO_LOG_FILE_ESCAPED}" ] && auditctl -l | awk "/^ *-w/ \
    &&/"${SUDO_LOG_FILE_ESCAPED}"/ \
    &&/ +-p *wa/ \
    &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)" \
    || printf "ERROR: Variable 'SUDO_LOG_FILE_ESCAPED' is unset.\n"
}