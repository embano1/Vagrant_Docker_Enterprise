# -*- mode: ruby -*-

# vi: set ft=ruby :

# REMOVE ???
# Check if script provisioning folder exists
#require File.expand_path(File.dirname(__FILE__) + '/scripts/provision/updates.sh')
#Vagrant.require_version '>= 1.8.2'
############

#### Variables and options
# Box configuration
boxes = [
    {
        :name => "admiral",
        :eth1 => "192.168.33.101",
        :mem => "2048",
        :cpu => "1"
    },
    {
        :name => "harbor",
        :eth1 => "192.168.33.102",
        :mem => "1024",
        :cpu => "1"
    },
    {

        :name => "worker-1",
        :eth1 => "192.168.33.103",
        :mem => "512",
        :cpu => "1"
    },
    {
        :name => "worker-2",
        :eth1 => "192.168.33.104",
        :mem => "512",
        :cpu => "1"
    }
]

# Options
# ToDO implement toggle switches for some larger packages, e.g. harbor
#$harbor = "with_harbor"

####

Vagrant.configure(2) do |config|

  config.vm.box = "vmware/photon"

  config.vm.provider "vmware_fusion" do |v, override|
    override.vm.box = "base"
  end

  # Turn off shared folders
  config.vm.synced_folder ".", "/vagrant", id: "vagrant-root", disabled: true

  boxes.each do |opts|

    default = if opts[:name] == "admiral" then true else false end

    config.vm.define opts[:name], primary: default do |config|
      config.vm.hostname = opts[:name]

      config.vm.provider "virtualbox" do |v|
        v.customize ["modifyvm", :id, "--memory", opts[:mem]]
        v.customize ["modifyvm", :id, "--cpus", opts[:cpu]]
      end

      # Networking
      config.vm.network "private_network", ip: opts[:eth1]

      # Port forwardings (usually not needed due to second host-only interfaces which can be accessed from the vagrant host) 
      #config.vm.network "forwarded_port", guest: 8282, host: 8282 if opts[:name] == "admiral"
      #config.vm.network "forwarded_port", guest: 80, host: 8080 if opts[:name] == "harbor"

      #### Provisioning Scripts ####
      # Update packages
      # config.vm.provision "shell", path: "scripts/provision/updates.sh"
      
      # Fix a bug in 
      config.vm.provision "shell", path: "scripts/provision/fix_networkd-wait.sh"

      # Configure docker
      config.vm.provision "shell", path: "scripts/provision/docker.sh"
      
      # Configure /etc/hosts
      boxes.each do |opts|
        config.vm.provision "shell" do |arg|
          arg.path = "scripts/provision/hosts.sh"
          arg.args = opts[:eth1],opts[:name]
        end
      end

      # Configure iptables
      config.vm.provision "shell", path: "scripts/provision/iptables.sh"

      # Configure iptables
      config.vm.provision "shell", path: "scripts/provision/pw_age.sh"

     #### Applications ####
     # Install required applications
     config.vm.provision "shell" do |arg|
       arg.path = "scripts/applications/containers.sh"
       arg.args = opts[:name]
     end

    end
  end

end
