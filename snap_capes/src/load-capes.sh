#!/bin/bash

#This script is launched automatically in Erle-Brain
#on every boot and loads everything that the board needs to
#act as an autopilot. The COPY_CAPES environment variable copies
#the capies on every boot if set to 1. The COMPANION flag helps
#setting up a companion computer.
#
# Victor Mayoral Vilches - Erle Robotics [victor@erlerobot.com]

# R/W file system
mount -o remount,rw  /

# By default and given the way the file system is configured,
# once the DHCP server assigns an IP address (only one is available)
# the IP is registered and only this IP will be available until this
# script is launched again.
#
# For that purpose the board needs to be rebooted.
#
# Remove the lease file
rm /var/lib/misc/dnsmasq.leases 

# Start the wireless interfacew
#sudo service dnsmasq start
hostapd /etc/hostapd/hostapd.conf & 

# Cape source location
LOCATION="/home/ubuntu/ardupilot/Tools/Linux_HAL_Essentials"

# Copy capes
COPY_CAPES=0

# Companion computer
COMPANION=0

if (($COPY_CAPES == 1)); then 
	cp $LOCATION/BB-SPI0-PXF-01-00A0.dtbo /lib/firmware/
	cp $LOCATION/BB-SPI1-PXF-01-00A0.dtbo /lib/firmware/
	cp $LOCATION/BB-BONE-PRU-05-00A0.dtbo /lib/firmware/
	cp $LOCATION/rcinpru0 /lib/firmware
	cp $LOCATION/pwmpru1 /lib/firmware
fi 

if (($COMPANION == 1)); then 
	ifconfig eth0 up
	#ifconfig eth0 192.168.9.2
fi 

# Loading the capes
echo BB-BONE-PRU-05 > /sys/devices/bone_capemgr.*/slots
echo BB-SPI0-PXF-01 > /sys/devices/bone_capemgr.*/slots
echo BB-SPI1-PXF-01 > /sys/devices/bone_capemgr.*/slots
echo BB-UART5 > /sys/devices/bone_capemgr.*/slots
echo BB-UART4 > /sys/devices/bone_capemgr.*/slots
echo BB-UART2 > /sys/devices/bone_capemgr.*/slots
echo am33xx_pwm > /sys/devices/bone_capemgr.*/slots
echo bone_pwm_P8_36 > /sys/devices/bone_capemgr.*/slots
echo BB-ADC   > /sys/devices/bone_capemgr.*/slots

# Line for making PREEMPT_RT work
#echo 0:rcinpru0 > /sys/devices/ocp.3/4a300000.prurproc/load

# Logging
dmesg | grep "SPI"
dmesg | grep "PRU"
cat /sys/devices/bone_capemgr.*/slots

# Give the system time to load all the capes
#   experienced has proved that generally the buzzer needs some time
sleep 1

# Set CPU at max speed
cpufreq-set -g performance
#cpufreq-set -f 1000MHz


