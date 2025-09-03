# Check UEFI bitness (boot mode) == 64
cat /sys/firmware/efi/fw_platform_size

# Check if connected to internet == 100% succesfull
ip link
ping -c 4 archlinux.org

# Update the system clock
timedatectl

# Update mirror list to closest mirrors
reflector --country NL --latest 20 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
cat /etc/pacman.d/mirrorlist

# Partition the disk
fdisk -l /dev/nvme0n1
if true; then
        parted /dev/nvme0n1 -- rm 1
        parted /dev/nvme0n1 -- rm 2
        parted /dev/nvme0n1 -- rm 3
        parted /dev/nvme0n1 -- mklabel gpt
        parted /dev/nvme0n1 -- mkpart ESP fat32 1MB 1GB
        parted /dev/nvme0n1 -- mkpart root ext4 1GB 100%
        parted /dev/nvme0n1 -- set 1 esp on
        mkfs.fat -F 32 -n boot /dev/nvme0n1p1
        mkfs.ext4 -L arch /dev/nvme0n1p2
        fdisk -l /dev/nvme0n1
fi

# Mount the root file system
mount /dev/disk/by-label/arch /mnt

# Install and config a minimum arch system
pacstrap -i /mnt base linux linux-firmware
pacstrap -i /mnt grub efibootmgr intel-ucode networkmanager openssh vi neovim man-db man-pages fzf
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt ln -sf /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime
arch-chroot /mnt hwclock --systohc
arch-chroot /mnt systemctl enable NetworkManager
arch-chroot /mnt vi /etc/locale.gen
arch-chroot /mnt locale-gen
echo "LANG=en_US.UTF-8" >> /mnt/etc/locale.conf
echo "ghost" > /mnt/etc/hostname
echo 'root:'
arch-chroot /mnt passwd
# DO NOT FORGET TO CHANGE GROUP NAME `my_group`!
arch-chroot /mnt groupadd my_group
arch-chroot /mnt useradd -m -g my_group -G wheel,users marcel
echo 'marcel:'
arch-chroot /mnt passwd marcel

# Install bootloader
arch-chroot /mnt mkdir /boot/EFI
arch-chroot /mnt mount /dev/disk/by-label/boot /boot/EFI
arch-chroot /mnt grub-install --target=x86_64-efi --bootloader-id=grub_uefi --efi-directory=/boot/EFI
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg

echo 'Finished! -> manual reboot into new system'
