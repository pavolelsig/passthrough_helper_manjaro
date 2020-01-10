#Based on https://wiki.archlinux.org/index.php/PCI_passthrough_via_OVMF#Using_identical_guest_and_host_GPUs
#and
#https://forum.manjaro.org/t/virt-manager-fails-to-detect-ovmf-uefi-firmware/110072


nano /etc/default/grub

update-grub

pacman -S vim qemu virt-manager ovmf dnsmasq ebtables iptables

systemctl enable libvirtd.service



cp vfio-pci-override.sh /usr/bin/vfio-pci-override.sh

chmod +x /usr/bin/vfio-pci-override.sh

cp vfio-install /etc/initcpio/install/vfio

cp vfio-hooks /etc/initcpio/hooks/vfio

cp vfio.conf /etc/modprobe.d/


############################

#MODULES="vfio_pci vfio vfio_iommu_type1 vfio_virqfd"
#FILES="/usr/bin/vfio-pci-override.sh"
#HOOKS="... vfio ...."



nano /etc/mkinitcpio.conf

############################

mkinitcpio -p $(ls /etc/mkinitcpio.d | cut -c1-7)


echo 'nvram = [	"/usr/share/ovmf/x64/OVMF_CODE.fd:/usr/share/ovmf/x64/OVMF_VARS.fd"	]' >> /etc/libvirt/qemu.conf 


############################
#Source: https://forum.manjaro.org/t/virt-manager-fails-to-detect-ovmf-uefi-firmware/110072

mkdir -p /etc/qemu/firmware

sed 's#qemu/edk2-x86_64-code.fd#ovmf/x64/OVMF_CODE.fd#;s#qemu/edk2-i386-vars.fd#ovmf/x64/OVMF_VARS.fd#' < /usr/share/qemu/firmware/60-edk2-x86_64.json > /etc/qemu/firmware/10-ovmf-workaround.json

systemctl restart libvirtd

############################

