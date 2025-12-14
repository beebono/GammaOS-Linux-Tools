#!/bin/bash

cd put-pac-in-here

if [[ -f "super.img" ]]; then
    superfile="super.img"
elif [[ -f "super_lite.img" ]]; then
    superfile="super_lite.img"
else
    echo "No super*.img found. Did you unpack your firmware?" >&2
    exit 1
fi

if [[ -f "boot.img.signed" ]]; then
    bootafile="boot.img.signed(1)"
    bootbfile="boot.img.signed(1)"
else
    bootafile="boot_a.img"
    bootbfile="boot_b.img"
fi

if [[ -f "vendor_boot.img.signed" ]]; then
    vendbootafile="vendor_boot.img.signed(1)"
    vendbootbfile="vendor_boot.img.signed(1)"
else
    vendbootafile="vendor_boot_a.img"
    vendbootbfile="vendor_boot_b.img"
fi

if [[ -f "dtbo.img.signed" ]]; then
    dtboafile="dtbo.img.signed(1)"
    dtbobfile="dtbo.img.signed(1)"
else
    dtboafile="dtbo_a.img"
    dtbobfile="dtbo_b.img"
fi

cd ../

sudo ./spd_dump --wait 600 \
    exec_addr 0x65012f48 \
    fdl ./unisoc-blobs/fdl1-boot.bin 0x65000800 \
    fdl ./unisoc-blobs/fdl2-cboot.bin 0xb4fffe00 \
    fdl ./unisoc-blobs/trustos_a.bin 0xbd05fe00 \
    fdl ./unisoc-blobs/teecfg_a.bin 0xbd03fe00 \
    fdl ./unisoc-blobs/sml_a.bin 0xbcfffe00 \
    exec

read -n 1 -r -s -p $'Bootloader unlocked! Wait for your device to get to the charging screen.\nThen, please unplug your device and get ready to replug it while holding the BACK button again.\nPress any key when you are ready...\n'

sudo ./spd_dump --wait 600 \
    exec_addr 0x65012f48 \
    fdl ./put-pac-in-here/fdl1-dl.bin 0x65000800 \
    fdl ./put-pac-in-here/fdl2-dl.bin 0xb4fffe00 \
    exec \
    w super ./put-pac-in-here/$superfile \
    w boot_a ./put-pac-in-here/$bootafile \
    w boot_b ./put-pac-in-here/$bootbfile \
    w vendor_boot_a ./put-pac-in-here/$vendbootafile \
    w vendor_boot_b ./put-pac-in-here/$vendbootbfile \
    w dtbo_a ./put-pac-in-here/$dtboafile \
    w dtbo_b ./put-pac-in-here/$dtbobfile \
    write_parts_a ./put-pac-in-here \
    write_parts_b ./put-pac-in-here \
    set_active a \
    reset




