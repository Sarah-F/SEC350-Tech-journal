#!/bin/bash
#Storyline: Setup Jump
function NetCon() {
conf="00-installer-config.yaml"
#conf = "/etc/netplan/00-installer-config.yaml"
#rm conf
ip=192.168.0.1
netmask=29
gateway=172.16.50.2
ns=172.16.50.2
#echo the contents onto a file
echo "
network:
   version: 2
   renderer: networkd
   ethernets:
      ens160:
         dhcp4: false
         addresses: [${ip}/${netmask}]
         gateway4: ${gateway}
         nameservers:
           addresses: [${ns}]
" >> ${conf}
netplan apply
}
function SysCon() {
hostname="jump-sarah"
#command to set hostname
hostname ${hostname}
}
SysCon
NetCon
