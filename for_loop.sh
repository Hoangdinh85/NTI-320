#!/bin/bash

for servername in $(gcloud compute instances list | awk '{print $1}' | sed "1 d" | grep -v nagios-a );  do 
    echo $servername;
    serverip=$( gcloud compute instances list | grep $servername | awk '{print $4}');
    echo $serverip ;
done
gcloud compute ssh hdinh47056@nagios-a --command='sudo systemctl restart nagio'
