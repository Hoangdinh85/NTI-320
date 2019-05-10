#!/bin/bash
bash generate_config.sh $1 $2
gcloud compute scp --zone us-east4-c $1.cfg hdinh47056@nagios1:/etc/nagios/servers
# Note: I had to add user hdinh47056 to group nagios using usermod -a -G nagios hdinh47056
# I also had to chmod 775 /etc/nagios/servers
#usermod -a -G nagios hdinh47056
gcloud compute ssh --zone us-east4-c hdinh47056@nagios1 --command='sudo /usr/sbin/nagios -v /etc/nagios/nagios.cfg'
