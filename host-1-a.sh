export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y tcpdump --assume-yes
apt-get install -y apt-transport-https ca-certificates curl software-properties-common --assume-yes --force-yes
ip addr add 192.168.1.254 dev eth1
ip link set eth1 up
ip route replace XXX.XX.X.X/XX via 163.10.0.254
