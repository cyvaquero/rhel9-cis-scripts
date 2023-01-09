#!/usr/bin/env bash

# 5.1.8 Ensure cron is restricted to authorized users
# Filename: 5-1-8_audit.sh

{
    if rpm -q cronie >/dev/null; then
        [ -e /etc/cron.deny ] && echo "Fail: cron.deny exists"
        if [ ! -e /etc/cron.allow ]; then
            echo "Fail: cron.allow doesn't exist"
        else
            ! stat -Lc "%a" /etc/cron.allow | grep -Eq "[0,2,4,6]00" && echo "Fail: cron.allow mode too permissive"
            ! stat -Lc "%u:%g" /etc/cron.allow | grep -Eq "^0:0$" && echo "Fail: cron.allow owner and/or group not root"
        fi
        if [ ! -e /etc/cron.deny ] && [ -e /etc/cron.allow ] && stat -Lc "%a" /etc/cron.allow | grep -Eq "[0,2,4,6]00" && stat -Lc "%u:%g" /etc/cron.allow | grep -Eq "^0:0$"; then
            echo "Pass"
        fi
    else
        echo "Pass: cron is not installed on the system"
    fi
}