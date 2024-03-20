import numpy as np
import matplotlib.pyplot as plt
import pyshark as ps
import argparse
import os

# this code helps us to sort only the most important packet that are related to microsoft Onedrive

# Only part of URL because the subdomain can change through the day or change due to the geolocation of host
URLOneDrive=["sharepoint.com","akadns.net","spo-msedge.net", "azure.com", "office.net","office.com", "edgekey.net", "akamaiedge.net", "akadns.net", "aureedge.net", "omegacdn.net", "microsoftonline.com", "msidentity.com", "trafficmanager.net", "akamai.com", "microsoft.com", "azure-dns.com", "svc.ms", "dns-tm.com", "skype.com", "s-msedge.net", "msftauth.net"]

def is_dns_response(packet):
    response_tag=0x8180
    if 'DNS' in packet and int(packet.dns.Flags, 16) == 0x8180:
        return True
    return False
    

def cleaningCapture(foldername, save=False, URLOneDrive=[], LOG=False):
    # TODO
    print(f"FolderName: {foldername:<20} Save ? {save:<5} Log ? {LOG:<5}")
    print(f"Amount URL: {len(URLOneDrive):<5} ")
    
    IPdict = {}
    for url in URLOneDrive:
        IPdict[url] = {"A": [], "AAAA":[]}
    
    # Load the pcap
    capture = ps.FileCapture(f"trace/{foldername}/ssl_capture.pcap")
    
    # Filter the packets using the DNS resolving the URL
    for i in range(10):
        if is_dns_response(capture[i]):
            # Adding the IP inside the dic
            print(capture[i].dns.qry_name)
            
            # Type of DNS record
            print(dir(capture[i].dns))
            
            if capture[i].dns.qry_name in URLOneDrive:
                print("let's go")
        print("_________________")
    
    return -1


# Build the Parser of arguments
parser = argparse.ArgumentParser(description='Analyse a pcap file')
# it takes a name of a folder
parser.add_argument('file', type=str, help='the folder name with pcap files to analyse')
# Option to save the cleaned pcap file
parser.add_argument('--save', action='store_true', help='Save the cleaned pcap file')


if __name__ == "__main__":
    args = parser.parse_args()
    # Check if it's in a folder
    SAVE=args.save
    cwd = os.getcwd()
    if args.file in os.listdir(cwd+"/trace"):
        print("Valid")
    else:
        print("Not a valid folder")
        exit(1)
        
    # Check if we have the log
    if args.file+".log" in os.listdir(cwd):
        print("We have the Log to decrypt")
        LOG=True
    else:  
        print("We don't have the Log to decrypt")
        LOG=False
        
    cleaningCapture(args.file, save=SAVE, URLOneDrive=URLOneDrive, LOG=LOG)
        
    