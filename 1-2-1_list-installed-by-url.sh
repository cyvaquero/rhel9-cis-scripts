#!/usr/bin/env bash

# 1.2.1 Ensure GPG keys are configured
# Filename: 1-2-1_list-installed-by-url.sh

for RPM_PACKAGE in $(rpm -q gpg-pubkey); do
    echo "RPM: ${RPM_PACKAGE}"
    RPM_SUMMARY=$(rpm -q --queryformat "%{SUMMARY}" "${RPM_PACKAGE}")
    RPM_PACKAGER=$(rpm -q --queryformat "%{PACKAGER}" "${RPM_PACKAGE}")
#TODO: Troubleshoot the following line to fix output.
    RPM_DATE=$(date +%Y-%m-%d -d "1970-1-1+$((0x$(rpm -q --queryformat"%{RELEASE}" "${RPM_PACKAGE}") ))sec")
    RPM_KEY_ID=$(rpm -q --queryformat "%{VERSION}" "${RPM_PACKAGE}")
    echo "Packager: ${RPM_PACKAGER}
    Summary: ${RPM_SUMMARY}
    Creation date: ${RPM_DATE}
    Key ID: ${RPM_KEY_ID}
    "
done
