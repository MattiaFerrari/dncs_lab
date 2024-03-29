export DEBIAN_FRONTEND=noninteractive
apt-get install -y apt-transport-https ca-certificates curl software-properties-common --assume-yes --force-yes
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install -y docker-ce --assume-yes --force-yes
apt-get install -y apt-transport-https ca-certificates curl software-properties-common --assume-yes --force-yes
ip addr add 192.168.4.2
ip link set eth1 up

///// DOCKER //////
