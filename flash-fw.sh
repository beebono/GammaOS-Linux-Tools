#!/bin/bash
adb reboot bootloader

cd put-pac-in-here
currentslot=$(fastboot getvar current-slot 2>&1 | awk 'NR==1{print $2}')
superfile=$(ls -F super*.img)

fastboot flash boot_$currentslot boot.img.signed
fastboot flash init_boot_$currentslot init_boot_$currentslot.img
fastboot flash vendor_boot_$currentslot vendor_boot.img.signed
fastboot flash super $superfile
fastboot erase userdata
fastboot erase metadata
fastboot reboot