#!/usr/bin/env bash

# 5.1.9 Ensure at is restricted to authorized users
# Filename: 5-1-9_remediate.sh

{
    if rpm -q at >/dev/null; then
        [ -e /etc/at.deny ] && rm -f /etc/at.deny
        [ ! -e /etc/at.allow ] && touch /etc/at.allow
        chown root:root /etc/at.allow
        chmod u-x,go-rwx /etc/at.allow
    else
        echo "at is not installed on the system"
    fi
}