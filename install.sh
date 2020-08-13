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
echo "Ensure that you have an active Internet connection with an acceptable speed (at least 10Mbps recommended)"
# First step is to check whether you are logged in as root
# and which Ubuntu version is running. Carius requires 18.04 or later

if [[ `id -u` != 0 ]]; then
echo "Must be root to run script"
exit
fi

wget -q --spider http://google.com

if [ $? -eq 0 ]; then
echo "There is an active Internet connection"
else
echo "Offline. Check your Internet connection"
exit
fi

UbuntuRelease=$(lsb_release -rs)

if [ "`echo "${UbuntuRelease} < 18.04" | bc`" -eq 1 ]; then
echo "System requirement is Ubuntu LTS 18.04 or higher"
exit
else
IFS=':' read -r var1 var2 <<< "$(lsb_release -d)"
echo "Installing Carius on $var2"
fi

# Create tftp folder

if [ ! -d "/home/tftpboot" ]; then
mkdir /home/tftpboot
fi

chmod -R 777 /home/tftpboot
chown -R tftp /home/tftpboot

# Create the configuration file for TFTP

cat > /etc/default/tftpd-hpa  << ENDOFFILE
# /etc/default/tftpd-hpa
TFTP_USERNAME="tftp"
TFTP_DIRECTORY="/home/tftpboot"
TFTP_ADDRESS=":69"
TFTP_OPTIONS="--secure"
ENDOFFILE

# Restart TFTP daemon

service tftpd-hpa restart

# Install the Python modules


# Mysql user, database and table structure creation
# Depending on the Mysql version, the structure is different

varA=($(echo $(mysql -uroot -e "select version();") | tr ')' '\n'))
varB=($(echo "${varA[1]}" | tr '-' '\n'))
varC=($(echo "${varB[0]}" | tr '.' '\n'))
mysqlversion=${varC[0]}${varC[1]}

echo ""
echo ""
echo " Configure the database"
if [[ "$mysqlversion" < "80" ]] ;
then
 mysql -uroot < ./doc/mysqltable57.txt
else
 mysql -uroot < ./doc/mysqltable80.txt
fi

echo " Installing the app"
cp ./__init__.py /var/www/html/__init__.py  > /dev/null
cp ./startapp.sh /var/www/html/startapp.sh  > /dev/null
cp ./views/ /var/www/html/ -r > /dev/null
cp ./static/ /var/www/html/ -r > /dev/null
cp ./templates/ /var/www/html/ -r > /dev/null
cp ./classes/ /var/www/html/ -r > /dev/null
cp ./bash/ /var/www/html/ -r > /dev/null
cp ./bash/ztpdhcp6k.cfg /home/tftpboot/ztpdhcp6k.cfg > /dev/null
cp ./bash/ztpdhcp8k.cfg /home/tftpboot/ztpdhcp8k.cfg > /dev/null

if [ ! -d "/var/www/html/images" ]; then
mkdir /var/www/html/images
fi
chmod 777 /var/www/html/images/
chmod 777 /var/www/html/images

echo " Configuring the app"

activeInterface=$(route | grep '^default' | grep -o '[^ ]*$')
cat > /var/www/html/bash/globals.json  << ENDOFFILE
{"idle_timeout": "3000", "pcap_location": "/var/www/html/bash/trace.pcap", "retain_dhcp": "15", "retain_snmp": "15", "retain_ztplog": "5", "retain_listenerlog": "5", "retain_cleanuplog": "5", "retain_topologylog": "5","retain_syslog": "15","retain_telemetrylog": "5","secret_key": "ArubaRocks!!!!!!", "appPath": "/var/www/html/", "softwareRelease": "2.0", "sysInfo": "","activeInterface":"$activeInterface","ztppassword":"ztpinit","landingpage":"/"}
ENDOFFILE
chmod 777 /var/www/html/bash/listener.sh
chmod 777 /var/www/html/bash/cleanup.sh
chmod 777 /var/www/html/bash/topology.sh
chmod 777 /var/www/html/bash/ztp.sh
chmod 777 /var/www/html/bash/telemetry.sh


if [ ! -d "/var/www/html/log" ]; then
mkdir /var/www/html/log
fi

touch /var/www/html/log/cleanup.log
touch /var/www/html/log/topology.log
touch /var/www/html/log/ztp.log
touch /var/www/html/log/listener.log
touch /var/www/html/log/telemetry.log

chmod 777 /var/www/html/log/

dos2unix -q /var/www/html/startapp.sh >/dev/null
dos2unix -q /var/www/html/bash/listener.sh >/dev/null
dos2unix -q /var/www/html/bash/cleanup.sh >/dev/null
dos2unix -q /var/www/html/bash/topology.sh >/dev/null
dos2unix -q /var/www/html/bash/ztp.sh >/dev/null
dos2unix -q /var/www/html/bash/telemetry.sh >/dev/null
chmod 777 /var/www/html/startapp.sh
chmod +x /var/www/html/startapp.sh

tput cnorm

echo " ######### Carius 2.0 installation completed ##########"
echo " Navigate with your browser to http://a.b.c.d:8080   where a.b.c.d is the IP address of the Carius server"
echo " The default login credentials are:"
echo " Username:  admin"
echo " There is no password, you are prompted to change the admin password after login as admin user"
echo ""
