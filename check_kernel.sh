#!/bin/bash

# File to store the expected kernel version
STATE_FILE="/var/lib/kernel_check.state"
# File to track if the process has reached the reboot step
REBOOT_STATE_FILE="/var/lib/kernel_reboot.state"

# Step 1: Check if the state file exists
if [ ! -f "$STATE_FILE" ]; then
    echo "State file not found. Please ensure the kernel change script has run."
    exit 1
fi

# Step 2: Read the expected kernel version from the state file
expected_kernel=$(cat "$STATE_FILE")

# Step 3: Get the currently running kernel version
current_kernel=$(uname -r)

# Step 4: Compare the expected kernel with the current kernel
if [ "$expected_kernel" == "$current_kernel" ]; then
    echo "Success: The system has booted with the expected kernel: $current_kernel"
    exit 0
else
    echo "Error: The system is running a different kernel: $current_kernel"
    echo "Expected kernel: $expected_kernel"
fi

# Step 5: Check if the reboot state file exists
if [ -f "$REBOOT_STATE_FILE" ]; then
    echo "The system has rebooted, but the expected kernel did not load."
else
    echo "The process did not reach the reboot step."
fi

