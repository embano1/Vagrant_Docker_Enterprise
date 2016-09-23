#!/usr/bin/env bash

set -e

# Adding nodes to /etc/host
echo "Adding node ${2} to /etc/hosts file"
sudo echo "${1}  ${2}.local" >> /etc/hosts

