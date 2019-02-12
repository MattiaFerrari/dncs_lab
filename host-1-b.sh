export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y tcpdump --assume-yes
apt-get install -y apt-transport-https ca-certificates curl software-properties-common --assume-yes --force-yes
ip link set eth1 up
ip addr add 192.168.1.1/27 dev eth1
ip replace XXX.XX.X.X/XX via 163.168.0.31
