#!/usr/bin/env bash

# 6.2.7 Ensure no duplicate group names exist
# Filename: 6-2-7_audit.sh

cut -d: -f1 /etc/group | sort | uniq -d | while read -r x; do
    echo "Duplicate group name $x in /etc/group"
done
