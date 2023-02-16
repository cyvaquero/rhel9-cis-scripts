#!/usr/bin/env bash

# 4.1.3.8 Ensure events that modify user/group information are collected
# Filename: 4-1-3-8_audit.sh

echo "On disk configuration:"
{
    awk '/^ *-w/ \
    &&(/\/etc\/group/ \
        ||/\/etc\/passwd/ \
        ||/\/etc\/gshadow/ \
        ||/\/etc\/shadow/ \
        ||/\/etc\/security\/opasswd/) \
    &&/ +-p *wa/ \
    &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules
}
echo "Running configuration:"
{
    auditctl -l | awk '/^ *-w/ \
    &&(/\/etc\/group/ \
        ||/\/etc\/passwd/ \
        ||/\/etc\/gshadow/ \
        ||/\/etc\/shadow/ \
        ||/\/etc\/security\/opasswd/) \
    &&/ +-p *wa/ \
    &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)'
}
