#!/usr/bin/env bash

# 4.1.3.1 Ensure changes to system administration scope (sudoers) is collected
# Filename: 4-1-3-1_remediate.sh

echo "On disk configuration:"
awk '/^ *-w/ \
&&/\/etc\/sudoers/ \
&&/ +-p *wa/ \
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules
echo "Running configuration:"
auditctl -l | awk '/^ *-w/ \
&&/\/etc\/sudoers/ \
&&/ +-p *wa/ \
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)'