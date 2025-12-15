# Linux-based GammaOSNext Flashing (Unisoc T820)
---

## Flashing Requirements

- libusb
- python3 (3.7+)
- A fully downloaded and decompressed GammaOSNext .pac file

**Debian/Ubuntu**
```bash
sudo apt install libusb-1.0-0 python3
```

---

## Instructions

### WARNING: This process WILL wipe your device.

1. Copy your extracted `.pac` file into this repository folder.
2. Power off your Unisoc T820-based handheld.
3. Open a terminal in the folder containing this repository and run `unpack-and-flash.sh`.
    1. Follow the instructions printed in your terminal from this point.
    2. Your device should reboot into GammaOSNext when done.

---

## Thanks to:

- TheGammaSqueeze for GammaOS, [GammaOSNext](https://github.com/TheGammaSqueeze/GammaOSNext)
- Bismoy Ghosh for Spreadtrum PAC extractor, [extractor.py](https://github.com/bismoy-bot/PAC-Extractor)
- Ilya Kurdyukov for Spreadtrum firmware dumper/flasher, [spd_dump](https://github.com/ilyakurdyukov/spreadtrum_flash)
- TomKing062 for Spreadtrum bootloader unlock blobs, [CVE-Repository](https://github.com/TomKing062/CVE-2022-38694_unlock_bootloader)