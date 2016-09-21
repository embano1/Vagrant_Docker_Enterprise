#!/usr/bin/env bash

set -e

# Create defaults docker file
echo "Adding DOCKER_OPTS (/etc/default/docker)"
sudo cat <<EOF | sudo dd of=/etc/default/docker status=none
DOCKER_OPTS="--insecure-registry manager.local:80 -H unix:///var/run/docker.sock -H tcp://0.0.0.0:2375"
EOF

# Enable docker service
echo "Permanently enabling docker service"
sudo systemctl enable docker > /dev/null 2>&1
echo "Starting docker service"
sudo systemctl start docker
