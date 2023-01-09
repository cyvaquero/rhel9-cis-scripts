#!/usr/bin/env bash

# 5.1.8 Ensure cron is restricted to authorized users
# Filename: 5-1-8_remediate.sh

{
    if rpm -q cronie >/dev/null; then
        [ -e /etc/cron.deny ] && rm -f /etc/cron.deny
        [ ! -e /etc/cron.allow ] && touch /etc/cron.allow
        chown root:root /etc/cron.allow
        chmod u-x,go-rwx /etc/cron.allow
    else
        echo "cron is not installed on the system"
    fi
}