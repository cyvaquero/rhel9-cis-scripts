#!/usr/bin/env bash

# 4.1.3.12 Ensure login and logout events are collected
# Filename: 4-1-3-12_audit.sh

echo "On disk configuration:"
awk '/^ *-w/ \
&&(/\/var\/log\/lastlog/ \
    ||/\/var\/run\/faillock/) \
&&/ +-p *wa/ \
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules

echo "Running configuration:"
auditctl -l | awk '/^ *-w/ \
&&(/\/var\/log\/lastlog/ \
    ||/\/var\/run\/faillock/) \
&&/ +-p *wa/ \
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)'