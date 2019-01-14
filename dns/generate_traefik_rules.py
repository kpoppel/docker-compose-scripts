#!/usr/bin/python
## Usage:
## ./generate_traefik_rules.py > ~/containers/pihole-unbound/traefik/rules/rules.toml

import sys

f = open("traefik_servers_to_proxy.txt","ro")

servers = f.readlines()
print ("[frontends]")
for data in servers:
  # # is comment in config file
  if data[0] != "#":
    # type = {backend, rewrite} service can handle backend redirection or needs to have the URL rewritten.
    # srv  = server
    # dom  = domainname this triggers on
    # url  = the URL to the server
    type,srv,dom,url = data.strip().split(',')
    if type == "backend":
      print ("  [frontends."+srv+"]")
      print ("  backend = \""+srv+"\"")
      print ("  [frontends."+srv+".routes."+srv+"]")
      print ("  rule = \"Host: "+srv+"."+dom+"\"")
      print ("")
    if type == "rewrite":
      print ("  [frontends."+srv+"]")
      print ("  backend = \"fake\"")
      print ("  [frontends."+srv+".redirect]")
      print ("    regex = \"^http://"+srv+"."+dom+"/(.*)\"")
      print ("    replacement = \""+url+"/$1\"")
      print ("    permanent = false")

print ("[backends]")
## Define a fake backend which will never be called for the rewrite services.
print ("  [backends.fake]")
print ("    [backends.fake.servers.s1]")
print ("      url=\"http://totally.fake.ip.address\"")

for data in servers:
  # # is comment in config file
  if data[0] != "#":
    # srv = server, url = the URL to the server
    type,srv,dom,url = data.strip().split(',')
    if type == "backend":
      print ("  [backends."+srv+"]")
      print ("    [backends."+srv+".servers."+srv+"]")
      print ("    url = \""+url+"\"")
      print ("")

"""
Final result:
[frontends]
  [frontends.squeezebox]
  backend = "squeezebox"
  [frontends.squeezebox.routes.squeezebox]
  rule = "Host: squeezebox.home.lan"

[backends]
  [backends.squeezebox]
    [backends.squeezebox.servers.squeezebox]
    url = "http://10.0.0.2:9000"
"""
