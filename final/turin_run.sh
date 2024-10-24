#!/bin/bash


loc=/home/lkp

test_bed_tmp=$1
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
case4=4
#clear the test_bed_file once the runs are completed.
test_bed_file=/var/lib/lkp-file/test_bed.state
test_bed=$(cat $test_bed_file)
if [[ $current_state == $state ]]; then
	if [[ $test_bed == $case1 ]]; then
		sudo rm -rf /lkp/result/hackbench/*
		sudo rm -rf /lkp/result/ebizzy/*
		sudo rm -rf /lkp/result/unixbench/*
		echo "test_bed1"
		$loc/lkp-tests/lkp.sh
		echo "Archiving results"
		cd /lkp/result/
		./result.sh > /var/lib/lkp-files/results/novms.txt
	elif [[ $test_bed == $case2 ]]; then
                sudo rm -rf /lkp/result/hackbench/*
                sudo rm -rf /lkp/result/ebizzy/*
                sudo rm -rf /lkp/result/unixbench/*
		echo "test_bed2"
		if [[ $stress_type == $case1 ]]; then
			echo "stress-ng"
		elif [[ $stress_type == $case2 ]]; then
			echo "vms"
			/var/lib/lkp-files/stop_vms.sh
			/var/lib/lkp-files/start_vms.sh 1
		else
			echo "Invalid option for creating stress"

		fi
		$loc/lkp-tests/lkp.sh
                echo "Archiving results"
                cd /lkp/result/
                ./result.sh > /var/lib/lkp-files/results/vms.txt

	elif [[ $test_bed == $case3 ]]; then
                sudo rm -rf /lkp/result/hackbench/*
                sudo rm -rf /lkp/result/ebizzy/*
                sudo rm -rf /lkp/result/unixbench/*
		echo "test_bed3"
		if [[ $stress_type == $case1 ]]; then
			echo "stress-ng"
		elif [[ $stress_type == $case2 ]]; then
			echo "vms"
			/var/lib/lkp-files/stop_vms.sh 
			/var/lib/lkp-files/start_vms.sh 2
		fi
		$loc/lkp-tests/lkp.sh
                echo "Archiving results"
                cd /lkp/result/
                ./result.sh > /var/lib/lkp-files/results/lkpvms.txt

	elif [[ $test_bed == $case4 ]]; then
		if [ -d /var/lib/lkp-files/results/all ]; then
			rm -rf /var/lib/lkp-files/results/all
		fi
		mkdir /var/lib/lkp-files/results/all
                sudo rm -rf /lkp/result/hackbench/*
                sudo rm -rf /lkp/result/ebizzy/*
                sudo rm -rf /lkp/result/unixbench/*
		echo "Run all test beds"
		$loc/lkp-tests/lkp.sh

		echo "Archiving results"
                cd /lkp/result/
                ./result.sh > /var/lib/lkp-files/results/all/novms.txt
		sudo rm -rf /lkp/result/hackbench/*
                sudo rm -rf /lkp/result/ebizzy/*
                sudo rm -rf /lkp/result/unixbench/*

		if [[ $stress_type == $case1 ]]; then
			echo "stres-ng"
		elif [[ $stress_type == $case2 ]]; then
			echo "vms"
			/var/lib/lkp-files/stop_vms.sh
			/var/lib/lkp-files/start_vms.sh 1
		else
			echo "Invalid Stress type"
		fi
		$loc/lkp-tests/lkp.sh
                echo "Archiving results"
                cd /lkp/result/
                ./result.sh > /var/lib/lkp-files/results/vms.txt

                sudo rm -rf /lkp/result/hackbench/*
                sudo rm -rf /lkp/result/ebizzy/*
                sudo rm -rf /lkp/result/unixbench/*

                if [[ $stress_type == $case1 ]]; then
                        echo "stres-ng"
                elif [[ $stress_type == $case2 ]]; then
                        echo "vms"
                        /var/lib/lkp-files/stop_vms.sh
                        /var/lib/lkp-files/start_vms.sh 2
                else
                        echo "Invalid Stress type"
                fi
                $loc/lkp-tests/lkp.sh
                echo "Archiving results"
                cd /lkp/result/
                ./result.sh > /var/lib/lkp-files/results/lkpvms.txt

                sudo rm -rf /lkp/result/hackbench/*
                sudo rm -rf /lkp/result/ebizzy/*
                sudo rm -rf /lkp/result/unixbench/*


	else
		echo "Invalid option for Running test_bed"
	fi
fi
