# Aruba Networks app that allows you to:
- Monitor AOS-CX, AOS-Switch, ClearPass and Mobility controllers
- Telemetry with AOS-CX (Websockets)
- Perform Zero Touch Provisioning on AOS-CX switches
- Simple topology view
- SNMP, Syslog and DHCP tracker
- Role Based Access Control
- And more...

1.	Install Docker and docker-compose per OS documentation
2.	Install dos2unix (apt-get/yum install dos2unix)
3.	git clone  https://github.com/criket14144/Aruba-FlaskwithNetworking.git
4.	cd Aruba-FlaskwithNetworking
5.	sudo chmod +x dockerhostsetup.sh
6.	docker-compose -d up mysql
7.	docker exec -it mysql /bin/bash
8.	mysql -u root -p       Testing123 is the password
9.	Paste the contents of Aruba-FlaskwithNetworking/doc/mysqltable80.txt
10.	quit;
11.	exit
12.	docker-compose up -d
