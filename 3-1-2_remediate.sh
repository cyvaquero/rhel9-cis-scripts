#!/usr/bin/env bash

# 3.1.2 Ensure wireless interfaces are disabled
# Filename: 3-1-2_remediate.sh

{
    module_fix()
    {
        if ! modprobe -n -v "$l_mname" | grep -P -- '^\h*install\/bin\/(true|false)'; then
            echo -e " - setting module: \"$l_mname\" to be un-loadable" echo -e "install $l_mname /bin/false" >>
/etc/modprobe.d/"$l_mname".conf
        fi
        if lsmod | grep "$l_mname" > /dev/null 2>&1; then
            echo -e " - unloading module \"$l_mname\""
            modprobe -r "$l_mname"
        fi
        if ! grep -Pq -- "^\h*blacklist\h+$l_mname\b" /etc/modprobe.d/*; then
            echo -e " - deny listing \"$l_mname\""
            echo -e "blacklist $l_mname" >> /etc/modprobe.d/"$l_mname".conf
        fi
    }
    if [ -n "$(find /sys/class/net/*/ -type d -name wireless)" ]; then
        l_dname=$(for driverdir in $(find /sys/class/net/*/ -type d -name wireless | xargs -0 dirname); do basename "$(readlink -f "$driverdir"/device/driver/module)";done | sort -u)
        for l_mname in $l_dname; do
            module_fix
        done
    fi
}