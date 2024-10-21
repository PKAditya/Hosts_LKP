#!/bin/bash

STATE_FILE="/var/lib/kernel_check.state"
REBOOT_STATE_FILE="/var/lib/kernel_reboot.state"

x=$1
current_kernel=$(uname -r)
echo "input recieved: $x"
if echo "$current_kernel" | grep -q "$x"; then
    echo "Current kernel ($current_kernel) already matches the specified kernel."
    exit 0
fi

kernel_info=$(sudo grubby --info=ALL | grep "$x")

if [ -z "$kernel_info" ]; then
    echo "Kernel not found for the input: $x"
    exit 1
fi

kernel_name=$(echo "$kernel_info" | grep -oP '(?<=kernel=)[^ ]+' | tr -d '\"')

if [ -z "$kernel_name" ]; then
    echo "Unable to extract kernel name."
    exit 1
fi

kernel_version=$(basename "$kernel_name" | sed 's/vmlinuz-//')

echo "Extracted kernel version: $kernel_version"

echo "Setting default kernel to: $kernel_name"
sudo grubby --set-default="$kernel_name"

echo "$kernel_version" | sudo tee "$STATE_FILE" > /dev/null

echo "Rebooting the system..." | sudo tee "$REBOOT_STATE_FILE" > /dev/null

echo "Generating GRUB configuration..."
sudo grub2-mkconfig -o /boot/grub2/grub.cfg

kernel_image="/boot/vmlinuz-$kernel_version"

if [ -f "$kernel_image" ]; then
    echo "Making kernel image executable: $kernel_image"
    sudo chmod 755 "$kernel_image"
else
    echo "Kernel image not found: $kernel_image"
    exit 1
fi

echo "Broadcasting reboot message..."
wall "This system will reboot for changing the kernel"

# sudo reboot
