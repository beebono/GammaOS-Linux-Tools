#!/bin/bash

get_longest() {
    local longest=""
    local max_len=0
    for file in "$@"; do
        if [[ ${#file} -gt $max_len ]]; then
            longest="$file"
            max_len=${#file}
        fi
    done
    echo "$longest"
}

shopt -s nullglob

pacs=( *.pac )
if (( ${#pacs[@]} == 0 )); then
  echo "No .pac file found in: $(pwd)" >&2
  exit 1
fi

fwfile="$(ls -t -- "${pacs[@]}" | head -n 1)"
echo "Using PAC: $fwfile"

rm -rf extracted
mkdir -p extracted
cd extracted

python3 ../tools/extractor.py "../$fwfile" .

if [[ -f "super.img" ]]; then
    superfile="super.img"
elif [[ -f "super_full.img" ]]; then
    superfile="super_full.img"
elif [[ -f "super_lite.img" ]]; then
    superfile="super_lite.img"
else
    echo "No super image found. Is your chosen firmware valid?" >&2
    exit 1
fi

ubootafiles=( uboot_a.img* )
ubootbfiles=( uboot_b.img* )
if (( ${#ubootafiles[@]} > 0 && ${#ubootbfiles[@]} > 0 )); then
    ubootafile=$(get_longest "${ubootafiles[@]}")
    ubootbfile=$(get_longest "${ubootbfiles[@]}")
elif (( ${#ubootafiles[@]} > 0 )); then
    ubootafile=$(get_longest "${ubootafiles[@]}")
    ubootbfile=$ubootafile
elif (( ${#ubootbfiles[@]} > 0 )); then
    ubootafile=$(get_longest "${ubootbfiles[@]}")
    ubootbfile=$ubootafile
else
    echo "Missing or unexpected uboot parititions! Cannot continue!"
    exit 1
fi

if [[ -f "boot.img.signed" ]]; then
    bootafile="boot.img.signed"
    if [[ -f "boot.img.signed(1)" ]]; then
        bootbfile="boot.img.signed(1)"
    else
        bootbfile=$bootafile
    fi
else
    bootafile="boot_a.img"
    bootbfile="boot_b.img"
fi

if [[ -f "vendor_boot.img.signed" ]]; then
    vendbootafile="vendor_boot.img.signed"
    if [[ -f "vendor_boot.img.signed(1)" ]]; then
        vendbootbfile="vendor_boot.img.signed(1)"
    else
        vendbootbfile=$vendbootafile
    fi
else
    vendbootafile="vendor_boot_a.img"
    vendbootbfile="vendor_boot_b.img"
fi

if [[ -f "dtbo.img.signed" ]]; then
    dtboafile="dtbo.img.signed"
    if [[ -f "dtbo.img.signed(1)" ]]; then
        dtbobfile="dtbo.img.signed(1)"
    else
        dtbobfile=$dtboafile
    fi
else
    dtboafile="dtbo_a.img"
    dtbobfile="dtbo_b.img"
fi

read -n 1 -r -s -p $'\nOn Linux you may be asked for your sudo password to prevent libusb permission issues.\nIf you are uncomfortable with that, close your terminal and do not proceed.\nGet ready to plug your device into your computer while holding the BACK button on it.\nPress any key when you are ready...\n'

cd ../tools

case "$(uname -s)" in
    Darwin)
        spd=./spd_dump-darwin
        # Gatekeeper blocks quarantined binaries (e.g. when this repo was downloaded as a zip)
        xattr -d com.apple.quarantine "$spd" 2>/dev/null
        # The boot ROM is a vendor-specific device (class 0xff), so macOS binds no
        # driver and a normal user can claim it -- no sudo needed. Worse, on Apple
        # Silicon the "allow accessory" authorization belongs to the console user,
        # not root, so running under sudo can stop the process seeing the device.
        sudo=""
        ;;
    *)
        spd=./spd_dump
        # Linux binds cdc_acm to the device; root is needed to detach and claim it.
        sudo="sudo"
        ;;
esac

$sudo "$spd" --wait 600 \
    exec_addr 0x65012f48 \
    fdl ../unisoc-blobs/fdl1-boot.bin 0x65000800 \
    fdl ../unisoc-blobs/fdl2-cboot.bin 0xb4fffe00 \
    fdl ../unisoc-blobs/trustos_a.bin 0xbd05fe00 \
    fdl ../unisoc-blobs/teecfg_a.bin 0xbd03fe00 \
    fdl ../unisoc-blobs/sml_a.bin 0xbcfffe00 \
    exec

# Note: the unlock exec resets the device, so spd_dump exits non-zero here
# even on success. Don't gate on it -- the charging screen is the real signal.

read -n 1 -r -s -p $'\nBootloader unlocked! Wait for your device to get to the charging screen.\nThen, please unplug your device and get ready to replug it while holding the BACK button again.\nPress any key when you are ready...\n'

$sudo "$spd" --wait 600 \
    fdl ../extracted/fdl1-dl.bin 0x65000800 \
    fdl ../extracted/fdl2-dl.bin 0xb4fffe00 \
    exec \
    w uboot_a ../extracted/$ubootafile \
    w uboot_b ../extracted/$ubootbfile \
    w boot_a ../extracted/$bootafile \
    w boot_b ../extracted/$bootbfile \
    w vendor_boot_a ../extracted/$vendbootafile \
    w vendor_boot_b ../extracted/$vendbootbfile \
    w dtbo_a ../extracted/$dtboafile \
    w dtbo_b ../extracted/$dtbobfile \
    w super ../extracted/$superfile \
    w vbmeta_a ../extracted/vbmeta_a.img \
    w vbmeta_b ../extracted/vbmeta_b.img \
    w vbmeta_system_a ../extracted/vbmeta_system_a.img \
    w vbmeta_system_b ../extracted/vbmeta_system_b.img \
    w vbmeta_vendor_a ../extracted/vbmeta_vendor_a.img \
    w vbmeta_vendor_b ../extracted/vbmeta_vendor_b.img \
    w vbmeta_system_ext_a ../extracted/vbmeta_system_ext_a.img \
    w vbmeta_system_ext_b ../extracted/vbmeta_system_ext_b.img \
    w vbmeta_product_a ../extracted/vbmeta_product_a.img \
    w vbmeta_product_b ../extracted/vbmeta_product_b.img \
    w vbmeta_odm_a ../extracted/vbmeta_odm_a.img \
    w vbmeta_odm_b ../extracted/vbmeta_odm_b.img \
    e misc \
    e metadata \
    e userdata \
    set_active a \
    firstmode 0 \
    reset

# spd_dump exits non-zero after 'reset' reboots the device, so a clean run and
# a failure look the same from here. Watch the handheld: it should reboot into
# GammaOSNext. If it doesn't, re-run this script.
echo
echo "Flash sequence sent. Your device should now reboot into GammaOSNext."
