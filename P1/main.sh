#!/bin/bash

# Script that will capture packet to onedrive and save SSL handshake in SSLKEYLOGFILE

# COLOR for echo
RED='\033[0;31m'
NC='\033[0m' # No Color
GREEN='\033[0;32m'
BLUE='\033[0;34m'
WHITE='\033[1;37m'

# Check if the user is connected to the internet
if ping 1.1.1.1 -c 1 -W 1 &> /dev/null
then
  echo "Connected to the internet"
else
  echo "Not connected to the internet"
  exit
fi

# Kill all running firefox instances
echo "------ Killing all running firefox instances ------"
pkill -f firefox

# Get the current date
date=$(date +"%m-%d_%H-%M-%S")

# Start the capture of the packets
echo "------ Starting the capture of the packets ------"
sudo tcpdump -Z $USER -U -i any -w trace/${date}_noise_capture.pcap &
tcpdump_pid=$!

echo -e "${GREEN}Capture Noise started${NC}"

sleep 10


# Create the SSLKEYLOGFILE
SSLKEYLOGFILE=${date}_sslkeylog.log
export SSLKEYLOGFILE=${SSLKEYLOGFILE}
firefox https://uclouvain-my.sharepoint.com/ &
firefox_pid=$!
echo -e "${GREEN}Firefox started${NC}"

sudo tcpdump -Z $USER -U -i any -w trace/${date}_ssl_capture.pcap &
tcpdump_firefox_pid=$!
echo -e "${GREEN}Capture Firefox started${NC}"

wait $firefox_pid
echo -e "${GREEN}Firefox stopped${NC}"

kill $tcpdump_firefox_pid
kill $tcpdump_pid

echo -e "${GREEN}Used Bazooka to kill all process${NC}"
sudo pkill tcpdump

echo -e "${GREEN}Capture Noise stopped${NC}"
echo -e "${WHITE}"