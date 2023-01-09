#!/usr/bin/env bash

# 3.3.1 Ensure source routed packets are not accepted
# Filename: 3-3-1_audit-2.sh

{
    krp="" pafile="" fafile=""
    kpname="net.ipv4.conf.default.accept_source_route"
    kpvalue="0"
    searchloc="/run/sysctl.d/*.conf /etc/sysctl.d/*.conf /usr/local/lib/sysctl.d/*.conf /usr/lib/sysctl.d/*.conf /lib/sysctl.d/*.conf /etc/sysctl.conf"
    krp="$(sysctl "$kpname" | awk -F= '{print $2}' | xargs)"
    pafile="$(grep -Psl -- "^\h*$kpname\h*=\h*$kpvalue\b\h*(#.*)?$" $searchloc)"
    fafile="$(grep -s -- "^\s*$kpname" $searchloc | grep -Pv -- "\h*=\h*$kpvalue\b\h*" | awk -F: '{print $1}')"
    if [ "$krp" = "$kpvalue" ] && [ -n "$pafile" ] && [ -z "$fafile" ]; then
        echo -e "\nPASS:\n\"$kpname\" is set to \"$kpvalue\" in the running configuration and in \"$pafile\""
    else
        echo -e "\nFAIL: "
        [ "$krp" != "$kpvalue" ] && echo -e "\"$kpname\" is set to \"$krp\" in the running configuration\n"
        [ -n "$fafile" ] && echo -e "\n\"$kpname\" is set incorrectly in \"$fafile\""
        [ -z "$pafile" ] && echo -e "\n\"$kpname = $kpvalue\" is not set in a kernel parameter configuration file\n"
    fi
}