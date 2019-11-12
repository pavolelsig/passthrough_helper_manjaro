#!/bin/sh

for i in /sys/bus/pci/devices/*/boot_vga; do
    if [ $(cat "$i") -eq 0 ]; then
        GPU="${i%/boot_vga}"
        AUDIO="$(echo "$GPU" | sed -e "s/0$/1/")"
        echo "vfio-pci" > "$GPU/driver_override"
        if [ -d "$AUDIO" ]; then
            echo "vfio-pci" > "$AUDIO/driver_override"
        fi
    fi
done

modprobe -i vfio-pci
