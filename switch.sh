export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y tcpdump --assume-yes
apt-get install -y openvswitch-common openvswitch-switch apt-transport-https ca-certificates curl software-properties-common

ovs-vsctl add-br switch
ovs-vsctl add-port switch eth 1
ovs-vsctl add-port switch eth 2 tag=1
ovs-vsctl add-port switch eth 3 tag=2

ip link set eth1 up
ip link set eth 2 up
ip link set eth 3 up
ip link set dev ovs-system up
