FROM alpine:3.8

ARG DHCP_VERSION=4.4.1-r1

ENV DHCP_ENABLE=yes \
    DHCP_LEASE_PATH=/var/lib/misc \
    DHCP_NETBIOS_NAME_SERVERS="" \
    DNS_ENABLE=yes \
    DHCP_DNS_SERVERS="" \
    DNS_UPSTREAM=8.8.8.8 \
    DNS_DOMAIN=example.com \
    DHCP_IP_FORWARDING=false \
    DNS_LISTEN_ADDRESS= \
    DHCP_MAX_LEASE_TIME=14400 \
    DHCP_NTP_SERVERS=0.pool.ntp.org,1.pool.ntp.org \
    DNS_PORT=53 \
    TFTP_ENABLE=yes \
    TFTP_ROOT=/tftpboot/pxelinux \
    TFTP_SERVER=self \
    TZ=UTC

RUN apk add --no-cache --update dhcp=$DHCP_VERSION dnsmasq

EXPOSE 53/udp 67/udp 69/udp
VOLUME $DHCP_LEASE_PATH $TFTP_ROOT /etc/dhcpd.d/local /etc/dnsmasq.d/local
COPY entrypoint.sh /
COPY src/*.j2 /root/
ENTRYPOINT ["/entrypoint.sh"]
