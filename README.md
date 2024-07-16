# pmg-gmail
G-mail Trusted Hosts for Proxmox Mail Gateway

Tested on Proxmox Mail Gateway 8.1.2

**Features**

- Automatically delete all trusted hosts
- Populate with Google IPV4 addresses from _spf.google.com
- Please see https://apps.google.com/supportwidget/articlehome?hl=en&article_url=https%3A%2F%2Fsupport.google.com%2Fa%2Fanswer%2F60764%3Fhl%3Den&assistant_id=generic-unu&product_context=60764&product_name=UnuFlow&trigger_context=a

**Installation**

- Clone this repository
- chmod +x *.sh
- ./install.sh
- Run systemctl status pmg-gmail.service and wait for it to sleep.
