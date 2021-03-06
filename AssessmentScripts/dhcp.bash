#!/bin/bash
#Storyline: Setup DHCP
function NetCon() {
#conf="00-installer-config.yaml"
conf="/etc/netplan/00-installer-config.yaml"
rm ${conf}
ip=172.16.150.5
netmask=24
gateway=172.16.150.2
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
hostname="dhcp01-sarah"
#command to set hostname
hostname ${hostname}
}
function UserCon() {
uN="sarah"
uP="Password123"
useradd -m ${uN} -p ${uP}
usermod -aG sudo ${uN}
}
function LogCon() {
echo "local0,auth,authpriv.*@172.16.200.10:1514;RYSYLOG_SyslogProtocol23Format" >> etc/rsyslog.d/sec350.conf
systemctl restart rsyslog
}
function dhcpSetup() {
apt install isc-dhcp-server
rm /etc/dhcp/dhcpd.conf
echo "
# a simple /etc/dhcp/dhcpd.conf
default-lease-time 600;
max-lease-time 7200;
authoritative;
log-facility local0;

subnet 172.16.150.0 netmask 255.255.255.0 {
 range 172.16.150.100 192.168.150.150;
 option routers 172.16.150.2;
}
" >> /etc/dhcp/dhcpd.conf
systemctl restart dhcpd
firewall-cmd --add-service=dhcp --permanent
firewall-cmd --reload
}
SysCon
UserCon
NetCon
LogCon
dhcpSetup
