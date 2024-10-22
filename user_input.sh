#!/bin/bash


kernel_check(){
    local kernel="$1"
    sudo grubby --info=ALL | grep -iq "$kernel"
    return $? 
}

echo "=================================================================================================================="
echo " "
echo "Donot run this script on a Turin machine as it cannot reboot itself."
echo "Abort the run if this system is Turin system, to avoid booting issues"
echo " "
echo "=================================================================================================================="
echo "--Note--"
echo "		Providing local version of the kernel image would be enough."
echo "		Make sure that kernels that are provided by user are installed."
echo " "
while true; do
	read -p "Enter the image name for base kernel: " base
	if kernel_check "$base"; then
		echo " "
		echo "Base kernel found with input provided: $base"
		echo " "
		break
	else
		echo "There is no match input provided '$base', provide a valid input, or abort the process"
	fi
done
echo " " 

while true; do
        read -p "Enter the image name for the kernel with patches: " patches
        if kernel_check "$patches"; then
                echo " "
                echo "Kernel with patches found with input provided : $patches"
                echo " "
                break
        else
                echo "There is no match input provided '$patches', provide a valid input, or abort the process"
        fi
done

echo " "
echo "======================================"
echo " " 
echo "which lkp test-bed you want to run?"
echo "1) Only host"
echo "2) Host + vms on it"
echo "3) Host + lkp on vms"
echo "4) All of the above"
l1=1
l2=2
l3=3
l4=4
while true; do
	read -p "Enter your choice?(1/2/3/4): " runchoice
	if [ $runchoice == $l1 || $runchoice == $l2 || $runchoice == $l3 || $runchoice == $l4 ]; then
		echo "user selected choice number $runchoice"
		break
	else
		echo "Enter a valid choice between 1 & 4"
	fi
done

echo " "
echo "How do you want to create stress on the host:"
echo "1) using stress-ng"
echo "2) using vms"
v1=1
v2=2
while true; do
        read -p "Enter a valid choice(1/2): " choice
        if [ $choice == $v1 ]; then
                echo "valid choice: $choice"
                echo "replace the print statement with stress-ng function"
                break
        elif [ $choice == $v2 ]; then
                echo "valid choice: $choice"
                echo "replace the print statement with vms function"
                break
        else
                echo "Invalid choice"
        fi
done
echo " "

echo "======================================"
echo "----------Input given by user---------"
echo "base kernel: $base"
echo "patches kernel: $patches"
echo "choice: $choice"
echo "======================================"

sudo mkdir /var/lib/lkp-files
loc=$(cd ../ && pwd)

$loc/Hosts_LKP/change_kernel.sh $base
