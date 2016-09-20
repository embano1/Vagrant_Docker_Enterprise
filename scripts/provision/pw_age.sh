#!/usr/bin/env bash

set -e

# Disable password expiry warning for user vagrant and root
echo "Disabling password expiry for users"
sudo chage -m 0 -M 99999 -I -1 -E -1 vagrant > /dev/null
sudo chage -m 0 -M 99999 -I -1 -E -1 root > /dev/null
