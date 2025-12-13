#!/bin/bash
adb reboot bootloader

cd put-pac-in-here
fastboot waitfordevice # Purposely non-functional command since getvar returns to stdout and stderr
currentslot=$(fastboot getvar current-slot 2>&1 | awk 'NR==1{print $2}')
if [[ -f "boot.img.signed" ]]; then
    bootfile="boot.img.signed"
else
    bootfile="boot_${currentslot}.img"

fi

if [[ -f "vendor_boot.img.signed" ]]; then
    vendbootfile="vendor_boot.img.signed"
else
    vendbootfile="vendor_boot_${currentslot}.img"
fi

superfile=$(ls -F super*.img)

fastboot flash boot_$currentslot $bootfile
fastboot flash init_boot_$currentslot init_boot_$currentslot.img
fastboot flash vendor_boot_$currentslot $vendbootfile
fastboot flash super $superfile
fastboot erase userdata
fastboot erase metadata
fastboot reboot