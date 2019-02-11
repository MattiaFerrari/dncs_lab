# DNCS-LAB (2018-2019)
Design of Networks and Communication Systems 
Mattia Ferrari
## Assigment
Based the Vagrantfile and the provisioning scripts available at: https://github.com/dustnic/dncs-lab the candidate is required to design a functioning network where any host configured and attached to router-1 (through switch ) can browse a website hosted on host-2-c.

The subnetting needs to be designed to accommodate the following requirement (no need to create more hosts than the one described in the vagrantfile):
  - Up to 130 hosts in the same subnet of host-1-a
  - Up to 25 hosts in the same subnet of host-1-b
  - Consume as few IP addresses as possible
## Network Map
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
        | |                              |eth0                  |
        | |                              |                      |
        | +------------------------------+                      |
        |                                                       |
        |                                                       |
        +-------------------------------------------------------+



```

## Network description
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





