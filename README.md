# Linux-based GammaOSNext Flashing (Unisoc T820)
---

## External Tool Build Requirements

- gcc
- make
- libusb

**Debian/Ubuntu**
```bash
sudo apt install build-essential libusb-1.0-0 libusb-1.0-0-dev
```

---

## Flashing Requirements

- libusb
- A fully downloaded and decompressed GammaOSNext .pac file

**Debian/Ubuntu**
```bash
sudo apt install libusb-1.0-0
```

---

## Instructions

### WARNING: This process WILL wipe your device.

### Section 1: Prepare GammaOSNext Files
1. Copy your extracted `.pac` file into the `put-pac-in-here` folder.
2. Run the `prepare-fw-files.sh` bash script from this repository.

### Section 2: Unlock Bootloader and Flash GammaOSNext
1. Power off your Unisoc T820-based handheld.
2. Open a terminal in the folder containing this repository and run `unlock-and-flash.sh`.
    1. While holding the **Back** button on your device, plug the device into your computer.
    2. Follow the instructions printed in your terminal from this point.
    3. Your device should reboot into GammaOSNext when done.
