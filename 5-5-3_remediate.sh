#!/usr/bin/env bash

# 5.5.3 Ensure password reuse is limited
# Filename: 5-5-3_remediate.sh

{
    file="/etc/authselect/$(head -1 /etc/authselect/authselect.conf | grep 'custom/')/system-auth"
    if ! grep -Pq -- '^\h*password\h+(requisite|required|sufficient)\h+pam_pwhistory\.so\h+([^#\n\ r]+\h+)?remember=([5-9]|[1-9][0-9]+)\b.*$' "$file"; then
        if grep -Pq -- '^\h*password\h+(requisite|required|sufficient)\h+pam_pwhistory\.so\h+([^#\n\ r]+\h+)?remember=\d+\b.*$' "$file"; then
            sed -ri 's/^\s*(password\s+(requisite|required|sufficient)\s+pam_pwhistory\.so\s+([^# \n\r]+\s+)?)(remember=\S+\s*)(\s+.*)?$/\1 remember=5 \5/' $file
        elif grep -Pq -- '^\h*password\h+(requisite|required|sufficient)\h+pam_pwhistory\.so\h+([^#\n\ r]+\h+)?.*$' "$file"; then
            sed -ri '/^\s*password\s+(requisite|required|sufficient)\s+pam_pwhistory\.so/ s/$/ remember=5/' $file
        else
            sed -ri '/^\s*password\s+(requisite|required|sufficient)\s+pam_unix\.so/i password required pam_pwhistory.so remember=5 use_authtok' $file
        fi
    fi
    if ! grep -Pq -- '^\h*password\h+(requisite|required|sufficient)\h+pam_unix\.so\h+([^#\n\r]+\h +)?remember=([5-9]|[1-9][0-9]+)\b.*$' "$file"; then
        if grep -Pq -- '^\h*password\h+(requisite|required|sufficient)\h+pam_unix\.so\h+([^#\n\r]+\h +)?remember=\d+\b.*$' "$file"; then
            sed -ri 's/^\s*(password\s+(requisite|required|sufficient)\s+pam_unix\.so\s+([^#\n\r] +\s+)?)(remember=\S+\s*)(\s+.*)?$/\1 remember=5 \5/' $file
        else
            sed -ri '/^\s*password\s+(requisite|required|sufficient)\s+pam_unix\.so/ s/$/ remember=5/' $file
        fi
    fi
    authselect apply-changes
}