#!/usr/bin/env bash

# 4.1.3.14 Ensure events that modify the system's Mandatory Access Controls are collected
# Filename: 4-1-3-14_audit.sh

echo "On disk configuration:"
awk '/^ *-w/ \
&&(/\/etc\/selinux/ \
    ||/\/usr\/share\/selinux/) \
&&/ +-p *wa/ \
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules

echo "Running configuration:"
auditctl -l | awk '/^ *-w/ \
&&(/\/etc\/selinux/ \
    ||/\/usr\/share\/selinux/) \
&&/ +-p *wa/ \
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)'