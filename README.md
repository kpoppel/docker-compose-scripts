# docker-compose-scripts
My docker compose scripts for my Raspberry PI 3 B+

# SSH setup:
```bash
   ssh-keygen -t rsa -b 4096 -C "4174578+kpoppel@users.noreply.github.com"
   ssh-add ~/.ssh/id_rsa
   cat ~/.ssh/id_rsa.pub
   ssh -T git@github.com
```

# SSH Agent:
```bash
   eval $(ssh-agent -s)
   ssh-add ~/.ssh/id_rsa
```
# Cloning the repository:
```bash
   git clone git@github.com:/kpoppel/docker-compose-scripts
```

# Preparing
 Edit and add to /etc/rc.local:
```bash
   ip addr add 10.0.1.128/23 dev wlan0
```
or better:
Create "/etc/systemd/system/my-docker-compose.service"
```
# /etc/systemd/system/my-docker-compose.service
# After adding a service:
#   sudo systemctl daemon-reload
#   sudo systemctl enable my-docker-compose

[Unit]
Description=Docker Compose Application Service
Requires=docker.service
After=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=/home/pi/docker-compose-scripts/pihole_unbound_traefik
ExecStart=/usr/local/bin/docker-compose up -d
ExecStop=/usr/local/bin/docker-compose down
TimeoutStartSec=0

[Install]
WantedBy=multi-user.target
```

# The docker-compose scripts:
## pihole_unbound_traefik
This is the main stack containing traefik, unbound and pihole.
Fixed IPs are setup here because pihole needs DNS servers for dnsmasq, and
docker network names cannot be used.  Also there is no guarantee that assigned IPs
won't be taken by another container, so everything is fixed.

The main rationale is this:
Pihole receives all DNS requests and the following happens:
1. Pihole know the address and uses it from cache
2. Pihole does not know the address and forwards it to unbound

Unbound receives a request from Pihole and the following happens:
1. Unbound discovers this in not a .lan address and begins the journey on the internet.
2. The address is <something>.lan and the request is forwarded to Traefik as this is
   somewhere on the internal docker network.

Traefik receives a request from Unbound and the following happens:
1. Traefik looks at the containers it know (inly on the Raspberry unfortunately)
   If it finds a match (pihole.lan) it returns the righe webpage.
2. If it does not find a match it goes to Pihole's default page, just to go somewhere nice.

## portainer
##watchtower

# Other scripts:

## Wifi connectivity check

Add this script somewhere (wificheck.sh):
```bash
##########################################
##  Script to restart wifi connection if
##  it was somehow lost.  This could be
##  the router rebooting or something.
##
##  Simply test if a local machine is reachable.
##
##  If connectino is lost an entry is made
##  to a /var/log/wificheck.log with timestamp
##########################################
#!/bin/bash
if ping -I wlan0 -c 1 10.0.0.2 | grep -q "0 received"; then
  echo `date`": No internet - attempting to restart wifi connection" >> /var/log/wificheck.log
  sudo ifconfig wlan0 down
  sudo ifconfig wlan0 up
fi
exit 0
```
remember to `chmod +x```
Then ```crontab -e``` and add
```crontab
*/5 * * * * <path to scriptwificheck.sh
`
