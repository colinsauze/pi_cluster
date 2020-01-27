# Master node

* Download and extract Raspbian Lite Buster

    wget https://downloads.raspberrypi.org/raspbian_lite_latest -O raspbian_lite_latest.zip

    unzip raspbian_lite_latest.zip

* Copy the image to an SD Card
    (note change mmcblk0 to your SD card device)
    sudo dd if=2019-09-26-raspbian-buster-lite.img of=/dev/mmcblk0 status=progress

* Boot the SD card in a Raspberry Pi and connect it to the internet (preferably via ethernet).

* Run the deployment script on the Pi:

    curl 
    
## Modules
    
    
# Slave Node

* Prepare another SD card with Raspbian Lite Buster

* Boot the SD card in a Raspberry Pi and connect it to the internet (preferably via ethernet).

* Run the slave deployment script:

    curl 
    
* You now have the entire slave image on an SD card.

## Add the slave to the Slurm configuration

## Copy SD card to the Master for network booting

## Create a network bootable SD card (Raspberry Pi 2 or older)

## Setup PXE booting for Raspberry Pi 3 or newer


# Setting up user accounts




  