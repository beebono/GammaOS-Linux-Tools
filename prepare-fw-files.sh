#!/bin/bash

cd put-pac-in-here
fwfile=$(ls -F *.pac)

if [ -z "$fwfile" ]; then
    echo "No pac file found."
    exit 1
fi

./pacextractor "$fwfile"