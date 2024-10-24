#!/bin/bash
pip install pyfiglet &> /dev/null
python -m pyfiglet "LKP TESTS"
export HISTIGNORE='*sudo -S*'

user=$(echo $USER)
distro=$(cat /etc/os-release | grep ^ID= | cut -d'=' -f2)

loc=$1/Hosts_LKP/Pre-Requisites

echo "DISTRO FOUND: $distro"
echo "CURRENT USER: $user"
echo " "
if [ "$distro" == "ubuntu" ]; then
  if [ "$user" == "amd" ]; then
          echo 'Amd$1234!' | sudo -S $loc/ubuntu-installation.sh $loc
  else
          sudo $loc/ubuntu-installation.sh $loc
  fi
else
  if [ "$user" == "amd" ]; then
          echo 'Amd$1234!' |  sudo -S $loc/centos-installation.sh $loc
  else
          sudo $loc/centos-installation.sh $loc
  fi
fi

