#!/bin/bash

vm_list=$(virsh list --all | awk '{print $2}' | grep -v "^$" | grep -v "Name")

for vm in $vm_list; do
  echo "Shutting down $vm..."
  virsh shutdown "$vm"
done

echo "All VMs have been shut down."

