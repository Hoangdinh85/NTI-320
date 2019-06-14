#!/bin/bash

for servername in $(gcloud compute instances list | awk '{print $1}' | sed "1 d" | grep -v repos-srv );  do 
    echo $servername;
    serverip=$( gcloud compute instances list | grep $servername | awk '{print $4}');
    echo $serverip ;
    bash NTI-320/for_loop_repos.sh $servername $serverip
done
#gcloud compute ssh --zone us-west1-b hdinh47056@nagios1 --command='sudo systemctl restart nagios'
