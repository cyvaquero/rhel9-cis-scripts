#!/usr/bin/env bash

# 6.2.3 Ensure all groups in /etc/passwd exist in /etc/group
# Filename: 6-2-3_audit.sh

for i in $(cut -s -d: -f4 /etc/passwd | sort -u ); do
    grep -q -P "^.*?:[^:]*:$i:" /etc/group
    if [ $? -ne 0 ]; then
        echo "Group $i is referenced by /etc/passwd but does not exist in /etc/group"
    fi
done