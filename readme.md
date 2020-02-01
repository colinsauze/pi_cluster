# Raspberry Pi Cluster

This repository contains a set of scripts, notes and demo software for building a Raspberry Pi cluster intended for teaching basic HPC concepts or doing a public science demo.



## Configuring a cluster

### What will you need?

* A master node, these scripts assume this is going to be a Raspberry Pi 3 or newer. It will be turned into a WiFi access point for users to connect to.
* Internet access for the master node, this is assumed to be coming from a system pre-configured with the IP address 10.0.0.1. If you want this set via DHCP edit the mac address on line 28 of /etc/dnsmasq.conf on the Master node.
* One or more compute nodes. These scripts assume these are single core Raspberry Pi 1s or B+s. 


### Master/head node

* Download and extract Raspbian Lite Buster

    `wget https://downloads.raspberrypi.org/raspbian_lite_latest -O raspbian_lite_latest.zip`

    `unzip raspbian_lite_latest.zip`

* Copy the image to an SD Card
    (note change mmcblk0 to your SD card device)
    `sudo dd if=2019-09-26-raspbian-buster-lite.img of=/dev/mmcblk0 status=progress`

* Boot the SD card in a Raspberry Pi and connect it to the internet (preferably via ethernet).

* Run the deployment script on the Pi:

    `wget https://raw.githubusercontent.com/colinsauze/pi_cluster/master/deployment/deploy-master.sh`
    `sudo bash ./deploy-master.sh`

* Reboot the Pi

* You should now have a fully installed master node. Running 'sinfo' should give an output like:

    `PARTITION AVAIL TIMELIMIT NODES STATE  NODELIST`
    
    `compute     down*     infinite     10 idle*  node[0-9]`

* The * next to the down means that the nodes are unreachable. 

#### Change WiFi network name/password

Edit `/etc/hostapd/hostapd.conf` and change the "ssid" and "wpa_passphrase" options. 

### Compute node

* Prepare another SD card with Raspbian Lite Buster

* Boot the SD card in a Raspberry Pi and connect it to the internet (preferably via ethernet).

* Run the slave deployment script:

    `wget https://raw.githubusercontent.com/colinsauze/pi_cluster/master/deployment/deploy-slave.sh`
    `sudo bash ./deploy-slave.sh`

* Register the node's mac address and allocate it the IP 10.0.0.100 by running admin_scripts/add_new_host.sh from the master node. Note that the compute node must be the most recent thing to request a DHCP lease for this to work. 

* Reboot the Pi
    
* You now have one fully deployed compute node. This will boot with the home directory NFS mounted from the master and the root filesystem read only, but still on the SD card. The compute node's IP address should be 10.0.0.100, the Slurm configuration won't work correctly if it isn't.

* Run sinfo on the master node it should now show one node in a contactable state (without a * next to it)

    `PARTITION AVAIL TIMELIMIT NODES STATE  NODELIST`
    `compute     down*     infinite     9 idle*  node[1-9]`
    `compute     down     infinite     1 idle  node00`

#### Network booting the root filesystem
(this has not yet been fully tested)
* Run deployment/copy_slave_fs.sh to copy the contents of the root filesystem to the master. 
* Copy `config/node/cmdline_nfsboot.txt` to `/boot/cmdline.txt `
* Reboot the Pi, it should now mount its root filesystem from NFS.
* Deploy additional nodes by copying the contents of /boot from any node and config/node/cmdline_nfsboot.txt in place of the default cmdline.txt

## Bringing the cluster up
* Its best not to power on all the compute nodes at once, this can generate too much NFS traffic. Power them on in groups of 3 or 4. 
* Run the script admin_scripts/cluster_up.sh on the master node or run: 'sudo scontrol update NodeName=worker[00-09] state=resume'

## Shutting down the cluster
* Shutdown the compute nodes by running admin_scripts/shutdown_cluster.sh on the master node.
* Shutdown the master node

## Creating User Accounts
* Create a CSV spreadsheet with the format: 

    `username,email,password` 
    
* Save it as `piclusternames.csv` in the admin_scripts directory. 

* Run `admin_scripts/make_users.sh` 
* This will create an account on the master node and copy the new passwd file to the compute nodes. 
* WARNING: This code needs additional testing that it doesn't wipe out system users and break slurm.  

### Configuring Quotas

* (Assuming home directories are on their own disk)
* Remount the drive with quota support:

 `sudo mount /dev/sda1 /home -o remount,usrquota,grpquota`

* Enable quotas:
 `sudo quotaon /home`

* Verify quotas:
 `sudo quotacheck -ugm /home`

* Setup quota for a user:
 `sudo edquota -u <userid>`

* Copy another users's quota settings:
 `sudo edquota -p <template userid> <target user id>`


## Additional Setup Changes

### Moving home directories to a hard disk

* Connect a USB hard disk to the master, we are assuming that you want to use the first partition as a home directory (/dev/sda1)

* `sudo mkfs.ext4 /dev/sda1`

* UUID=`sudo dumpe2fs -h /dev/loop0 2>&1 | grep UUID | awk '{print $3}'`

* `echo "UUID=$UUID  /home   ext4    defaults,usrquota,grpquota,noauto" | sudo tee -a /etc/fstab`

* Note that noauto option is there so that the boot doesn't hang if the hard disk isn't connected
 
### Moving the entire master image to a hard disk

TODO

### PXE booting nodes (Raspberry Pi 3 and newer only)

TODO

### Add more compute nodes

* Edit /etc/slurm/slurm-llnl.conf and change the PartitionName and NodeName definitions.
* Add more entries to /etc/hosts
* (optional) update the shutdown_cluster.sh, reboot_cluster.sh and cluster_up.sh scripts to include your new nodes.

## Potential Problems 

### NTP Synchronisation
* Slurm requires all nodes to have synchronised clocks. 
* All compute nodes run an NTP daemon getting time from the master node. The master node in turn will try and get the time from the internet, it needs an internet connection for this to work. 
 
## Running A job

* Use all your faviourite standard Slurm commands.
* Directly with srun: `srun -n1 --pty /bin/bash` (change /bin/bash to program of your choice)
* Pi calculation demo: `sbatch ~/pi_cluster/demos/mpi_pi_demo/mpi_numpi.sh`

## Teaching HPC with a Raspberry Pi cluster

See [https://scw-aberystwyth.github.io/Introduction-to-HPC-with-RaspberryPi/]
