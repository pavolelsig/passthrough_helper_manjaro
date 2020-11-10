# Sources:
# https://wiki.archlinux.org/index.php/PCI_passthrough_via_OVMF#Using_identical_guest_and_host_GPUs
# https://forum.manjaro.org/t/virt-manager-fails-to-detect-ovmf-uefi-firmware/110072

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

