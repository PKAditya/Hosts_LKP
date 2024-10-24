#!/bin/bash
state_file=/var/lib/lkp-files/run_state
lkp_progress=/var/lib/lkp-files/progress.txt
if [ -f "$lkp_progress" ]; then
	echo "A lkp run is in progress, so please wait till it completes."
	exit 1
else
	echo""
fi
if [ -f "$state_file" ]; then
	echo "Checking the state of run."
else
	touch /var/lib/lkp-files/run_state
	echo "start" > $state_file
fi
current_state=$(cat $state_file)
update_state() {
	echo $1 > $state_file
	current_state=$1
}
state1=start
if [[ $current_state == $state1 ]]; then
	variables=/var/lib/lkp-files/variables
	base_kernel=$(cat $variables | grep base | awk '{print $2}')
	echo "base_kernel: $base_kernel"
	patches_kernel=$(cat $variables | grep patches | awk '{print $2}')
	echo "patches_kernel: $patches_kernel"
	test_bed=$(cat $variables | grep test_bed | awk '{print $2}')
	echo "test_bed: $test_bed"
	stress_type=$(cat $variables| grep stress_type | awk '{print $2}')
	echo "stress_type: $stress_type"
	update_state "captured-variables"
else
	echo "Variables already captured, skipping this step"
fi
state2=captured-variables
if [[ $current_state == $state2 ]]; then
	loc=$(cd ../ && pwd)
	$loc/Hosts_LKP/Pre-Requisites/installation.sh
	update_state "installed-lkp-successfully"
else
	continue
fi

state3=installed-lkp-successfully
if [[ $current_state == $state3 ]];then
	$loc/Hosts_LKP/final/run.sh $test_bed $stress_type
	update_state "run-success"
	echo ""
else
	echo "Install the lkp before running the lkp"
fi
