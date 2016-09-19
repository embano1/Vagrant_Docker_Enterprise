# -*- mode: ruby -*-

# vi: set ft=ruby :

# REMOVE ???
# Check if script provisioning folder exists
#require File.expand_path(File.dirname(__FILE__) + '/scripts/provision/updates.sh')
#Vagrant.require_version '>= 1.8.2'
############

boxes = [
    {
        :name => "manager",
        :eth1 => "192.168.33.101",
        :mem => "2048",
        :cpu => "1"
    },
    {
        :name => "worker-1",
        :eth1 => "192.168.33.102",
        :mem => "1024",
        :cpu => "1"
    },
    {
        :name => "worker-2",
        :eth1 => "192.168.33.103",
        :mem => "1024",
        :cpu => "1"
    }
]

Vagrant.configure(2) do |config|

  config.vm.box = "vmware/photon"

  config.vm.provider "vmware_fusion" do |v, override|
    override.vm.box = "base"
  end

  # Turn off shared folders
  config.vm.synced_folder ".", "/vagrant", id: "vagrant-root", disabled: true

  boxes.each do |opts|

    default = if opts[:name] == "manager" then true else false end

    config.vm.define opts[:name], primary: default do |config|
      config.vm.hostname = opts[:name]

      config.vm.provider "virtualbox" do |v|
        v.customize ["modifyvm", :id, "--memory", opts[:mem]]
        v.customize ["modifyvm", :id, "--cpus", opts[:cpu]]
      end

      # Networking
      config.vm.network "private_network", ip: opts[:eth1]
      config.vm.network "forwarded_port", guest: 8282, host: 8282 if opts[:name] == "manager"

      #### Provisioning Scripts ####
      # Update packages
      #config.vm.provision "shell", path: "scripts/provision/updates.sh"
      
      # Fix a bug in 
      config.vm.provision "shell", path: "scripts/provision/fix_networkd-wait.sh"

      # Configure docker
      config.vm.provision "shell", path: "scripts/provision/docker.sh"
      
      # Configure /etc/hosts
      config.vm.provision "shell", path: "scripts/provision/hosts.sh"

      # Configure iptables
      config.vm.provision "shell", path: "scripts/provision/iptables.sh"

     #### Applications ####
     # Install required applications
     config.vm.provision "shell" do |arg|
       arg.path = "scripts/applications/containers.sh"
       arg.args = opts[:name]
     end

    end
  end

end
