# -*- mode: ruby -*-
# vi: set ft=ruby :

# https://www.theforeman.org/manuals/1.22/quickstart_guide.html

Vagrant.configure("2") do |config|
  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = "4096"
    vb.cpus = 2
  end

  # config.vm.define "foremansrv01" do |webtier|
  #   webtier.vm.box = "bento/scientific-7.6"
  #   # webtier.vm.box = "bento/centos-7.6" # OK
  #   webtier.vm.hostname = "foremansrv01"
  #   webtier.vm.network "private_network", ip: "192.168.45.20"
  #   webtier.vm.network "forwarded_port", guest: 8443, host: 8443
  #   webtier.vm.provider "virtualbox" do |vb|
  #       vb.name = "foremansrv01"
  #   end
  #   webtier.vm.provision "ansible_local" do |ansible|
  #   ansible.playbook = "deploy.yml"
  #   ansible.become = true
  #   ansible.compatibility_mode = "2.0"
  #   ansible.version = "2.9.7"
  #   end
  #   webtier.vm.provision "shell", inline: <<-SHELL
  #   sudo yum -y install https://yum.puppet.com/puppet6-release-el-7.noarch.rpm
  #   sudo yum -y install http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
  #   sudo yum -y install https://yum.theforeman.org/releases/2.0/el7/x86_64/foreman-release.rpm
  #   sudo yum -y install foreman-release-scl
  #   sudo yum -y install foreman-installer
  #   sudo foreman-installer
  #   # yum -y install https://yum.puppet.com/puppet6-release-el-7.noarch.rpm
  #   # yum -y install http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
  #   # yum -y install https://yum.theforeman.org/releases/1.22/el7/x86_64/foreman-release.rpm
  #   # yum -y install foreman-installer
  #   # foreman-installer
  #   # echo "foremansrv01 up && browse https://192.168.45.20"
  #   SHELL
  # end

  config.vm.define "foremansrv01" do |webtier|
    # webtier.vm.box = "bento/scientific-7.6" # OK
    webtier.vm.box = "bento/centos-7.7" # OK
    webtier.vm.hostname = "foremansrv01"
    webtier.vm.network "private_network", ip: "192.168.43.192"
    webtier.vm.network "forwarded_port", guest: 8443, host: 8443
    webtier.vm.provider "virtualbox" do |vb|
        vb.name = "foremansrv01"
        vb.memory = "4096"
    end
    webtier.vm.provision "ansible_local" do |ansible|
    ansible.playbook = "deploy.yml"
    ansible.become = true
    ansible.compatibility_mode = "2.0"
    ansible.version = "2.9.7"
    end
    # webtier.vm.provision "shell", inline: <<-SHELL
    # sudo yum install -y https://yum.puppet.com/puppet6-release-el-7.noarch.rpm
    # sudo yum install -y http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm #Error: Nothing to do
    # sudo yum install -y https://yum.theforeman.org/releases/2.0/el7/x86_64/foreman-release.rpm
    # sudo yum install -y foreman-release-scl
    # sudo yum install -y foreman-installer
    # sudo foreman-installer
    # SHELL
  end

  # config.vm.define "client1" do |webtier|
  #   webtier.vm.box = "bento/centos-7.7" # OK
  #   webtier.vm.hostname = "client1"
  #   webtier.vm.network "private_network", ip: "192.168.43.11"
  #   webtier.vm.network "forwarded_port", guest: 8443, host: 8443
  #   webtier.vm.provider "virtualbox" do |vb|
  #       vb.name = "foremansrv01"
  #   end
  #   webtier.vm.provision "ansible_local" do |ansible|
  #   ansible.playbook = "deploy.yml"
  #   ansible.become = true
  #   ansible.compatibility_mode = "2.0"
  #   ansible.version = "2.9.7"
  #   end
  #   webtier.vm.provision "shell", inline: <<-SHELL
  #   echo "===================================================================================="
  #                         hostnamectl status
  #   echo "===================================================================================="
  #   echo "         \   ^__^                                                                  "
  #   echo "          \  (oo)\_______                                                          "
  #   echo "             (__)\       )\/\                                                      "
  #   echo "                 ||----w |                                                         "
  #   echo "                 ||     ||                                                         "
  #   SHELL
  # end
  #
  # config.vm.define "client2" do |webtier|
  #   webtier.vm.box = "bento/ubuntu-19.10"
  #   webtier.vm.hostname = "client2"
  #   webtier.vm.network "private_network", ip: "192.168.43.20"
  #   webtier.vm.network "forwarded_port", guest: 8443, host: 8443
  #   webtier.vm.provider "virtualbox" do |vb|
  #       vb.name = "foremansrv01"
  #   end
  #   webtier.vm.provision "ansible_local" do |ansible|
  #   ansible.playbook = "deploy.yml"
  #   ansible.become = true
  #   ansible.compatibility_mode = "2.0"
  #   ansible.version = "2.9.7"
  #   end
  #   webtier.vm.provision "shell", inline: <<-SHELL
  #   echo "===================================================================================="
  #                         hostnamectl status
  #   echo "===================================================================================="
  #   echo "         \   ^__^                                                                  "
  #   echo "          \  (oo)\_______                                                          "
  #   echo "             (__)\       )\/\                                                      "
  #   echo "                 ||----w |                                                         "
  #   echo "                 ||     ||                                                         "
  #   SHELL
  # end

end
