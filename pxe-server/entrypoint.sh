#! /bin/sh -e

# created 27 sep 2017 by richb
#  Populates dhcpd.conf and defaults in /etc/dhcpd.d & /etc/dnsmasq.d
#  Starts dhcpd (optionally) and dnsmasq

DHCP_USER=dhcp

if [ "$DHCP_ENABLE" == yes ]; then
  if [ ! -z "$DHCP_NETBIOS_NAME_SERVERS" ]; then
    DHCP_NETBIOS_OPTION="option netbios-name-servers $DHCP_NETBIOS_NAME_SERVERS;"
  fi
  if [ "$TFTP_SERVER" == self ]; then
    TFTP_SERVER=$(ifconfig $DHCP_INTERFACE | grep 'inet addr:' | cut -d: -f2 | awk '{print $1}')
  fi

  rm -f /etc/dhcpd.conf

  for file in /etc/dhcpd.conf /etc/dhcpd.d/default.conf; do
    if [ ! -e $file ]; then
      sed \
        -e "s:{{ DNS_UPSTREAM }}:$DNS_UPSTREAM:" \
        -e "s:{{ DNS_DOMAIN }}:$DNS_DOMAIN:" \
        -e "s:{{ DHCP_IP_FORWARDING }}:$DHCP_IP_FORWARDING:" \
        -e "s:{{ DHCP_LEASE_TIME }}:$DHCP_LEASE_TIME:" \
        -e "s:{{ DHCP_MAX_LEASE_TIME }}:$DHCP_MAX_LEASE_TIME:" \
        -e "s:{{ DHCP_NTP_SERVERS }}:$DHCP_NTP_SERVERS:" \
        -e "s:{{ DHCP_DNS_SERVERS }}:$DHCP_DNS_SERVERS:" \
        -e "s:{{ DHCP_NETBIOS_OPTION }}:$DHCP_NETBIOS_OPTION:" \
        -e "s:{{ TFTP_ENABLE }}:$TFTP_ENABLE:" \
        -e "s:{{ TFTP_SERVER }}:$TFTP_SERVER:" \
        -e "s:{{ TZ }}:$TZ:" \
      /root/$(basename $file).j2 > $file
    fi
  done
  for file in /etc/dhcpd.d/local/*.conf; do
      echo "include \"$file\";" >>/etc/dhcpd.conf
  done
#  cat /etc/dhcpd.conf
  if [ ! -z "$LISTEN_ADDRESS" ]; then
      LISTEN_FLAG="-s $LISTEN_ADDRESS"
  fi
  touch $DHCP_LEASE_PATH/dhcpd.leases
  chown $DHCP_USER $DHCP_LEASE_PATH/dhcpd.leases
  dhcpd -d -cf /etc/dhcpd.conf -lf $DHCP_LEASE_PATH/dhcpd.leases \
    -user $DHCP_USER -group daemon $LISTEN_FLAG $DHCP_INTERFACE &
fi

if [ "$TFTP_ENABLE" == yes ]; then
  TFTP_FLAG=--enable-tftp
  mkdir -p $TFTP_ROOT
  echo tftp-root=$TFTP_ROOT > /etc/dnsmasq.d/tftpd.conf
fi

if [ -d /etc/dnsmasq.d/local ] && [ "$(ls -A /etc/dnsmasq.d/local)" ]; then
  cp -a /etc/dnsmasq.d/local/. /etc/dnsmasq.d
fi

if [ "$DNS_ENABLE" == yes ]; then
  if [ ! -e /etc/dnsmasq.d/dns.conf ]; then
    sed -e "s:{{ DNS_UPSTREAM }}:$DNS_UPSTREAM:" \
      -e "s:{{ DOMAIN }}:$DNS_DOMAIN:" \
      -e "s:{{ PORT_DNSMASQ_DNS }}:$DNS_PORT:" \
    /root/dns.conf.j2 > /etc/dnsmasq.d/dns.conf
  fi
  if [ -s /etc/dnsmasq.d/hosts ]; then
    echo addn-hosts=/etc/dnsmasq.d/hosts > /etc/dnsmasq.d/hosts.conf
  fi
  if [ ! -z "$DNS_LISTEN_ADDRESS" ]; then 
    echo listen-address=$DNS_LISTEN_ADDRESS > /etc/dnsmasq.d/dns-listen.conf
  fi
else
  echo port=0 > /etc/dnsmasq.d/dns.conf
fi

exec dnsmasq --keep-in-foreground --log-facility=- $TFTP_FLAG

