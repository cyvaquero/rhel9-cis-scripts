#!/usr/bin/env bash

# 6.2.5 Ensure no duplicate GIDs exist
# Filename: 6-2-5_audit.sh

cut -d: -f3 /etc/group | sort | uniq -d | while read x ; do
    echo "Duplicate GID ($x) in /etc/group"
done
