#!/bin/bash 


rm /usr/bin/vfio-pci-override.sh

rm /etc/initcpio/install/vfio

rm /etc/initcpio/hooks/vfio

rm /etc/modprobe.d/vfio.conf


if [ -a Backup/grub ]
	then
		rm /etc/default/grub
		cp Backup/grub /etc/default/
fi

if [ -a Backup/mkinitcpio.conf ]
	then
		rm /etc/mkinitcpio.conf
		cp Backup/mkinitcpio.conf /etc/
fi

mkinitcpio -P

