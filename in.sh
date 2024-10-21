#!/bin/bash

echo "================================================================================================"
echo "--Note--"
echo "		Providing local version of the kernel image would be enough."
echo "		Make sure that kernels that are provided by user are installed."
echo " "
read -p "Enter the image name for base kernel: " base
echo " " 
read -p "Enter the image name for the kernel with patches: " patches
echo " "
echo "======================================"
echo " " 
echo "How do you want to create stress on the host:"
echo "1) using stress-ng"
echo "2) using vms"
read -p "Enter a valid choice (1/2): " choice
echo " "
echo "======================================"
echo "base kernel: $base"
echo "patches kernel: $patches"
echo "choice: $choice"

echo "======================================"


loc=$(cd ../ && pwd)

vms=("vm" "vm-clone" "vm-clone1" "vm-clone2" "vm-clone3")
lkpvms=("lkpvm" "lkpvm-clone" "lkpvm-clone1" "lkpvm-clone2" "lkpvm-clone3" "lkpvm-clone4" "lkpvm-clone5" "lkpvm-clone6" "lkpvm-clone7" "lkpvm-clone8" "lkpvm-clone9" "lkpvm-clone10")
$loc/Hosts_LKP/change_kernel.sh $base
