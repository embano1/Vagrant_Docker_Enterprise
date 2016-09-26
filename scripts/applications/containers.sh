#!/usr/bin/env bash

set -e

# User defined variables
harbor_version="0.4.0"
docker_compose_version="1.8.0"

# Check for first argument (must be node name to map containers)
function check_first_arg {
	if [ -z $1 ]
	then
		echo "No node name given, exiting."
		exit 0
	fi
}

# Install VMware Admiral Container Management (https://vmware.github.io/admiral/)
function install_admiral {
	if [ $1 == "admiral" ]
	then
		echo "Fetching VMware Admiral Container Image and starting container (ports 8282:8282)"
		sudo docker pull vmware/admiral
		# TODO Fix static IP
		sudo docker run -d -p 8282:8282 --add-host="harbor.local:192.168.33.102" --name admiral vmware/admiral
		if [ $? -ne 0 ]; then
			echo "Something went wrong starting VMware Admiral, exiting"
			exit 1
		fi
	fi
}

# Install VMware Harbor Container Management (https://vmware.github.io/harbor/)
function install_harbor {
	if [ $1 == "harbor" ]
	then
		echo "Cleaning up and fetching VMware Harbor Release (version ${harbor_version})"
		sudo rm -rf /tmp/harbor*
		sudo curl -o /tmp/harbor.tar.gz -sL https://github.com/vmware/harbor/releases/download/${harbor_version}/harbor-online-installer-${harbor_version}.tgz
		if [ $? -ne 0 ]; then
			echo "Error retrieving file from the web"
			exit 1
		fi

		echo "We need tar, installing..."
		sudo tdnf install tar -y
		if [ $? -ne 0 ]; then
			echo "Could not install tar utility (tdnf), exiting."
			exit 1
		fi

		echo "We also need docker-compose, fetching ${docker_compose_version}"
		sudo curl -sL https://github.com/docker/compose/releases/download/${docker_compose_version}/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
		if [ $? -ne 0 ]; then
			echo "Could not install docker-compose, exiting."
			exit 1
		fi

		sudo chmod +x /usr/local/bin/docker-compose

		echo "Unpacking and configuring VMware Harbor"
		sudo mkdir /tmp/harbor && sudo tar -xzf /tmp/harbor.tar.gz -C /tmp/harbor --strip-components=1
                sudo sed -i "s/reg\.mydomain\.com/${1}.local/" /tmp/harbor/harbor.cfg
                cd /tmp/harbor; ./prepare;

		echo "Calling docker-compose up"
                sudo /usr/local/bin/docker-compose -f /tmp/harbor/docker-compose.yml up -d

		if [ $? -eq 0 ]; then
                        echo "Successfully started VMware Harbor..."
                fi
	fi
}

# Call functions
check_first_arg $1
install_admiral $1
install_harbor $1
