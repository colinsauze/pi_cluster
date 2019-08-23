#!/bin/bash

if [ `whoami` != "root" ] ; then
    echo "run me as root"
    exit 1
fi

max_ip=`cat /etc/dnsmasq.conf | grep dhcp-host | tail -1 | awk -F, '{print $2}' | awk -F. '{print $4}'`
new_ip=10.0.0.$[$max_ip+1]
mac=`head -1 /var/lib/misc/dnsmasq.leases | awk '{print $2}'`
current_ip=`head -1 /var/lib/misc/dnsmasq.leases | awk '{print $3}'`

echo "Adding $mac as $new_ip (currently allocated to $current_ip)"
echo "Press any key to continue"
read r

echo "dhcp-host=$mac,$new_ip" >> /etc/dnsmasq.conf
service dnsmasq restart
su pi -c "ssh pi@$current_ip 'sudo reboot'"
