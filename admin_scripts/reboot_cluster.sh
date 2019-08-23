#!/bin/sh

for i in `seq -w 00 09` ; do
    echo $i
    ssh pi@worker$i 'sudo reboot'
done
