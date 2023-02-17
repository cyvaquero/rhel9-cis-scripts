#!/usr/bin/env bash

# 4.1.3.13 Ensure file deletion events by users are collected
# Filename: 4-1-3-13_audit.sh

echo "On disk configuration:"
{
    UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)
    [ -n "${UID_MIN}" ] && awk "/^ *-a *always,exit/ \
    &&/ -F *arch=b[2346]{2}/ \
    &&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) \
    &&/ -F *auid>=${UID_MIN}/ \
    &&/ -S/ \
    &&(/unlink/||/rename/||/unlinkat/||/renameat/) \
    &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)" /etc/audit/rules.d/*.rules \
    || printf "ERROR: Variable 'UID_MIN' is unset.\n"
}

echo "Running configuration:"
{
    UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)
    [ -n "${UID_MIN}" ] && auditctl -l | awk "/^ *-a *always,exit/ \
    &&/ -F *arch=b[2346]{2}/ \
    &&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) \
    &&/ -F *auid>=${UID_MIN}/ \
    &&/ -S/ \
    &&(/unlink/||/rename/||/unlinkat/||/renameat/) \
    &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)" \
    || printf "ERROR: Variable 'UID_MIN' is unset.\n"
}