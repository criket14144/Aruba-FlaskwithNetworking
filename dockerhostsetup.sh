spinner()
{
local pid=$1
local delay=0.1
local spinstr='|/-\'
echo "$pid" > "/tmp/.spinner.pid"
echo ""
printf " $2 "
while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
local temp=${spinstr#?}
printf " [%c]  " "$spinstr"
local spinstr=$temp${spinstr%"$temp"}
sleep $delay
printf "\b\b\b\b\b\b"
done
printf "    \b\b\b\b"
}

tput reset
tput civis


echo "########## Carius 2.0 Installation ##########"


# Create the configuration file for TFTP


# Install the Python modules


# Mysql user, database and table structure creation
# Depending on the Mysql version, the structure is different

"varA=($(echo $(mysql -uroot -e "select version();") | tr ')' '\n'))
varB=($(echo "${varA[1]}" | tr '-' '\n'))
varC=($(echo "${varB[0]}" | tr '.' '\n'))
mysqlversion=${varC[0]}${varC[1]}

echo ""
echo ""
echo " Configure the database"
if [[ "$mysqlversion" < "80" ]] ;
then
 mysql -uroot < /Aruba-FlaskwithNetworking/doc/mysqltable57.txt
else
 mysql -uroot < /Aruba-FlaskwithNetworking/doc/mysqltable80.txt
fi"

echo " Installing the app"
cp /Aruba-FlaskwithNetworking/__init__.py /docker/arubaautomation/var/www/html/__init__.py  > /dev/null
cp /Aruba-FlaskwithNetworking/startapp.sh /docker/arubaautomation/var/www/html/startapp.sh  > /dev/null
cp /Aruba-FlaskwithNetworking/views/ /docker/arubaautomation/var/www/html/ -r > /dev/null
cp /Aruba-FlaskwithNetworking/static/ /docker/arubaautomation/var/www/html/ -r > /dev/null
cp /Aruba-FlaskwithNetworking/templates/ /docker/arubaautomation/var/www/html/ -r > /dev/null
cp /Aruba-FlaskwithNetworking/classes/ /docker/arubaautomation/var/www/html/ -r > /dev/null
cp /Aruba-FlaskwithNetworking/bash/ /docker/arubaautomation/var/www/html/ -r > /dev/null
cp /Aruba-FlaskwithNetworking/bash/ztpdhcp6k.cfg /home/tftpboot/ztpdhcp6k.cfg > /dev/null
cp /Aruba-FlaskwithNetworking/bash/ztpdhcp8k.cfg /home/tftpboot/ztpdhcp8k.cfg > /dev/null

if [ ! -d "/var/www/html/images" ]; then
mkdir /var/www/html/images
fi
chmod 777 /docker/arubaautomation/var/www/html/images/
chmod 777 /docker/arubaautomation/var/www/html/images

echo " Configuring the app"

activeInterface=$(route | grep '^default' | grep -o '[^ ]*$')
cat > /var/www/html/bash/globals.json  << ENDOFFILE
{"idle_timeout": "3000", "pcap_location": "/var/www/html/bash/trace.pcap", "retain_dhcp": "15", "retain_snmp": "15", "retain_ztplog": "5", "retain_listenerlog": "5", "retain_cleanuplog": "5", "retain_topologylog": "5","retain_syslog": "15","retain_telemetrylog": "5","secret_key": "ArubaRocks!!!!!!", "appPath": "/var/www/html/", "softwareRelease": "2.0", "sysInfo": "","activeInterface":"$activeInterface","ztppassword":"ztpinit","landingpage":"/"}
ENDOFFILE
chmod 777 /docker/arubaautomation/var/www/html/bash/listener.sh
chmod 777 /docker/arubaautomation/var/www/html/bash/cleanup.sh
chmod 777 /docker/arubaautomation/var/www/html/bash/topology.sh
chmod 777 /docker/arubaautomation/var/www/html/bash/ztp.sh
chmod 777 /docker/arubaautomation/var/www/html/bash/telemetry.sh


if [ ! -d "/var/www/html/log" ]; then
mkdir /var/www/html/log
fi

touch /docker/arubaautomation/var/www/html/log/cleanup.log
touch /docker/arubaautomation/var/www/html/log/topology.log
touch /docker/arubaautomation/var/www/html/log/ztp.log
touch /docker/arubaautomation/var/www/html/log/listener.log
touch /docker/arubaautomation/var/www/html/log/telemetry.log

chmod 777 /var/www/html/log/

dos2unix -q /docker/arubaautomation/var/www/html/startapp.sh >/dev/null
dos2unix -q /docker/arubaautomation/var/www/html/bash/listener.sh >/dev/null
dos2unix -q /docker/arubaautomation/var/www/html/bash/cleanup.sh >/dev/null
dos2unix -q /docker/arubaautomation/var/www/html/bash/topology.sh >/dev/null
dos2unix -q /docker/arubaautomation/var/www/html/bash/ztp.sh >/dev/null
dos2unix -q /docker/arubaautomation/var/www/html/bash/telemetry.sh >/dev/null
chmod 777 /var/www/html/startapp.sh
chmod +x /var/www/html/startapp.sh

tput cnorm

echo " ######### Carius 2.0 installation completed ##########"
