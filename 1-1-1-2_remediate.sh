#!/usr/bin/env bash

# 1.1.1.2 Ensure mounting of udf filesystems is disabled
# Filename: 1-1-1-2_remediate.sh

{
    l_mname="udf" # set module name
    # Check if the module exists on the system
    if [ -z "$(modprobe -n -v "$l_mname" 2>&1 | grep -Pi "\h*modprobe:\h+FATAL:\h+Module\h+$l_mname\h+not\h+found\h+in\h+directory")" ]; then
        # Remediate loadable
        l_loadable="$(modprobe -n -v "$l_mname")"
        [ "$(wc -l <<< "$l_loadable")" -gt "1" ] && l_loadable="$(grep -P "(^\h*install|\b$l_mname)\b" <<< "$l_loadable")"
        if ! grep -Pq -- '^\h*install \/bin\/(true|false)' <<< "$l_loadable"; then
            echo -e " - setting module: \"$l_mname\" to be not loadable"
            echo -e "install $l_mname /bin/false" >> /etc/modprobe.d/"$l_mname".conf
        fi
        # Remediate loaded
        if lsmod | grep "$l_mname" > /dev/null 2>&1; then
            echo -e " - unloading module \"$l_mname\""
            modprobe -r "$l_mname"
        fi
        # Remediate deny list
        if ! modprobe --showconfig | grep -Pq -- "^\h*blacklist\h+$l_mname\b"; then
            echo -e " - deny listing \"$l_mname\""
            echo -e "blacklist $l_mname" >> /etc/modprobe.d/"$l_mname".conf
        fi
    else
        echo -e " - Nothing to remediate\n - Module \"$l_mname\" doesn't exist on the system"
    fi
}