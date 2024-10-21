#!/bin/bash

# File to store the expected kernel version
STATE_FILE="/var/lib/kernel_check.state"
# File to track if the process has reached the reboot step
REBOOT_STATE_FILE="/var/lib/kernel_reboot.state"

# Step 1: Take user input
# read -p "Enter the kernel name (or part of it): " x
x=$1
# Step 2: Get the currently running kernel version
current_kernel=$(uname -r)
echo "input recieved: $x"
# Check if the current kernel matches the user's input
if echo "$current_kernel" | grep -q "$x"; then
    echo "Current kernel ($current_kernel) already matches the specified kernel."
    exit 0
fi

# Step 3: Search for the kernel name with 'x' using grubby
kernel_info=$(sudo grubby --info=ALL | grep "$x")

# Check if the kernel was found
if [ -z "$kernel_info" ]; then
    echo "Kernel not found for the input: $x"
    exit 1
fi

# Extract the kernel name from the output
kernel_name=$(echo "$kernel_info" | grep -oP '(?<=kernel=)[^ ]+' | tr -d '\"')

# Check if we successfully extracted the kernel name
if [ -z "$kernel_name" ]; then
    echo "Unable to extract kernel name."
    exit 1
fi

# Extract only the version part from the kernel name (removing "/boot/vmlinuz-")
kernel_version=$(basename "$kernel_name" | sed 's/vmlinuz-//')

# Print the extracted kernel version for debugging
echo "Extracted kernel version: $kernel_version"

# Step 4: Set the found kernel as the default
echo "Setting default kernel to: $kernel_name"
sudo grubby --set-default="$kernel_name"

# Save the expected kernel version (not the full path) to the state file
echo "$kernel_version" | sudo tee "$STATE_FILE" > /dev/null

# Indicate that the process is ready to reboot
echo "Rebooting the system..." | sudo tee "$REBOOT_STATE_FILE" > /dev/null

# Step 5: Generate a GRUB configuration file
echo "Generating GRUB configuration..."
sudo grub2-mkconfig -o /boot/grub2/grub.cfg

# Step 6: Make the kernel image executable
kernel_image="/boot/vmlinuz-$kernel_version"

# Check if the kernel image exists
if [ -f "$kernel_image" ]; then
    echo "Making kernel image executable: $kernel_image"
    sudo chmod 755 "$kernel_image"
else
    echo "Kernel image not found: $kernel_image"
    exit 1
fi

# Step 7: Broadcast a network message
echo "Broadcasting reboot message..."
wall "This system will reboot for changing the kernel"

# Step 8: Reboot the system
# sudo reboot

