#!/bin/bash
# Add more recent rules for Mergstall script entropy v9
sudo bash -c 'echo "+ /etc/sudoers.d/entropy" >> /bin/mergstall.d/config/whitelist.conf' 
sudo bash -c 'echo "- /bin/postinit.d/**" >> /bin/mergstall.d/config/blacklist.conf' 
sudo bash -c 'echo "- /bin/postinit" >> /bin/mergstall.d/config/blacklist.conf'
