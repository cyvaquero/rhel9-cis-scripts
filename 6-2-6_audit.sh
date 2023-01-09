#!/usr/bin/env bash

# 6.2.6 Ensure no duplicate user names exist
# Filename: 6-2-6_audit.sh

cut -d: -f1 /etc/passwd | sort | uniq -d | while read -r x; do
    echo "Duplicate login name $x in /etc/passwd"
done
