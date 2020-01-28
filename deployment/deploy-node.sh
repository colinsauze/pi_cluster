#!/bin/bash

#exit if any command fails
set -e 

if [ `whoami` != "root" ] ; then
    echo "Rerun as root"
    exit 1
fi

apt -y update
apt -y install mc git ntp screen tmux vim-nox lsof tcpdump python3-pip dnsmasq bridge-utils quota slurmd slurm-client slurm-wlm slurm-wlm-basic-plugins munge mpich libmpich-dev environment-modules zlib1g zlib1g-dev libxml2-dev quota libffi-dev libssl-dev build-essential liblapack3 libatlas-base-dev
apt -y upgrade

git clone --recursive https://github.com/colinsauze/pi_cluster
chown -R pi:pi /home/pi/pi_cluster
cd /home/pi/pi_cluster/config

cp -r node/etc/* /etc
cp node/config.txt /boot

#tmux wants the US locale??? Seems to work without it, commenting out for now
#echo "enable en_US UTF8 locale"
#dpkg-reconfigure locales

#enable SSHD
systemctl enable ssh

#set the password to "Raspberries"
usermod -p '$6$YRfpaLjt1qWOJAPd$dpGwjm0AxrRmDmKhfpjPWnk441gpO5ESUCj5LmEkAxon.VRbhldH7JQGj9uO0nvLnBechI9HK.FtZosuB6upR0' pi

#install SSH keys
mkdir /home/pi/.ssh
chmod 700 /home/pi/.ssh
cp /home/pi/pi_cluster/deployment/authorized_keys /home/pi/.ssh/authorized_keys
chmod 600  /home/pi/.ssh/authorized_keys
chown -R pi:pi /home/pi/.ssh


#set the timezone
rm /etc/localtime
ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime

#setup python3 module

#python needs ssl for pip and the system version of openssl seems to incompatible
#i'm still struggling to find a version which actually works
#cd /home/pi
#wget https://www.openssl.org/source/old/1.0.2/openssl-1.0.2u.tar.gz
#tar xvfz openssl-1.0.2u.tar.gz
#cd  openssl-1.0.2u
#./config --prefix=/usr/share/modules/Modules/python/3.7.0
#make -j 4
#make install


wget https://www.python.org/ftp/python/3.7.0/Python-3.7.0.tgz
tar xvfz Python-3.7.0.tgz 
cd Python-3.7.0/
./configure --prefix=/usr/share/modules/Modules/python/3.7.0
make -j4
make install

#remove default system modules
mv /usr/share/modules/modulefiles /usr/share/modules/modulefiles.unwanted
mkdir -p /usr/share/modules/modulefiles/python/3.7.0 
cp /home/pi/pi_cluster/modules/python-3.7.0 /usr/share/modules/modulefiles/python/3.7.0 


#load the module to build numpy
. /etc/profile.d/modules.sh 
module load python/3.7.0

pip3 install cython

cd /home/pi
wget https://github.com/numpy/numpy/releases/download/v1.17.4/numpy-1.17.4.tar.gz
tar xvfz numpy-1.17.4.tar.gz
cd numpy-1.17.4
python3.7 setup.py build -j 4 install --prefix /usr/share/modules/Modules/python/3.7.0/

pip3 install matplotlib

#unload the module to install matplotlib using the system pip 
module purge

