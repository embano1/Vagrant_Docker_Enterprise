#!/usr/bin/env bash

set -e

# Check for first argument (must be node name to map containers)
function check_first_arg {
	if [ -z $1 ]
	then
		echo "No node name given, exiting."
		exit 0
	fi
}

# Install VMware Admiral Container Management on manager node (https://vmware.github.io/admiral/)
function install_admiral {
	if [ $1 == "manager" ]
	then
		echo "Fetching VMware Admiral Container Image and starting container (ports 8282:8282)"
		docker pull vmware/admiral > /dev/null
		docker run -d -p 8282:8282 --name admiral vmware/admiral
		if [ $? -ne 0 ]; then
			echo "Something went wrong starting VMware Admiral, exiting"
			exit 1
		fi
	fi
}


check_first_arg $1
install_admiral $1

