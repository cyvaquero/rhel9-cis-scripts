#!/usr/bin/env bash

# 1.2.1 Ensure GPG keys are configured
# Filename: 1-2-1_list-installed-by-file.sh

for PACKAGE in $(find /etc/pki/rpm-gpg/ -type f -exec rpm -qf {} \; | sort -u); do
    rpm -q --queryformat "%{NAME}-%{VERSION} %{PACKAGER} %{SUMMARY}\\n" "${PACKAGE}"; done