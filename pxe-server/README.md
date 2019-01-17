## Get syslinux
If you want to build your own syslinux, for example to embed the menu in ipxe to save some boot time:
```
cd syslinux && wget https://mirrors.edge.kernel.org/pub/linux/utils/boot/syslinux/syslinux-6.03.zip
```
apt install nasm
make all

## Inspired from repository
https://github.com/instantlinux/docker-tools/blob/master/images/dhcpd-dns-pxe/README.md

## dhcpd-dns-pxe

Serve DNS and DHCP from one or more small Alpine Linux container(s). This
supplies DNS and tftp (for network PXE booting) using dnsmasq, and
DHCP using your choice of the original ISC dhcpd or the newer
dnsmasq. Any of the three services can be enabled or disabled. 

### Usage

Create .env file setting the needed variables seen in docker-compose.yaml
Additionally download ipxe.efi and undionly.kpxe from ipxe.org and put them in the tftpserver directory.
In nginx/html modify the boot.ipxe to your liking and add any images to boot.
And lastly take a look at the dhcpd.d/*.conf.example files and move them to *.conf

Start by executing docker-compose up -d

### Variables (not entirely updated)

Variable | Default | Description |
-------- | ------- | ----------- |
DHCP_ENABLE | yes | enable dhcp server
DHCP_LEASE_PATH | /var/lib/misc | don't change this
DHCP_LEASE_TIME | 3600 | default lease time
DHCP_NETBIOS_NAME_SERVERS | | netBIOS name servers
DNS_ENABLE | yes | enable dns server
DNS_SERVER | | list of (other) DNS servers to send dhcp clients
DNS_UPSTREAM | 8.8.8.8 | upstream DNS server for queries (e.g. your ISP)
DNS_DOMAIN | example.com | your domain name
DHCP_IP_FORWARDING | false | enable clients' IP forwarding
NGINX_LISTEN_ADDRESS | | bind to IP address
DHCP_MAX_LEASE_TIME | 14400 | maximum lease time
DHCP_NTP_SERVER | 0.pool.ntp.org,1.pool.ntp.org | 
DNS_PORT | 53 | port number for DNS
TFTP_ENABLE | yes | enable tftp server
TFTP_ROOT | /tftpboot/pxelinux | don't change this

