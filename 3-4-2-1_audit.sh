#!/usr/bin/env bash

# 3.4.2.1 Ensure firewalld default zone is set
# Filename: 3-4-2-1_audit.sh

{
    l_output="" l_output2="" l_zone=""
    if systemctl is-enabled firewalld.service | grep -q 'enabled'; then
        l_zone="$(firewall-cmd --get-default-zone)"
        if [ -n "$l_zone" ]; then
            l_output=" - The default zone is set to: \"$l_zone\""
        else
            l_output2=" - The default zone is not set"
      fi
    else
        l_output=" - FirewallD is not in use on the system"
    fi
    if [ -z "$l_output2" ]; then
        echo -e "\n- Audit Results:\n ** Pass **\n$l_output\n"
    else
        echo -e "\n- Audit Results:\n ** Fail **\n$l_output2\n"
    fi
}