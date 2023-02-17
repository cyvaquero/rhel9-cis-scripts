#!/usr/bin/env bash

# 4.1.3.11 Ensure session initiation information is collected
# Filename: 4-1-3-11_audit.sh

echo "On disk configuration:"
awk '/^ *-w/ \
&&(/\/var\/run\/utmp/ \
    ||/\/var\/log\/wtmp/ \
    ||/\/var\/log\/btmp/) \
&&/ +-p *wa/ \
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules

echo "Running configuration:"
auditctl -l | awk '/^ *-w/ \
&&(/\/var\/run\/utmp/ \
    ||/\/var\/log\/wtmp/ \
    ||/\/var\/log\/btmp/) \
&&/ +-p *wa/ \
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)'