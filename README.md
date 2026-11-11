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

**macOS** (Apple Silicon and Intel)

No extra packages are needed: `tools/spd_dump-darwin` is a universal binary with libusb built in, and `python3` comes with the Xcode Command Line Tools (`xcode-select --install`) or Homebrew.

- On Apple Silicon, macOS asks *"Allow accessory to connect?"* the first time a new USB device is plugged in. The device only stays in flashing mode for a short window, so either be ready to click **Allow** immediately, or first set **System Settings → Privacy & Security → Allow accessories to connect** to *Automatically when unlocked*.
- Unlike Linux, macOS does **not** need `sudo`. The device's boot ROM is a vendor-specific USB device that macOS binds no driver to, so a normal user can talk to it. The script runs the flasher without `sudo` on macOS automatically — and on Apple Silicon running it under `sudo` can actually stop it from seeing the device, since the *Allow accessory* authorization belongs to your login session, not root.

---

## Instructions

### WARNING: This process WILL wipe your device.

1. Copy your extracted `.pac` file into this repository folder.
2. Power off your Unisoc T820-based handheld.
3. Open a terminal in the folder containing this repository and run `unpack-and-flash.sh`.
    1. Follow the instructions printed in your terminal from this point.
    2. Your device should reboot into GammaOSNext when done.

---

## Rebuilding `spd_dump` for macOS

Both `tools/spd_dump` (Linux) and `tools/spd_dump-darwin` (macOS) are built from [TomKing062's fork of spreadtrum_flash](https://github.com/TomKing062/spreadtrum_flash) at commit `d24c21a` — the fork adds the `exec_addr`, `set_active` and `firstmode` commands this script depends on. The macOS build has libusb 1.0.29 linked statically. To rebuild it for your own architecture:

```bash
brew install libusb
git clone https://github.com/TomKing062/spreadtrum_flash
cd spreadtrum_flash
echo "#define GIT_VER \"$(git rev-parse --abbrev-ref HEAD)\"" > GITVER.h
echo "#define GIT_SHA1 \"$(git rev-parse HEAD)\"" >> GITVER.h
cc -O2 -std=c99 -Wno-unused -DUSE_LIBUSB=1 -I"$(brew --prefix libusb)/include" -o spd_dump-darwin spd_dump.c common.c \
    "$(brew --prefix libusb)/lib/libusb-1.0.a" -lm -lpthread -framework IOKit -framework CoreFoundation -framework Security -lobjc
```

---

## Thanks to:

- TheGammaSqueeze for GammaOS, [GammaOSNext](https://github.com/TheGammaSqueeze/GammaOSNext)
- Bismoy Ghosh for Spreadtrum PAC extractor, [extractor.py](https://github.com/bismoy-bot/PAC-Extractor)
- Ilya Kurdyukov for Spreadtrum firmware dumper/flasher, [spd_dump](https://github.com/ilyakurdyukov/spreadtrum_flash)
- TomKing062 for the [spd_dump fork](https://github.com/TomKing062/spreadtrum_flash) used here, and Spreadtrum bootloader unlock blobs, [CVE-Repository](https://github.com/TomKing062/CVE-2022-38694_unlock_bootloader)