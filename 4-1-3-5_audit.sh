#!/usr/bin/env bash

# 4.1.3.5 Ensure events that modify the system's network environment are collected
# Filename: 4-1-3-5_audit.sh

echo "On disk configuration:"
{
    awk '/^ *-a *always,exit/ \
    &&/ -F *arch=b(32|64)/ \
    &&/ -S/ \
    &&(/sethostname/ \
        ||/setdomainname/) \
    &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules
    awk '/^ *-w/ \
    &&(/\/etc\/issue/ \
        ||/\/etc\/issue.net/ \
        ||/\/etc\/hosts/ \
        ||/\/etc\/sysconfig\/network/) \
    &&/ +-p *wa/ \
    &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules
}
echo "Running configuration:"
{
    auditctl -l | awk '/^ *-a *always,exit/ \
    &&/ -F *arch=b(32|64)/ \
    &&/ -S/ \
    &&(/sethostname/ \
        ||/setdomainname/) \
    &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)'
    auditctl -l | awk '/^ *-w/ \
    &&(/\/etc\/issue/ \
        ||/\/etc\/issue.net/ \
        ||/\/etc\/hosts/ \
        ||/\/etc\/sysconfig\/network/) \
    &&/ +-p *wa/ \
    &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)'
}