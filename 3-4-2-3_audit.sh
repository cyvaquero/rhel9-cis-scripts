#!/usr/bin/env bash

# 3.4.2.3 Ensure host based firewall loopback 
# Filename: 3-4-2-3_audit.sh

{
echo "nft list ruleset | grep 'hook input'"
nft list ruleset | grep 'hook input'
echo "nft list ruleset | grep 'hook forward'"
nft list ruleset | grep 'hook forward'
echo "nft list ruleset | grep 'hook output'"
nft list ruleset | grep 'hook output'
}
