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
- adb
- fastboot
- A fully downloaded and extracted GammaOSNext .pac file

**Debian/Ubuntu**
```bash
sudo apt install libusb-1.0-0 adb fastboot
```

---

## Instructions

### WARNING: This process WILL wipe your device.

### Section 1: Prepare GammaOSNext Files
1. Copy your extracted `.pac` file into the `put-pac-in-here` folder.
2. Run the `prepare-fw-files.sh` bash script from this repository.

### Section 2: Unlock Bootloader 
1. Power off your Unisoc T820-based handheld.
2. Download and extract the `UnisocTools.7z` file from [GammaOSNext Releases](https://github.com/TheGammaSqueeze/GammaOSNext/releases/tag/v.1.0.0-T820).
3. Copy the `spd_dump` executable and the `t820-unlock.sh` bash script from this repositrory into the `UnlockBootloader` folder from the extracted archive.
    1. (Optional) Rename the `spd_dump.exe` file in that folder to something like `spd_dump_windows.exe` to avoid confusion.
4. Open a terminal in the `UnlockBootloader` folder and run `t820-unlock.sh`.
    1. While holding the **Back** button on your device, plug the device into your computer.
    2. Your device will reboot after the unlock, and may reboot to recovery with a scary warning. Don't panic and just perform the Factory Reset as instructed.

### Section 3: Enable USB Debugging
1. Once you are back in the Stock OS, enable **Developer Options**:
    1. Open your **Settings** app.
    2. Scroll all the way to the bottom and tap **About Device**.
    3. Scroll down and find the **Build Number** area.
    4. Tap it 7-10 times, until *"You are now a Developer!"* shows up at the bottom of your screen.
    5. Go back one screen and tap **System**, then find and tap **Developer Options**
        1. This may be hidden in a dropdown.
2. Enable **USB Debugging**
    1. Scroll down and tap the switch next to the **USB Debugging* option.
    2. This will ask you to confirm, do so.
    3. If your device is still plugged in, it will ask for authorization. Check the box and approve it.

### Section 4: Flash GammaOSNext
1. Plug your device into your computer and approve any popups that may show on the screen.
1. Run the `flash-fw.sh` bash script from this repository.
    1. This will take a few minutes. Grab a drink or stand up for a bit!
    2. Your device should reboot into GammaOSNext when done.

2. Enjoy!