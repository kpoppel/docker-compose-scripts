#!/bin/bash
echo "Getting root.hints"
wget -O config/unbound/root.hints https://www.internic.net/domain/named.root

echo "Setting extra fixed IP address to the server"
sudo ip addr add 10.0.1.128/23 dev wlan0

echo "Go ahead and start the containers"
echo "docker-compose up -d"

