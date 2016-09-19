#!/usr/bin/env bash

set -e

# Adding nodes to /etc/host
echo "Adding nodes to /etc/hosts file"
sudo bash -c 'cat << EOF >> /etc/hosts
# Added by vagrant provisioning script
192.168.33.101   manager.local
192.168.33.102   worker-1.local
192.168.33.103   worker-2.local
# End vagrant provisioning script
EOF'
