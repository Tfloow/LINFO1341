# import 
import numpy as np
import matplotlib.pyplot as plt
import pyshark as ps

Routeur = "192.168.1.1" # Adresse IP du routeur qu'il accède en IPV4
serveur = "2620:1ec:8fa::10" # Adresse IPV6 de OneDrive

refresh_data = ps.FileCapture("trace/refresh.pcap", display_filter=f"ipv6.addr=={serveur}")

i = 0
while True:
    try:
        print(refresh_data[i])
        i += 1
    except:
        break

#print(refresh_data[0])
#print(refresh_data)
