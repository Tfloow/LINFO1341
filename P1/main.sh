#!/bin/bash

# Script that will capture packet to onedrive and save SSL handshake in SSLKEYLOGFILE

# COLOR for echo
RED='\033[0;31m'
NC='\033[0m' # No Color
GREEN='\033[0;32m'
BLUE='\033[0;34m'
WHITE='\033[1;37m'

# Check if the user is connected to the internet
if ping 1.1.1.1 -c 1 -W 1 > /dev/null
then
  echo "Connected to the internet"
else
  echo "Not connected to the internet"
  exit
fi

# Kill all running chrome instances
echo "------ Killing all running chrome instances ------"
sudo pkill -f google-chrome

# Get the current date
date=$(date +"%m-%d_%H-%M-%S")
sudo mkdir trace/$date

# Start the capture of the packets
echo "------ Starting the capture of the packets ------"
sudo tcpdump -Z $USER -U -i any -w trace/${date}/noise_capture.pcap > /dev/null 2>&1 &
tcpdump_pid=$!

echo -e "${GREEN}Capture Noise started${NC}"

sleep 5


# Create the SSLKEYLOGFILE
SSLKEYLOGFILE=${date}_sslkeylog.log
export SSLKEYLOGFILE=${SSLKEYLOGFILE}

sudo tcpdump -Z $USER -U -i any -w trace/${date}/ssl_capture.pcap > /dev/null 2>&1 &
tcpdump_chrome_pid=$!

echo -e "${GREEN}Capture chrome started${NC}"
sleep 5

google-chrome "https://uclouvain-my.sharepoint.com/personal/thomas_debelle_student_uclouvain_be/_layouts/15/onedrive.aspx?e=5%3Aa467040015a74b5e8c12974e599f66db&at=9&CT=1710147896600&OR=OWA%2DNT%2DMail&CID=07254add%2Da8bd%2D72f8%2D30a4%2Dc4fcf52eccc0&FolderCTID=0x01200073E791050F17434C8FA5E0C5036796B5&sw=auth&id=%2Fpersonal%2Fthomas%5Fdebelle%5Fstudent%5Fuclouvain%5Fbe%2FDocuments%2FQ6%2FLINFO1341%2FP1&view=0" > /dev/null 2>&1 &
chrome_pid=$!
echo -e "${GREEN}chrome started${NC}"

wait $chrome_pid
echo -e "${GREEN}chrome stopped${NC}"

sudo kill $tcpdump_chrome_pid
sudo kill $tcpdump_pid

echo -e "${GREEN}Used Bazooka to kill all process${NC}"
sudo pkill tcpdump

echo -e "${GREEN}Capture Noise stopped${NC}"
echo -e "${WHITE}"