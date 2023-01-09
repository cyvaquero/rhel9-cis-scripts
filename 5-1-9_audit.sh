#!/usr/bin/env bash

# 5.1.9 Ensure at is restricted to authorized users
# Filename: 5-1-9_audit.sh

{
    if rpm -q at >/dev/null; then
        [ -e /etc/at.deny ] && echo "Fail: at.deny exists"
        if [ ! -e /etc/at.allow ]; then
            echo "Fail: at.allow doesn't exist"
        else
            ! stat -Lc "%a" /etc/at.allow | grep -Eq "[0,2,4,6]00" && echo "Fail: at.allow mode too permissive"
            ! stat -Lc "%u:%g" /etc/at.allow | grep -Eq "^0:0$" && echo "Fail: at.allow owner and/or group not root"
        fi
        if [ ! -e /etc/at.deny ] && [ -e /etc/at.allow ] && stat -Lc "%a" /etc/at.allow | grep -Eq "[0,2,4,6]00" && stat -Lc "%u:%g" /etc/at.allow | grep -Eq "^0:0$"; then
            echo "Pass"
        fi
    else
        echo "Pass: at is not installed on the system"
    fi
}