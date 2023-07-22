#!/bin/bash

#create a service user named alert-manager
useradd -s /bin/false alert-manager

#download the alert-manager package
wget https://github.com/prometheus/alertmanager/releases/download/v0.25.0/alertmanager-0.25.0.linux-amd64.tar.gz

#untar the file
tar xvf alertmanager-0.25.0.linux-amd64.tar.gz

#mkdir in /etc folder
mkdir /etc/alert-manager

#move alertmanager.yml to /etc/alert-manager folder
mv /root/alertmanager-0.25.0.linux-amd64/alertmanager.yml /etc/alert-manager

#Authorize ownership
chown -R alert-manager:alert-manager /etc/alert-manager

#creata a folder in /var/lib
mdkir /var/lib/alert-manager

#Authorize ownership
chown -R alert-manager:alert-manager /var/lib/alert-manager

#copy the executable to /usr/loca/sbin path
cp /root/alertmanager-0.25.0.linux-amd64/alertmanager /usr/local/sbin
cp /root/alertmanager-0.25.0.linux-amd64/amtool /usr/local/sbin

#Authorize ownership
chown alert-manager:alert-manager /usr/local/sbin/alertmanager
chown alert-manager:alert-manager /usr/local/sbin/amtool

#Enter the systemd configuration for alert-manager as service using Here Document
cat <<EOT >/etc/systemd/system/alert-manager.service
[Unit]
Description=alert-manager
Wants=network-target.online
After=network-target.online

[Service]
User=alert-manager
Group=alert-manager
Type=simple
ExecStart=/usr/local/sbin/alert-manager
    
[Install]
WantedBy=multi-user.target
EOT

#Start and enable alert-manager service
systemctl daemon-reload
systemctl start alert-manager
systemctl enable alert-manager
systemctl status alert-manager