export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y tcpdump apt-transport-https ca-certificates curl software-properties-common --assume-yes --force-yes
wget -O- https://apps3.cumulusnetworks.com/setup/cumulus-apps-deb.pubkey | apt-key add -
add-apt-repository "deb [arch=amd64] https://apps3.cumulusnetworks.com/repos/deb $(lsb_release -cs) roh-3"
apt-get update
apt-get install -y frr --assume-yes --force-yes
ip link add link eth1 name eth1.1type vlan id 1
ip link add link eth1 name eth1.1type vlan id 1
ip addr add 192.168.1.1/24 dev eth1.1
ip addr add 192.168.2.1/24 dev eth1.2
ip addr add 192.168.3.1 dev eth2
ip link set eth1 up
ip link set eth1.1 up
ip link set eth1.2 up

