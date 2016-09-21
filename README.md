# Vagrantfile to set up a demo environment for an Enterprise (on-prem) Docker Environment

**1. About**
  * Vagrantfile and scripts to stand up a three node VMware PhotonOS deployment (manager, two workers) based on VMware PhotonOS, VMware Admiral (Container Host Management) and VMware Harbor (Docker Registry)

**2. Notes, Pre-Reqs and tested environment**
  * Tested on OSX 10.11.6, Vagrant 1.8.1 (see [issue w/ Vagrant > 1.8.1 #7808](https://github.com/mitchellh/vagrant/issues/7808), Virtualbox 5.0.26
  * Please see [Issues](https://github.com/embano1/Vagrant_Docker_Enterprise/issues) section for planned improvements and current issues
  * Depending on your connection, pulling images can take a while so be patient :)
  
**3. How to start**
  * git clone https://github.com/embano1/vagrant \<destination\> -b dev
  * cd \<destination\>
  * vagrant up

