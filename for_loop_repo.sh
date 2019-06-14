#!/bin/bash    
for servername in $( gcloud compute instances list | awk '{print $1}' | sed "1 d" | grep -v repos-srv );  do gcloud compute ssh --zone us-west1-b hdinh47056@$servername --command='sudo yum -y install wget && sudo wget https://raw.githubusercontent.com/Hoangdinh85/NTI-320/master/repos_client.sh && sudo bash repos_client.sh'; done
