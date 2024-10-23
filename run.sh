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
update_state() {
	echo $1 > $state_file
}
current_state=$(cat $state_file)
state1=start
if [[ $current_state == $state1 ]]; then
	variables=/var/lib/lkp-files/variables
	base_kernel=$(cat $variables | grep base | awk '{print $2}')
	echo "base_kernel: $base_kernel"
	patches_kernel=$(cat $variables | grep patches | awk '{print $2}')
	echo "patches_kernel: $patches_kernel"
	test_bed=$
	update_state "captured-variables"
else
	echo "Variables already captured, skipping this step"
fi
