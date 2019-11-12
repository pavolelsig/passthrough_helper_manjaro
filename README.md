# passthrough_helper_manjaro

Run this script using su instead of sudo. The ">" redirects of echo will not work otherwise. 


Add this to grub, /etc/default/grub: 
intel_iommu=on (or) amd_iommu=on 
rd.driver.pre=vfio-pc 
kvm.ignore_msrs=on


Add this to /etc/mkinitcpio.conf:

Modules="vfio_pci vfio vfio_iommu_type1 vfio_virqfd"

Files="/usr/bin/vfio-pci-override.sh"

Hooks="... vfio ...."


This guide is based on: 

https://wiki.archlinux.org/index.php/PCI_passthrough_via_OVMF#Using_identical_guest_and_host_GPUs
and
https://forum.manjaro.org/t/virt-manager-fails-to-detect-ovmf-uefi-firmware/110072
