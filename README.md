Note: Sistemare tabella VLAN.Modificare testo codice TEST

# DNCS-LAB (2018-2019)
Design of Networks and Communication Systems
Mattia Ferrari
## Assigment
Based the Vagrantfile and the provisioning scripts available at: https://github.com/dustnic/dncs-lab the candidate is required to design a functioning network where any host configured and attached to router-1 (through switch ) can browse a website hosted on host-2-c.

The subnetting needs to be designed to accommodate the following requirement (no need to create more hosts than the one described in the vagrantfile):
  - Up to 130 hosts in the same subnet of host-1-a
  - Up to 25 hosts in the same subnet of host-1-b
  - Consume as few IP addresses as possible
## Network map
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
        |  A  |                eth1.1|eth1.2                     |eth1
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
        | |                              |eth0                   |
        | |                              |                       |
        | +------------------------------+                       |
        |                                                        |
        |                                                        |
        +--------------------------------------------------------+



```

## Network description and configuration
----
### Subnet A:
In the subnet A we can find `router-1`,`switch` and `host-1-a` and other 128 hosts.
For the configuration of adress I use /24 beacuase is the first that can adresses more than 132 device.
##### IP
- Subnet ID: 163.10.0.0/24
- Broadcast : 163.10.0.255
- Router-1: 163.10.0.254
- Host-1-a: 163.10.0.1
- Other host interval: 163.10.0.2-163.10.0.129
- NetMask: 255.255.255.0
### Subnet B:
In the subnet A we can find `router-1`,`switch` and `host-1-b`.
In the same way I used /30 for the adresses of this subnet.
##### IP
- Subnet ID: 163.10.1.0/30
- Broadcast : 163.10.1.31
- Router-1: 163.10.0.30
- Host-1-b: 163.10.1.1
- Other host interval: 163.10.1.2-163.10.26
- NetMask: 255.255.255.224
### VLAN
Because between router-1 and switch there is only one psysical link I split this in two VLANs. One to connect `router-1` to `host-1-a` and one to connect `router-1` to `host-1-b`.
| ID | Subnet |  
| -- |:-----: | 
| 1  | A      | 
| 2  | B      |   
### Subnet C:
In the subnet A we can find only `router-1` and `router-2` so we need only 4 address.
##### IP
- Subnet ID: 163.10.2.0/32
- Broadcast : 163.10.2.3
- Router-1: 163.10.2.1
- Router-2: 163.10.2.2
- NetMask: 255.255.255.252
### Subnet D:
In the subnet A we can find only `router-2` and `host-2-c`so like Subnet C we need only 4 address.
##### IP
- Subnet ID: 163.10.3.0/32
- Broadcast : 163.10.3.3
- Router-1: 163.10.3.1
- Router-2: 163.10.3.2
- NetMask: 255.255.255.252
## Vagrantfile and devices configuration
### router-1
Ho modificato il file router-1.sh così:
First of all I connected the `router-1` to the `switch` with this line:
```
ip link set dev eth1 up
```
then I created the VLAN's splittando la porta eth1 in eth1.1 and eth1.2
```
ip link add link eth1 name eth1.1 type vlan id 1
ip link add link eth1 name eth1.2 type vlan id 2
```
at the end I added the adress at the two virtual port and switch them on

```
ip add add 163.10.0.254/24 dev eth1.1
ip add add 163.10.1.31/30 dev eth1.2
ip link set eth1.1 up
ip link set eth1.2 up
```
### host-1-a
I created host-1-a.sh file and I added it these line of common.sh file:
```
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y tcpdump --assume-yes
```
Next I created port eth1 in the host and I assigned the address.
```
ip link set dev eth1 up
ip add add 163.10.0.1 dev eth1
```
At the end I add a static route to router-1 for to add the route that a packet has to do
ip replace 163.168.X.X/XX via 163.168.10.254

### host-1-b 
the setup of host-1-b è duale a quella dell' host-1-a perciò riporto solo le righe di codice:
.......
### switch
In switch.sh with the following lines, i created a bridge and add the interfaces to:
- eth1
- eth2 (access port for VLAN1)
- eth3 (access port for VLAN2)
I used the ovs-vsctl program implemented by Open vSwitch
```
ovs-vsctl add-br switch
ovs-vsctl add-port switch eth1
ovs-vsctl add-port switch eth2 tag=170
ovs-vsctl add-port switch eth3 tag=171
```
At the end I switch on the port created in the previus lines
```
ip link set dev eth1 up
ip link set dev eth2 up
ip link set dev eth3 up
ip link set ovs-system up
```

### router-2
### host-2-c

## Test
----------
To test rechability, i ping any host from the another, for example to ping host-1-a from host-1-b:
```
~/dncs-lab$ vagrant ssh host-1-b
vagrant@host-1-a:~$ ping 163.10.0.1
```




