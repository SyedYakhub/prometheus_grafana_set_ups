#!/bin/bash

#use openssl command and generate key and cert
openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 -keyout node_exporter.key -out node_exporter.crt -subj "/C=US/ST=California/L=Oakland/0=My0rg/CN=localhost" -addext "subjectAltName = DNS:localhost"

#Generate Hash password for encrypting the packets transfer
apt install apache2-utils
htpasswd -nBC 12 "" | tr -d ':\n'

#create config.yml and add key and crt files
cat <<EOT >config.yml
tls_server_config
  cert_file: node_exporter.crt
  key_file: node_exporter.key
basic_auth_users:
  prmoetheus: <hashpassword>
EOT

#update the node_exporter process to make use of config.yml file
./node_exporter --web.config=config.yml

#create a folder node_exporter in /etc
mkdir /etc/node_exporter
mv node_exporter.* /etc/node_exporter
cp config.yml /ect/node_exporter

#authorize ownership
chown -R node_exporter:node_exporter /etc/node_exporter

#update node_exporter.service
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
web.config=/etc/node_exporter/config.yml
    
[Install]
WantedBy=multi-user.target
EOT

#restart and enable prometheus service
systemctl daemon-reload
systemctl restart node_exporter
systemctl status node_exporter

#Check using curl -K command
curl -K http://localhost:9100/metrics

#copy node_exporter.crt to prometheus server
#scp node_exporter.crt username@host:/tmp
#enter password
#move the file to /etc/prometheus

#Authorize permissions
chown prometheus:prometheus /etc/prometheus/node_exporter.crt

#update prometheus.yml file 
#scheme=https
#basic_auth:
    #username: prometheus
    #password: password
#tls_config:
  #ca_file: /etc/prometheus/node_exporter.crt
  #insecure_skip_verify: true

#restart and enable prometheus service
systemctl daemon-reload
systemctl restart prometheus
systemctl status prometheus



