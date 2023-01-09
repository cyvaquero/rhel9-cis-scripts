#!/usr/bin/env bash

# 6.2.15 Ensure no local interactive user has .rhosts files
# Filename: 6-2-15_audit.sh

{
    output=""
    fname=".rhosts"
    valid_shells="^($( sed -rn '/^\//{s,/,\\\\/,g;p}' /etc/shells | paste -s - d '|' - ))$"
    awk -v pat="$valid_shells" -F: '$(NF) ~ pat { print $1 " " $(NF-1) }' /etc/passwd | (while read -r user home; do
        [ -f "$home/$fname" ] && output="$output\n - User \"$user\" file: \"$home/$fname\" exists"
    done
    if [ -z "$output" ]; then
        echo -e "\n-PASSED: - No local interactive users have \"$fname\" files in their home directory\n"
    else
        echo -e "\n- FAILED:\n$output\n"
    fi
    )
}
