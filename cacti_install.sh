yum -y install cacti               # Installes a number of packages, including mariadb, httpd, php and so on
yum -y install mariadb-server         # The mysql/mariadb client installs with the cacti stack but not the server
                                   # If you want to have multiple cacti nodes, considder using the client and connecting
                                   # to another server
                                   
yum -y install php-process php-gd php mod_php
yum -y install net-snmp net-snmp-utils                                   
                    
systemctl enable mariadb           # Enable db, apache and snmp (not cacti yet)
systemctl enable httpd
systemctl enable snmpd


systemctl start mariadb           # Start db, apache and snmp (not cacti yet)
systemctl start httpd
systemctl start snmpd

mysqladmin -u root password P@ssw0rd1                               # Set your mysql/mariadb pasword.  here *** is your password
                                                                    # Make a sql script to create a cacti db and grant the cacti user access to it

mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql -u root -pP@ssw0rd1 mysql    # Transfer your local timezone info to mysql

echo "create database cacti;
GRANT ALL ON cacti.* TO cacti@localhost IDENTIFIED BY 'P@ssw0rd1';  # Set this to somthing better than 'cactipass'
FLUSH privileges;
GRANT SELECT ON mysql.time_zone_name TO cacti@localhost;            # Added to fix a timezone issue
flush privileges;" > stuff.sql


mysql -u root  -pP@ssw0rd1 < stuff.sql    # Run your sql script
rpm -ql cacti|grep cacti.sql     # Will list the location of the package cacti sql script
                                 # In this case, the output is /usr/share/doc/cacti-1.0.4/cacti.sql, run that to populate your db

mypath=$(rpm -ql cacti|grep cacti.sql)
mysql cacti < $mypath -u cacti -pP@ssw0rd1
  
#mysql -u cacti -p cacti < /usr/share/doc/cacti-1.0.4/cacti.sql

# Open up apache
sed -i 's/Require host localhost/Require all granted/' /etc/httpd/conf.d/cacti.conf
sed -i 's/Allow from localhost/Allow from all all/' /etc/httpd/conf.d/cacti.conf

# Modify cacti credencials to use user cacti P@ssw0rd1
sed -i "s/\$database_username = 'cactiuser';/\$database_username = 'cacti';/" /etc/cacti/db.php
sed -i "s/\$database_password = 'cactiuser';/\$database_password = 'P@ssw0rd1';/" /etc/cacti/db.php

# Fix the php.ini script
cp /etc/php.ini /etc/php.ini.orig
sed -i 's/;date.timezone =/date.timezone = America\/Regina/' /etc/php.ini

systemctl restart httpd.service

# Set up the cacti cron
sed -i 's/#//g' /etc/cron.d/cacti
setenforce 0


#Install cacti client 
#!/bin/bash
# install snmp and tools
yum -y install net-snmp net-snmp-utils


# create a new snmpd.conf
mv /etc/snmp/snmpd.conf /etc/snmp/snmpd.conf.orig
touch /etc/snmp/snmpd.conf


# edit snmpd.conf file /etc/snmp/snmpd.conf
echo '# create myuser in mygroup authenticating with 'public' community string and source network 10.142.0.0/24
com2sec myUser 10.142.0.0/24 public
# myUser is added into the group 'myGroup' and the permission of the group is defined
group    myGroup    v1        myUser
group    myGroup    v2c        myUser
view all included .1
access myGroup    ""    any    noauth     exact    all    all    none' >> /etc/snmp/snmpd.conf


# Enable snmp, Start snmp
systemctl enable snmpd
systemctl start snmpd
