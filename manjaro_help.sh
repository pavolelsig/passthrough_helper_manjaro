# Sources:
# https://wiki.archlinux.org/index.php/PCI_passthrough_via_OVMF#Using_identical_guest_and_host_GPUs
# https://forum.manjaro.org/t/virt-manager-fails-to-detect-ovmf-uefi-firmware/110072

VERSION=`lsb_release -r | cut -d '	' -f 2 | cut -d '.' -f 1`

# Backup files

mkdir Backup
chmod +x uninstall.sh

cp /etc/default/grub Backup
cp /etc/mkinitcpio.conf Backup

# Edit grub amd_iommu=on or intel_iommu=on rd.driver.pre=vfio-pci kvm.ignore_msrs=1

nano /etc/default/grub
update-grub

# Install required packages

pacman -S vim qemu virt-manager ovmf dnsmasq ebtables iptables

# Allow libvirt to autostart

systemctl enable libvirtd.service

# Copy necessary files

cp vfio-pci-override.sh /usr/bin/vfio-pci-override.sh
chmod +x /usr/bin/vfio-pci-override.sh
cp vfio-install /etc/initcpio/install/vfio
cp vfio-hooks /etc/initcpio/hooks/vfio
cp vfio.conf /etc/modprobe.d/

# Edit mkinitcpio.conf

# MODULES="vfio_pci vfio vfio_iommu_type1 vfio_virqfd"
# FILES="/usr/bin/vfio-pci-override.sh"
# HOOKS="... vfio ...."

nano /etc/mkinitcpio.conf
mkinitcpio -P

# Workaround libvirt bug in previous versions of Manjaro:
# https://forum.manjaro.org/t/virt-manager-fails-to-detect-ovmf-uefi-firmware/110072

if [ $VERSION -lt 20 ]
	then
		echo 'nvram = [	"/usr/share/ovmf/x64/OVMF_CODE.fd:/usr/share/ovmf/x64/OVMF_VARS.fd"	]' >> /etc/libvirt/qemu.conf 
		mkdir -p /etc/qemu/firmware
		sed 's#qemu/edk2-x86_64-code.fd#ovmf/x64/OVMF_CODE.fd#;s#qemu/edk2-i386-vars.fd#ovmf/x64/OVMF_VARS.fd#' < /usr/share/qemu/firmware/60-edk2-x86_64.json > /etc/qemu/firmware/10-ovmf-workaround.json
		systemctl restart libvirtd
fi
