# DNCS-LAB

This repository contains the Vagrant files required to run the virtual lab environment used in the DNCS course.
```


        +-----------------------------------------------------+
        |                                                     |
        |                                                     |eth0
        +--+--+                +------------+             +------------+
        |     |                |            |             |            |
        |     |            eth0|            |eth2     eth2|            |
        |     +----------------+  router-1  +-------------+  router-2  |
        |     |                |            |             |            |
        |     |                |            |             |            |
        |  M  |                +------------+             +------------+
        |  A  |                      |eth1                       |eth1
        |  N  |                      |                           |
        |  A  |                      |                           |
        |  G  |                      |                     +-----+----+
        |  E  |                      |eth1                 |          |
        |  M  |            +-------------------+           |          |
        |  E  |        eth0|                   |           | host-2-c |
        |  N  +------------+      SWITCH       |           |          |
        |  T  |            |                   |           |          |
        |     |            +-------------------+           +----------+
        |  V  |               |eth2         |eth3                |eth0
        |  A  |               |             |                    |
        |  G  |               |             |                    |
        |  R  |               |eth1         |eth1                |
        |  A  |        +----------+     +----------+             |
        |  N  |        |          |     |          |             |
        |  T  |    eth0|          |     |          |             |
        |     +--------+ host-1-a |     | host-1-b |             |
        |     |        |          |     |          |             |
        |     |        |          |     |          |             |
        ++-+--+        +----------+     +----------+             |
        | |                              |eth0                  |
        | |                              |                      |
        | +------------------------------+                      |
        |                                                       |
        |                                                       |
        +-------------------------------------------------------+



```

# Requirements
 - 10GB disk storage
 - 2GB free RAM
 - Virtualbox
 - Vagrant (https://www.vagrantup.com)
 - Internet

# How-to
 - Install Virtualbox and Vagrant
 - Clone this repository
`git clone https://github.com/dustnic/dncs-lab`
 - You should be able to launch the lab from within the cloned repo folder.
```
cd dncs-lab
[~/dncs-lab] vagrant up
```
Once you launch the vagrant script, it may take a while for the entire topology to become available.
 - Verify the status of the 4 VMs
 ```
 [dncs-lab]$ vagrant status                                                                                                                                                                
Current machine states:

router                    running (virtualbox)
switch                    running (virtualbox)
host-a                    running (virtualbox)
host-b                    running (virtualbox)
```
- Once all the VMs are running verify you can log into all of them:
`vagrant ssh router`
`vagrant ssh switch`
`vagrant ssh host-a`
`vagrant ssh host-b`
# Network configuration
4 Subnet:

*A(host-1-a,router-1 and other 128 host): 
	Subnet ID: 192.168.1.0/24
	Host-1-a: 192.168.1.254	
	Router-1: 192.168.1.1
	Netmask: 255.255.255.0

*B(host-1-b,router-1 and other 23 host):    
	Subnet ID: 192.168.2.0/27
	Host-1-b: 192.168.2.30	
	Router-1: 192.168.2.1
	Netmask: 255.255.255.224
*C(router-1 and router-2):    
	Subnet ID: 192.168.3.0/30
	router-1: 192.168.3.1	
	Router-2: 192.168.3.2
	Netmask: 255.255.255.252

*D(host-2-c and router-2):	
	Subnet ID: 192.168.4.0/30
	host-2-c: 192.168.4.2	
	router-2: 192.168.4.1
	Netmask: 255.255.255.252
------
dato che fra router-1 e switch 1 c' è solo una connessione devo usare per forza di cose due VLAN.
VLAN Subnet A -> ID 1
VLAN Subnet B -> ID 2
# Virtual machines configuration
Ho modificato il Vagrantfile in modo tale da configurare tutte le virtual machines necessarie con le loro interfacce e 
assegnando ad ogni elemente della rete un proprio file .sh
router-1:
 config.vm.define "router-1" do |router1|
    router1.vm.box = "minimal/trusty64"
    router1.vm.hostname = "router-1"
    router1.vm.network "private_network", virtualbox__intnet: "router1-switch", auto_config: false
    router1.vm.network "private_network", virtualbox__intnet: "router1-router2", auto_config: false
    router1.vm.provision "shell", path: "router1.sh"
  end

router-2:
config.vm.define "router-2" do |router2|
    router2.vm.box = "minimal/trusty64"
    router2.vm.hostname = "router-2"
    router2.vm.network "private_network", virtualbox__intnet: "router-2-host-2-c", auto_config: false
    router2.vm.network "private_network", virtualbox__intnet: "router-1-router-2", auto_config: false
    router2.vm.provision "shell", path: "router2.sh"
  end

switch:
 config.vm.define "switch" do |switch|
    switch.vm.box = "minimal/trusty64"
    switch.vm.hostname = "switch"
    switch.vm.network "private_network", virtualbox__intnet: "router-1-switch", auto_config: false
    switch.vm.network "private_network", virtualbox__intnet: "switch-host-1-a", auto_config: false
    switch.vm.network "private_network", virtualbox__intnet: "switch-host-1-b", auto_config: false
    switch.vm.provision "shell", path: "switch.sh"
  end
    
host-1-a:
config.vm.define "host-1-a" do |hosta|
    hosta.vm.box = "minimal/trusty64"
    hosta.vm.hostname = "host-1-a"
    hosta.vm.network "private_network", virtualbox__intnet: "switch-host-1-a", auto_config: false
    hosta.vm.provision "shell", path: "host-1-a.sh"
  end
host-1-b:
config.vm.define "host-1-b" do |hostb|
    hostb.vm.box = "minimal/trusty64"
    hostb.vm.hostname = "host-1-b"
    hostb.vm.network "private_network", virtualbox__intnet: "switch-host-1-b", auto_config: false
    hostb.vm.provision "shell", path: "host-1-b.sh"
  end
host-2-c:
config.vm.define "host-2-c" do |hostc|
    hostc.vm.box = "minimal/trusty64"
    hostc.vm.hostname = "host-2-c"
    hostc.vm.network "private_network", virtualbox__intnet: "router-2-host-2-c", auto_config: false
    hostc.vm.provision "shell", path: "host-2-c.sh"
  end
# Collegamenti

