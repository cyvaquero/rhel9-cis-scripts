#!/usr/bin/env bash

# 4.1.3.4 Ensure events that modify date and time information are collected
# Filename: 4-1-3-4_audit.sh

echo "On disk configuration:"
{
    awk '/^ *-a *always,exit/ \
    &&/ -F *arch=b[2346]{2}/ \
    &&/ -S/ \
    &&(/adjtimex/ \
        ||/settimeofday/ \
        ||/clock_settime/ ) \
    &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules
    awk '/^ *-w/ \
    &&/\/etc\/localtime/ \
    &&/ +-p *wa/ \
    &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules
}
echo "Running configuration:"
{
    auditctl -l | awk '/^ *-a *always,exit/ \
    &&/ -F *arch=b[2346]{2}/ \
    &&/ -S/ \
    &&(/adjtimex/ \
        ||/settimeofday/ \
        ||/clock_settime/ ) \
    &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)'
    auditctl -l | awk '/^ *-w/ \
    &&/\/etc\/localtime/ \
    &&/ +-p *wa/ \
    &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)'
}