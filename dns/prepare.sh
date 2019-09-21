#!/bin/bash
DATA_PATH=/opt/containers/dns
echo "Creating initial configuration area"
# Pi hole
mkdir -p $DATA_PATH/log
touch $DATA_PATH/log/pihole.log

# Traefik
mkdir -p $DATA_PATH/traefik/rules
echo '[file]' > $DATA_PATH/traefik/traefik.toml
echo 'directory = "/rules/"' >> $DATA_PATH/traefik/traefik.toml
echo 'watch = true' >> $DATA_PATH/traefik/traefik.toml

echo "Generating traefik rules"
./generate_traefik_rules.py > $DATA_PATH/traefik/rules/01_static_routes.toml

###
#echo "Getting root.hints"
#wget -O config/unbound/root.hints https://www.internic.net/domain/named.root

#echo "Setting extra fixed IP address to the server - wired LAN"
#sudo ip addr add 10.0.0.121/24 dev eth0

echo "Go ahead and start the containers"
echo "docker-compose up -d"

