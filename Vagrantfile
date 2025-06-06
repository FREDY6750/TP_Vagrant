# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "hashicorp/bionic64"

  # Load Balancer
  config.vm.define "lb" do |lb|
    lb.vm.network "private_network", ip: "192.168.56.10"
    lb.vm.provision "shell", path: "setup_lb.sh"
    lb.vm.provider "virtualbox" do |vb|
      vb.gui = true
    end
  end

  # Web Servers
  config.vm.define "web1" do |web1|
    web1.vm.network "private_network", ip: "192.168.56.11"
    web1.vm.provision "shell", path: "setup_web.sh"
    web1.vm.provider "virtualbox" do |vb|
      vb.gui = true
    end
  end

  config.vm.define "web2" do |web2|
    web2.vm.network "private_network", ip: "192.168.56.12"
    web2.vm.provision "shell", path: "setup_web.sh"
    web2.vm.provider "virtualbox" do |vb|
      vb.gui = true
    end
  end

  # Database Master
  config.vm.define "db-master" do |db_master|
    db_master.vm.network "private_network", ip: "192.168.56.20"
    db_master.vm.provision "shell", path: "setup_db_master.sh"
    db_master.vm.provider "virtualbox" do |vb|
      vb.gui = true
    end
  end

  # Database Slave
  config.vm.define "db-slave" do |db_slave|
    db_slave.vm.network "private_network", ip: "192.168.56.21"
    db_slave.vm.provision "shell", path: "setup_db_slave.sh"
    db_slave.vm.provider "virtualbox" do |vb|
      vb.gui = true
    end
  end

  # Monitoring
  config.vm.define "monitoring" do |monitoring|
    monitoring.vm.network "private_network", ip: "192.168.56.30"
    monitoring.vm.provision "shell", path: "setup_monitoring.sh"
    monitoring.vm.provider "virtualbox" do |vb|
      vb.gui = true
    end
  end

  # Client
  config.vm.define "client" do |client|
    client.vm.network "private_network", ip: "192.168.56.40"
    client.vm.provider "virtualbox" do |vb|
      vb.gui = true
    end
  end
end