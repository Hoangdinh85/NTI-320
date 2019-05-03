for servername in $(gcloud compute instances list | awk '{print $1}' | sed "1 d" | grep -v nagios-a );  do 
    gcloud compute ssh --zone us-east4-c hdinh47056@servername --command=sudo 'yum -y install wget&& wget https://raw.githubusercontent.com/Hoangdinh85/NTI-320/master/web-b && sudo bash web-b
done
