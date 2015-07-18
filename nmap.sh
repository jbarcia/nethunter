#!/bin/bash
# Script to scan current network using Nmap


interface_select(){
clear
echo "Select which interface to scan on [1-4]:"
echo
echo "1. eth0 (USB Ethernet adapter)"
echo "2. wlan0 (internal Wifi)"
echo "3. wlan1 (USB TP-Link adapter or other)"
echo "4. at0 (Use with EvilAP)"
echo
read -p "Choice [1-4]: " interfacechoice


case $interfacechoice in
1) interface=eth0 ;;
2) interface=wlan0 ;;
3) interface=wlan1 ;;
4) interface=at0 ;;
*) interface_select ;;
esac
}


one_two(){
read -p "Choice [1-2]: " input
case $input in
[1-2]*) echo $input ;;
*) one_two ;;
esac
}


start_the_scan(){


network=$(ifconfig $interface | awk -F ":"'/inet addr/{split($2,a," ");print a[1]}'|awk -F'.''{print $1"."$2"."$3"."}')


cd /captures/nmap/


filename1="/captures/nmap/host_scan_$(date +%F-%H%M).txt"
filename2="/captures/nmap/service_scan_$(date +%F-%H%M).txt"



myip=$(ifconfig $interface | awk -F ":" '/inet addr/{split($2,a," ");print a[1]}')##thanks to secjunkie
sed -i "/$myip/d" $filename1 ##thanks to secjunkie


nmap -sP $network* -oG $filename1##thanks to secjunkie
echo
echo "Scan results saved to $filename1"
echo


echo "[?] Run a service scan against the discovered?"
echo
echo "1. Yes"
echo "2. No"
echo


scandiscov=$(one_two)


if [ $scandiscov -eq 1 ]; then
nmap -sV $network* |tee $filename2
echo
echo "Results completed saved to $filename2"
echo
echo
fi
}


interface_select
start_the_scan
