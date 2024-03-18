import matplotlib.pyplot as plt
import pandas as pd

from scapy.all import *



def process_with_scapy(fileName):
    protocol_count = {}

    pcap_data = rdpcap(fileName)
    sessions = pcap_data.sessions()
    for session in sessions:
        for packet in sessions[session]:
            for i in range(len(packet.layers())):
                layer = packet.getlayer(i)
                protocol = layer.name

                # Count the number of occurences for each protocol type
                if protocol not in protocol_count: protocol_count[protocol] = 1
                else: protocol_count[protocol] += 1

    # Sort the dictionary in descending order
    protocol_count = dict(sorted(protocol_count.items(), key=lambda item: item[1], reverse=True))
    
    # Print the output
    for protocol in protocol_count:
        print(f'{protocol_count[protocol]} packets have layer "{protocol}"')




p = rdpcap("trace/Chrome_Eduroam_downloading_txtfile_from_Onedrive/ssl_capture.pcap")

print(p[0].name)