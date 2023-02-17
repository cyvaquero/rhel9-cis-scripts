#!/usr/bin/env bash

# 4.1.3.20 Ensure the audit configuration is immutable
# Filename: 4-1-3-20_audit.sh

echo "On disk configuration:"
grep -Ph -- '^\h*-e\h+2\b' /etc/audit/rules.d/*.rules | tail -1
