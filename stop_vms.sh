#!/bin/bash

# List all the VMs and filter their names
vm_list=$(virsh list --all | awk '{print $2}' | grep -v "^$" | grep -v "Name")

# Loop through each VM and shut it down
for vm in $vm_list; do
  echo "Shutting down $vm..."
  virsh shutdown "$vm"
done

echo "All VMs have been shut down."

