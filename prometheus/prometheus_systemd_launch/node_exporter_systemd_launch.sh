#!/bin/bash

#create a service user named node_exporter
useradd -s /bin/false node_exporter

#download the node exporter package
wget https://github.com/prometheus/node_exporter/releases/download/v1.6.1/node_exporter-1.6.1.linux-amd64.tar.gz

#untar the file
tar xvf node_exporter-1.6.1.linux-amd64.tar.gz

#copy the executable to /usr/loca/sbin path
cp /root/node_exporter-1.6.1.linux-amd64/node_exporter /usr/local/sbin

#Authorize ownership
chown node_exporter:node_exporter /usr/local/sbin/node_exporter

#Enter the systemd configuration for node_exporter as service using Here Document
cat <<EOT >/etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
Wants=network-target.online
After=network-target.online

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/sbin/node_exporter
    
[Install]
WantedBy=multi-user.target
EOT

#Start and enable prometheus service
systemctl daemon-reload
systemctl start node_exporter
systemctl enable node_exporter
systemctl status node_exporter