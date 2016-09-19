#!/usr/bin/env bash

set -e

# Configuring iptables policy
echo "Setting iptables policy (allow port 2375, allow all outgoing)"
sudo iptables -A INPUT -p tcp --dport 2375 -j ACCEPT
sudo iptables -P OUTPUT ACCEPT
