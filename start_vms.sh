#!/bin/bash
var=$1
ch=1
wt=2
if [ $var==$ch ]; then
	vms=("vm" "vm-clone" "vm-clone1" "vm-clone2" "vm-clone3")
	for vm in "{vms[@]}"
	do
		virsh start "$vm"
	done
elif [ $var==$wt ]; then
	lkps=("lkp" "lkp-clone" "lkp-clone1" "lkp-clone2" "lkp-clone3" "lkp-clone4" "lkp-clone5" "lkp-clone6" "lkp-clone7" "lkp-clone8")
	for lkp in "{lkps[@]}"
	do
		virsh start "$lkp"
	done
fi
