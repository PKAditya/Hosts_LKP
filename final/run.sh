#!/bin/bash


loc=/home/lkp

test_bed=$1
stress_type=$2
state_file=/var/lib/run_state
current_state=$(cat $state_file)
update_state() {
	echo $1 > "$state_file"
	current_state=$1
}

state=installed-lkp-successfully
case1=1
case2=2
case3=3
if [[ $current_state == $state ]]; then
	if [[ $test_bed == $case1 ]]; then
		echo "test_bed1"
		$loc/lkp-tests/lkp.sh
	elif [[ $test_bed == $case2 ]]; then
		echo "test_bed2"
		$loc/lkp-tests/lkp.sh
		if [[ $stress_type == $case1 ]]; then
			echo "stress-ng"
		elif [[ $stress_type == $case2 ]]; then
			echo "vms"
		else
			echo "Invalid option for creating stress"

		fi

	elif [[ $test_bed == $case3 ]]; then
		echo "test_bed3"
	else
		echo "Invalid option for Running test_bed"
	fi
fi
