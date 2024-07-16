#!/bin/bash
rm -rf /usr/bin/pmg-gmail
cp -rf pmg-gsuite.sh /usr/bin/pmg-gmail
chmod +x /usr/bin/pmg-gmail

cp -rf pmg-gmail.service /etc/systemd/system/pmg-gmail.service
systemctl daemon-reload
systemctl enable pmg-gmail
systemctl start pmg-gmail
