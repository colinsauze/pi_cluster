#!/bin/sh

sudo scontrol update NodeName=worker[00-09] state=down reason="power down"

for i in `seq -w 00 09` ; do
    echo $i
    ssh pi@worker$i 'sudo halt'
done
