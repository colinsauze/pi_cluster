#!/bin/bash

for i in `cat piclusternames.csv` ; do
    name=`echo $i | awk -F, '{print $1}' | tr '[:upper:]' '[:lower:]'`
    echo "Creating account for $name"
    email=`echo $i | awk -F, '{print $2}'`
    password=`echo $i | awk -F, '{print $3}'`
    password_hash=`openssl passwd -1 $password`
    sudo useradd -p "$password_hash"  $name
    sudo mkdir /home/$name
    sudo rsync -a /etc/skel/ /home/$name/
    sudo chown -R $name:$name /home/$name
    sudo usermod --shell /bin/bash $name
done

#copy the passwd file so accounts exist on the slaves
sudo cp /etc/passwd /nfs/etc/passwd
