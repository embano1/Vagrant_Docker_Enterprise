#!/usr/bin/env bash

set -e

# Fix systemd-networkd-wait-online time out and fail due to second interface (eth1)
echo "Fixing systemd-networkd-wait-online (just rely on eth0 to be up)"
sudo mkdir -p /etc/systemd/system/systemd-networkd-wait-online.service.d
sudo cat <<EOF | sudo dd of=/etc/systemd/system/systemd-networkd-wait-online.service.d/override.conf status=none
[Service]
ExecStart=
ExecStart=/lib/systemd/systemd-networkd-wait-online -i eth0
EOF

echo "Reloading systemd and restarting the service"
systemctl daemon-reload
systemctl restart systemd-networkd-wait-online
