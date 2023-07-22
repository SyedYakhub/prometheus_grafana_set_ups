#!/bin/bash

#Create service user with no interactive shell
useradd -s /bin/false prometheus

#Create a directory named prometheus in /etc folder to add configuration files
mkdir /etc/prometheus

#Create a directory named prometheus in /var/lib folder to add data files
mkdir /var/lib/prometheus

#Authorize ownership and permission
chown prometheus:prometheus /etc/prometheus
chown prometheus:prometheus /var/lib/prometheus

#Download the software now based on the OS
wget https://github.com/prometheus/prometheus/releases/download/v2.37.8/prometheus-2.37.8.linux-amd64.tar.gz

#untar the file
tar xvf prometheus-2.37.8.linux-amd64.tar.gz

#copy prometheus executable and promtool to your cli excutable path
cp /root/prometheus-2.37.8.linux-amd64/prometheus /usr/local/sbin/
cp /root/prometheus-2.37.8.linux-amd64/promtool /usr/local/sbin/

#Authorize ownership
chown prometheus:prometheus /usr/local/sbin/prometheus
chown prometheus:prometheus /usr/local/sbin/promtool

#copy console and console-libraries
cp -r /root/prometheus-2.37.8.linux-amd64/consoles /etc/prometheus/
cp -r /root/prometheus-2.37.8.linux-amd64/console_libraries /etc/prometheus/

#Authorize ownership
chown -R prometheus:prometheus /etc/prometheus/consoles
chown -R prometheus:prometheus /etc/prometheus/console_libraries

#copy prometheus.yml to /ect/prmoetheus
cp /root/prometheus-2.37.8.linux-amd64/prometheus.yml /etc/prometheus/
chown /root/prometheus-2.37.8.linux-amd64/prometheus:prometheus /etc/prometheus/prometheus.yml

#type the systemd configuration for prometheus as service using Here Document
cat <<EOT >/etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus
Wants=network-target.online
After=network-target.online

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/sbin/prometheus \
    --config.file /etc/prometheus/prometheus.yml \
    --storage.tsdb.path /var/lib/prometheus/ \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target
EOT

#Start and enable prometheus service
systemctl daemon-reload
systemctl start prometheus
systemctl enable prometheus
systemctl status prometheus