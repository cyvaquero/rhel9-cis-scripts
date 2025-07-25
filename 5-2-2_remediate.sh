#!/usr/bin/env bash 

# 5.2.2 Ensure permissions on SSH private host key files are configured
# Filename: 5-2-2_remediate.sh

{ 
    l_skgn="ssh_keys" # Group designated to own openSSH keys 
    l_skgid="$(awk -F: '($1 == "'"$l_skgn"'"){print $3}' /etc/group)"
    [ -n "$l_skgid" ] && l_cga="$l_skgn" || l_cga="root"
    awk '{print}' <<< "$(find -L /etc/ssh -xdev -type f -exec stat -L -c "%n %#a %U %G %g" {} +)" | (while read -r l_file l_mode l_owner l_group l_gid; do
        if file "$l_file" | grep -Pq ':\h+OpenSSH\h+private\h+key\b'; then
            [ "$l_gid" = "$l_skgid" ] && l_pmask="0137" || l_pmask="0177"
            l_maxperm="$( printf '%o' $(( 0777 & ~$l_pmask )) )"
            if [ $(( $l_mode & $l_pmask )) -gt 0 ]; then
                echo -e " - File: \"$l_file\" is mode \"$l_mode\" changing to mode: \"$l_maxperm\""
                if [ -n "$l_skgid" ]; then
                    chmod u-x,g-wx,o-rwx "$l_file" else chmod u-x,go-rwx "$l_file"
                fi
            fi
            if [ "$l_owner" != "root" ]; then
                echo -e " - File: \"$l_file\" is owned by: \"$l_owner\" changing owner to \"root\"" chown root "$l_file"
            fi
            if [ "$l_group" != "root" ] && [ "$l_gid" != "$l_skgid" ]; then
                echo -e " - File: \"$l_file\" is owned by group \"$l_group\" should belong to group \"$l_cga\"" chgrp "$l_cga" "$l_file"
            fi
        fi
    done
    )
}