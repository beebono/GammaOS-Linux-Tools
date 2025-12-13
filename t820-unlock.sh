#!/bin/bash
./spd_dump exec_addr 0x65012f48 \
    fdl fdl1-boot.bin 0x65000800 \
    fdl fdl2-cboot.bin 0xb4fffe00 \
    fdl trustos_a.bin 0xbd05fe00 \
    fdl teecfg_a.bin 0xbd03fe00 \
    fdl sml_a.bin 0xbcfffe00 \
    exec